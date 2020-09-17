<template lang="html">
  <div class="background">
    <sui-grid centered vertical-align="middle">
      <sui-grid-column>
        <h2 is="sui-header" color="green" image>
          <!-- <sui-image src="static/images/logo.png" /> -->
          <sui-header-content>Log-in to your account</sui-header-content>
        </h2>
        <sui-form v-on:submit.prevent="doLogin()">
          <sui-segment stacked>
            <sui-form-field>
              <sui-input
                type="text"
                placeholder="Username"
                icon="user"
                icon-position="left"
                v-model="username"
              />
            </sui-form-field>
            <sui-form-field>
              <sui-input
                type="password"
                placeholder="Password"
                icon="lock"
                icon-position="left"
                v-model="password"
              />
            </sui-form-field>
            <sui-button size="large" color="green" fluid>Login</sui-button>
          </sui-segment>
        </sui-form>
      </sui-grid-column>
    </sui-grid>
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
      password: ""
    }
  },
  mixins: [LoginService, StorageService],
  methods: {
      doLogin () {
      this.execLogin(
        {
          username: this.username,
          password: this.password
        },
        success => {
          // extract loggedUser info
          var loggedUser = success.body;
          // save to localstorage
          this.set("loggedUser", loggedUser);
          // get user info
          // this.getInfo(loggedUser.id, response => {
          //   if (response) {
          //     this.user.info = response;
          //     this.isLogged = true;
          //     this.initGraphics();
          //   } else {
          //     this.isLogged = false;
          //   }
          // });
          // change route
          console.log(success)
          this.isLogged = true;
          this.$parent.didLogin()
        },
        error => {
          if (error.body.message == "No username found!") {
            this.errors.username = true;
          }
          if (error.body.message == "Password is invalid") {
            this.errors.password = true;
          }
          console.error(error.body.message);
        }
      );
    }  
  }
}
</script>

<style lang="css" scoped>
.background {
  background-color: #dadada !important;
  height: 100vh;
  margin: 1em 0;
}
.grid {
  height: 100%;
}
.column {
  max-width: 450px;
  text-align: center !important;
}
.ui.stacked.segment:after {
  display: none;
}
</style>