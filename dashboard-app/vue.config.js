const { defineConfig } = require('@vue/cli-service')

module.exports = defineConfig({
  transpileDependencies: true,
  publicPath: '/',
  devServer: {
    host: 'localhost',
    port: 12300,
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