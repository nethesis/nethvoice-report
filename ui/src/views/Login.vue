<template lang="html">
  <div class="background">
    <sui-grid centered vertical-align="middle">
      <sui-grid-column>
        <sui-image size="huge" src="logo.png" />
        <sui-divider hidden />
        <sui-form v-on:submit.prevent="doLogin()" :error="error" :warning="sessionExpired">
          <sui-segment stacked>
            <sui-form-field>
              <sui-input type="text" placeholder="Username" icon="user" icon-position="left" v-model="username" />
            </sui-form-field>
            <sui-form-field>
              <sui-input type="password" placeholder="Password" icon="lock" icon-position="left" v-model="password" />
            </sui-form-field>
            <sui-message error>
              <sui-message-header>
                <i class="exclamation triangle icon"></i>
                {{$t('login.invalid_credentials')}}
              </sui-message-header>
              <p>
                {{$t('login.invalid_user_pass_try')}}.
              </p>
            </sui-message>
            <sui-message warning>
              <sui-message-header>
                <i class="exclamation triangle icon"></i>
                {{$t('login.session_expired')}}
              </sui-message-header>
              <p>
                {{$t('login.login_again')}}.
              </p>
            </sui-message>
            <sui-button size="large" color="green" fluid>
              {{$t('menu.login')}}
              <sui-loader :active="loading" class="mg-left-20" inline inverted size="tiny" />
            </sui-button>
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
      password: "",
      error: false,
      loading: false,
      sessionExpired: false,
    };
  },
  mixins: [LoginService, StorageService],
  mounted() {
    this.$root.$on("logout", () => {
      this.sessionExpired = true;
    });
    this.$nextTick(() => {
      // set random background
      document.querySelector('.background').style.background = `linear-gradient( rgba(0, 0, 0, 0.35), rgba(0, 0, 0, 0.95) ), url(${this.getImgUrl()}) center center fixed`
   })
  },
  methods: {
    doLogin() {
      this.loading = true;
      this.sessionExpired = false;

      this.execLogin(
        {
          username: this.username,
          password: this.password,
        },
        (success) => {
          this.loading = false;
          this.error = false;

          // extract loggedUser info
          var loggedUser = success.body;
          loggedUser.username = this.username;

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
    getImgUrl() {
      let n = Math.floor(Math.random() * (6 - 1) + 1),
          images = require.context('../images/', false, /\.jpg$/)
      return images('./' + n + ".jpg")
    }
  },
};
</script>

<style lang="css" scoped>
.background {
  background-color: #3f9c35 !important;
  height: 100vh;
  position: absolute;
  width: 100%;
  background-size: 100% !important;
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

.mg-left-20 {
  margin-left: 10px !important;
}
</style>
