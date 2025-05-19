import component from 'element-plus/es/components/tree-select/src/tree-select-option.mjs'
import { createRouter, createWebHashHistory } from 'vue-router'

const routes = [
    {
        path: '/',
        redirect: '/login'
    },
    {
        path: '/login',
        name: 'Login',
        component: () => import('../views/login.vue')
    },
    {
        path: '/reset-password',
        name: 'ResetPassword',
        component: () => import('../views/ResetPassword.vue')
    },
    {
        path: '/main',
        name: 'Main',
        component: () => import('@/views/main.vue'),
        children: [
            {
                // 默认子路由
                path: '',
                redirect: '/main/home'
            },
            {
                path: 'home',
                name: 'Home',
                component: () => import('@/views/home.vue')
            },
            {
                path: 'profile',
                name: 'Profile',
                component: () => import('@/views/Profile.vue')
            },
            {
                path: 'users',
                name: 'Users',
                component: () => import('@/views/Users.vue')
            },
            {
                path: 'articles',
                name: 'Articles',
                component: () => import('@/views/Articles.vue')
            },
            {
                path: 'AuthorArticleManage',
                name: 'AuthorArticleManage',
                component: () => import('../views/AuthorManage.vue')
            }
            // 其他子路由可以继续在这里添加
        ]
    }
]

const router = createRouter({
    history: createWebHashHistory(),
    routes
})

export default router
