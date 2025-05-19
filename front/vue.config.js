const { defineConfig } = require('@vue/cli-service')
module.exports = defineConfig({
    transpileDependencies: true,
    devServer: {
        port: 8081,
        client: {
            overlay: false
        },
        proxy: {
            '/api': {
                target: 'http://localhost:8082', // 设置后端接口的访问地址
                changeOrigin: true,
                pathRewrite: {
                    '^/api': '' // 将请求路径中的 '/api' 替换为空字符串
                }
            }
        }
    },

    css: {
        loaderOptions: {
            scss: {
                implementation: require('sass')
            }
        }
    }
})
