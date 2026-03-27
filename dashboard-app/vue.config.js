const { defineConfig } = require('@vue/cli-service')

module.exports = defineConfig({
  transpileDependencies: true,
  publicPath: '/ycjctx/',
  devServer: {
    host: 'localhost',
    port: 8080,
    open: true,
    client: {
      overlay: {
        warnings: false,
        errors: true
      }
    }
  },
  css: {
    extract: false
  }
})