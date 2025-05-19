import { createApp } from 'vue'
import ElementPlus from 'element-plus'
import { ElMessage } from 'element-plus'
import 'element-plus/dist/index.css'
import App from './App.vue'
import router from './router'
import PrimeVue from 'primevue/config'
import Calendar from 'primevue/calendar'
import axios from 'axios'

const app = createApp(App)

app.config.globalProperties.$message = ElMessage

createApp(App)
    .use(ElementPlus)
    .use(PrimeVue, { ripple: true })
    .component('Calendar', Calendar)
    .use(axios)
    .use(router)
    .mount('#app')

// 在main.ts中添加（仅抑制ResizeObserver特定错误）
window.addEventListener(
    'error',
    e => {
        if (e.message.toLowerCase().includes('resizeobserver'))
            e.preventDefault()
    },
    { capture: true }
)
