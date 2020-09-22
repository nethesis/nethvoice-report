<template lang="html">
<div class="background">
  <sui-grid centered vertical-align="middle">
    <sui-grid-column>
      <sui-image size="huge" src="logo.png" />
      <sui-divider hidden />
      <sui-form v-on:submit.prevent="doLogin()" :error="error">
        <sui-segment stacked>
          <sui-form-field>
            <sui-input type="text" placeholder="Username" icon="user" icon-position="left" v-model="username" />
          </sui-form-field>
          <sui-form-field>
            <sui-input type="password" placeholder="Password" icon="lock" icon-position="left" v-model="password" />
          </sui-form-field>
          <sui-message error>
            <sui-message-header>{{$t('login.invalid_credentials')}}</sui-message-header>
            <p>
              {{$t('login.invalid_user_pass_try')}}.
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
      loading: false
    };
  },
  mixins: [LoginService, StorageService],
  methods: {
    doLogin() {
      this.loading = true;

      this.execLogin({
          username: this.username,
          password: this.password,
        },
        (success) => {
          this.loading = false;

          // extract loggedUser info
          var loggedUser = success.body;

          // save to localstorage
          this.set("loggedUser", loggedUser);

          // change route
          this.$parent.didLogin();
          this.$router.push("/" + (this.get("selectedReport") || 'queue'));
        },
        (error) => {
          this.loading = false;

          // show errors
          this.error = true;

          // print error
          console.error(error.body.message);
        }
      );
    }
  },
};
</script>

<style lang="css" scoped>
.background {
  background-color: #21ba45 !important;
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

.mg-left-20 {
  margin-left: 10px !important;
}
</style>
