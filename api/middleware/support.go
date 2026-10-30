/*
 * Copyright (C) 2026 Nethesis S.r.l.
 * http://www.nethesis.it - info@nethesis.it
 *
 * This file is part of NethVoice Report project.
 *
 * NethVoice Report is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License,
 * or any later version.
 *
 * NethVoice Report is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with NethVoice Report.  If not, see COPYING.
 */

package middleware

import (
	"crypto/sha1"
	"crypto/subtle"
	"fmt"
	"net/http"
	"regexp"
	"sync"
	"time"

	jwt "github.com/appleboy/gin-jwt/v2"
	"github.com/gin-gonic/gin"
	"github.com/pkg/errors"

	"github.com/nethesis/nethvoice-report/api/methods"
	"github.com/nethesis/nethvoice-report/api/utils"
)

const (
	supportUserKey      = "support_user"
	supportExpKey       = "support_exp"
	supportExpireCtxKey = "support_expire"
	supportTokenTimeout = time.Hour
	supportCheckTTL     = time.Minute

	// Same message as an expired JWT, which makes the UI show the login page.
	supportExpiredMessage = "Token is expired"
)

// Matches the ephemeral ampusers row created by the support tunnel-client.
var supportUsernameRe = regexp.MustCompile(`^support-[a-z0-9-]{1,64}$`)

// supportLogin is the identity of a support session: it is authorized as
// admin, but the token keeps the real user and a short expiration.
type supportLogin struct {
	User   string
	Expire time.Time
}

// Replaced in tests.
var supportUserExists = methods.SupportUserExists

var (
	supportSeenMu sync.Mutex
	supportSeen   = make(map[string]time.Time)
)

func sha1Matches(password string, storedHash string) bool {
	hash := fmt.Sprintf("%x", sha1.Sum([]byte(password)))
	return storedHash != "" && subtle.ConstantTimeCompare([]byte(hash), []byte(storedHash)) == 1
}

func markSupportUserSeen(user string) {
	supportSeenMu.Lock()
	supportSeen[user] = time.Now()
	supportSeenMu.Unlock()
}

// supportUserStillExists checks that the ampusers row was not removed at the
// end of the support session, caching positive answers for supportCheckTTL.
func supportUserStillExists(user string) bool {
	supportSeenMu.Lock()
	seen, ok := supportSeen[user]
	supportSeenMu.Unlock()
	if ok && time.Since(seen) < supportCheckTTL {
		return true
	}

	exists, err := supportUserExists(user)
	if err != nil {
		utils.LogError(errors.Wrap(err, "error checking support user "+user))
	}
	if err != nil || !exists {
		supportSeenMu.Lock()
		delete(supportSeen, user)
		supportSeenMu.Unlock()
		return false
	}

	markSupportUserSeen(user)
	return true
}

// validSupportClaims reports whether the token carries a support identity
// and, if so, whether it is still valid and until when.
func validSupportClaims(claims map[string]interface{}) (expire time.Time, isSupport bool, valid bool) {
	raw, isSupport := claims[supportUserKey]
	if !isSupport {
		return time.Time{}, false, false
	}

	user, ok := raw.(string)
	if !ok || !supportUsernameRe.MatchString(user) {
		return time.Time{}, true, false
	}
	exp, ok := claims[supportExpKey].(float64)
	if !ok {
		return time.Time{}, true, false
	}
	expire = time.Unix(int64(exp), 0)
	if !time.Now().Before(expire) {
		return expire, true, false
	}

	return expire, true, supportUserStillExists(user)
}

// SupportSession rejects support tokens once expired or once the support
// user has been removed from ampusers.
func SupportSession() gin.HandlerFunc {
	return func(c *gin.Context) {
		if _, isSupport, valid := validSupportClaims(jwt.ExtractClaims(c)); isSupport && !valid {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"message": supportExpiredMessage})
			return
		}
		c.Next()
	}
}

// RefreshHandler never extends a support token: a still valid one is
// returned unchanged, so a page reload keeps working until it expires.
func RefreshHandler(mw *jwt.GinJWTMiddleware) gin.HandlerFunc {
	return func(c *gin.Context) {
		claims, err := mw.CheckIfTokenExpire(c)
		if err == nil {
			if expire, isSupport, valid := validSupportClaims(claims); isSupport {
				if !valid {
					c.JSON(http.StatusUnauthorized, gin.H{"message": supportExpiredMessage})
					return
				}
				mw.RefreshResponse(c, http.StatusOK, jwt.GetToken(c), expire)
				return
			}
		}
		mw.RefreshHandler(c)
	}
}
