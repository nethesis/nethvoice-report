<template lang="html">
  <div class="flex h-screen background">
    <div
      class="w-full max-w-md flex flex-col items-center justify-center background"
    >
      <div class="flex flex-col items-center justify-center">
        <img src="../../public/login_logo.png" alt="logo" />

        <div class="items-center brandColor">
          <i class="bar chart icon h-5 w-5"></i>
          Report
        </div>
      </div>
      <div class="flex justify-center py-7">
        <sui-form
          v-on:submit.prevent="doLogin()"
          :error="error"
          :warning="sessionExpired"
        >
          <sui-form-field class="block w-full relative text-left">
            <label
              class="fixedWeight"
              for="username"
            >
              {{ $t("login.user") }}
            </label>
            <sui-input
              id="username"
              type="text"
              placeholder=""
              v-model="username"
              class="inputSize"
            />
          </sui-form-field>
          <sui-form-field class="block w-full relative text-left">
            <label
              class="fixedWeight"
              for="password"
            >
              {{ $t("login.password") }}
            </label>
            <sui-input
              id="password"
              type="password"
              placeholder=""
              v-model="password"
              class="inputSize"
            />
          </sui-form-field>
          <sui-message error>
            <sui-message-header>
              <i class="exclamation triangle icon"></i>
              {{ $t("login.invalid_credentials") }}
            </sui-message-header>
            <p>{{ $t("login.invalid_user_pass_try") }}.</p>
          </sui-message>
          <sui-message warning>
            <sui-message-header>
              <i class="exclamation triangle icon"></i>
              {{ $t("login.session_expired") }}
            </sui-message-header>
            <p>{{ $t("login.login_again") }}.</p>
          </sui-message>
          <sui-button size="large" class="buttonLogin" fluid>
            {{ $t("menu.login") }}
            <sui-loader
              :active="loading"
              class="mg-left-20"
              inline
              inverted
              size="tiny"
            />
          </sui-button>
        </sui-form>
      </div>
    </div>
    <div class="">
      <sui-image
        src="LoginBackground.png"
        class="absolute h-full w-full object-cover"
      />
    </div>
  </div>
</template>

<script>
import LoginService from "../services/login";
import StorageService from "../services/storage";

export default {
  name: "Login",
  data() {
    return {
      username: "",
      password: "",
      error: false,
      loading: false,
      sessionExpired: false,
    };
  },
  mixins: [LoginService, StorageService],
  mounted() {
    this.$root.$on("logout", this.onLogout);
  },
  methods: {
    onLogout() {
      this.sessionExpired = true;
    },
    doLogin() {
      this.loading = true;
      this.sessionExpired = false;

      // remove domain (if any)
      const username = this.username.split("@")[0];

      this.execLogin(
        {
          username: username,
          password: this.password,
        },
        (success) => {
          this.loading = false;
          this.error = false;

          // extract loggedUser info
          var loggedUser = success.body;
          loggedUser.username = username;

          // save to localstorage
          this.set("loggedUser", loggedUser);
          this.username = "";
          this.password = "";

          // change route
          this.$parent.didLogin();
        },
        (error) => {
          this.loading = false;

          // show errors
          this.error = true;

          // print error
          console.error(error.body);
        }
      );
    },
  },
};
</script>

<style lang="css" scoped>
.background {
  background-color: #1b1c1d;
}

.text-left {
  text-align: left;
}

.inputSize {
  width: 350px !important;
}

.buttonLogin {
  background: #059669 !important;
  color: white !important;
  margin-top: 30px !important;
}

.h-5 {
  height: 20px;
}

.w-5 {
  width: 20px;
}

.brandColor {
  color: #059669 !important;
  padding-top: 10px;
  font-size: 16px;
}

.flex {
  display: flex;
}

.fixedWeight {
  font-weight: 400 !important;
  color: #f9fafb !important;
}
.relative {
  position: relative;
}

.block {
  display: block;
}
.flex-col {
  flex-direction: column;
}

.justify-center {
  justify-content: center;
}

.mx-auto {
  margin-left: auto;
  margin-right: auto;
}

.max-w-md {
  max-width: 580px;
}

.absolute {
  position: absolute;
}

.h-full {
  height: 100%;
}

.w-full {
  width: 100%;
}

.object-cover {
  object-fit: cover;
}

.items-center {
  align-items: center;
}

.h-screen {
  height: 100vh;
}

.py-7 {
  padding-top: 28px; /* 28px */
  padding-bottom: 28px; /* 28px */
}
</style>
