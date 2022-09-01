const { defineConfig } = require("@vue/cli-service");
module.exports = defineConfig({
  transpileDependencies: ["vuetify"],
  configureWebpack: {
    devServer: {
      port: 8080,
      // https://github.com/vuejs-templates/webpack/issues/378
      liveReload: true,
    },
  },
});
