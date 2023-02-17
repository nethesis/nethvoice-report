<template lang="html">
  <div class="flex h-screen justify-center background">
    <div
      class="mx-auto w-full max-w-md flex flex-col items-center justify-center background"
    >
      <div class="flex flex-col items-center justify-center">
        <img
          src="../../public/login_logo.png"
          alt="logo"
        />
        <div class="items-center brandColor">
          <i class="bar chart icon "></i> 
          Report
        </div>
      </div>
      <div class="flex justify-center py-3">
        <sui-form
          v-on:submit.prevent="doLogin()"
          :error="error"
          :warning="sessionExpired"
        >
          <sui-form-field class="block w-full relative">
            <label
              class="text-gray-700 font-bold mb-2 align-left"
              for="username"
            >
            {{ $t("login.user") }}
            </label>
            <sui-input
              id="username"
              type="text"
              placeholder=""
              v-model="username"
            />
          </sui-form-field>
          <sui-form-field class="block w-full relative">
            <label
              class="text-gray-700 font-bold mb-2 align-left"
              for="password"
            >
            {{ $t("login.password") }}
            </label>
            <sui-input
              id="password"
              type="password"
              placeholder=""
              v-model="password"
              size="big"
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
          <sui-button size="large" color="green" fluid>
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
        class="absolute inset-0 h-full w-full object-cover"
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
  background-color: #f3f4f6;
}
.grid {
  height: 100%;
}

.ui.stacked.segment:after {
  display: none;
}

.brandColor{
  color: #059669 !important;
  padding-top: 10px;
  font-size: 16px;
}

.flex {
  display: flex;
}

.relative {
  position: relative;
}

.block {
  display: block;
}

.min-h-full {
  min-height: 100%;
}

.flex-1 {
  flex: 1 1 0%;
}

.flex-col {
  flex-direction: column;
}

.justify-center {
  justify-content: center;
}

.w-0 {
  width: 0px;
}

.mx-auto {
  margin-left: auto;
  margin-right: auto;
}

.max-w-sm {
  max-width: 384px; /* 384px */
}

.max-w-md {
  max-width: 512px;
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

.align-middle {
  vertical-align: middle;
}

.items-center {
  align-items: center;
}

.h-screen {
  height: 100vh;
}

.px-4 {
  padding-left: 16px; /* 16px */
  padding-right: 16px; /* 16px */
}

.py-3 {
  padding-top: 12px; /* 12px */
  padding-bottom: 12px; /* 12px */
}

.sui-button {
  background-color: #059669;
}
</style>
