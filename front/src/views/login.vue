<template>
    <div class="big-box">
        <!-- 新增背景轮播层 -->
        <div class="background-slideshow">
            <div
                v-for="(img, index) in images"
                :key="index"
                class="slide"
                :class="{ active: currentSlide === index }"
                :style="{ backgroundImage: `url(${img})` }"
            ></div>
        </div>

        <!-- 新增包裹容器 -->
        <div
            class="container"
            :class="{ active1: isActive1, active2: isActive2 }"
        >
            <div class="box">
                <el-upload
                    class="avatar-uploader"
                    action="/api/imageUpload"
                    :show-file-list="false"
                    :on-success="handleAvatarSuccess"
                    :before-upload="beforeAvatarUpload"
                >
                    <img v-if="imageUrl" :src="imageUrl" class="avatar" />
                    <el-icon v-else class="avatar-uploader-icon"
                        ><Plus
                    /></el-icon>
                </el-upload>
                <!-- 时间显示容器 -->
                <div v-if="showTime" class="time-display">
                    {{ formattedTime }}
                </div>
                <h1>{{ title }}</h1>
                <a href="#" class="create" @click="handleLoginClick2"
                    >注册账号</a
                >
                <a href="#" class="login" @click="handleLoginClick1">登录</a>
                <a href="#" class="other">
                    <img src="@/icons/QQ.png" alt="" />
                    Continue With Tencent QQ</a
                >
                <a href="#" class="other">
                    <img src="@/icons/fb.png" alt="" class="fb" />
                    Continue With Facebook</a
                >
                <a href="#" class="other">
                    <img src="@/icons/Google.png" alt="" class="gg" />
                    Continue With Google</a
                >
                <hr />

                <h2 class="imgupld">上传头像</h2>

                <div class="tt">login page by samhan</div>
            </div>

            <!-- 登录滑动面板 -->
            <div class="slide-in">
                <a href="#" class="close-btn" @click="handleCloseClick1">
                    <img src="@/icons/off.svg" alt="" />
                </a>
                <!-- 输入框盒子 -->
                <el-form>
                    <div class="label1">Username:</div>
                    <el-form-item>
                        <el-input
                            v-model="username"
                            type="text"
                            placeholder="用户名"
                            :suffix-icon="User"
                        />
                    </el-form-item>
                    <div class="label1">Password:</div>
                    <el-form-item>
                        <el-input
                            v-model="password"
                            type="password"
                            placeholder="密码"
                            :suffix-icon="Lock"
                        />
                    </el-form-item>
                    <el-form-item>
                        <el-button type="primary" round @click="handleLogin"
                            >登录</el-button
                        >
                    </el-form-item>
                </el-form>
                <a href="#" class="change" @click.prevent="gotoResetPassword"
                    >修改密码</a
                >
            </div>

            <!-- 注册滑动面板 -->
            <div class="sign-in">
                <a href="#" class="close-btn2" @click="handleCloseClick2">
                    <img src="@/icons/off.svg" alt="" />
                </a>
                <!-- 输入框盒子 -->
                <el-form>
                    <div class="label1 2">Username:</div>
                    <el-form-item>
                        <el-input
                            v-model="username1"
                            type="text"
                            placeholder="用户名"
                            :suffix-icon="User"
                        />
                    </el-form-item>
                    <div class="label1 2">Password:</div>
                    <el-form-item>
                        <el-input
                            v-model="password1"
                            type="password"
                            placeholder="密码"
                            :suffix-icon="Lock"
                        />
                    </el-form-item>
                    <div class="label1 2">Confirm Password:</div>
                    <el-form-item>
                        <el-input
                            v-model="confirmPassword"
                            type="password"
                            placeholder="确认密码"
                            :suffix-icon="Lock"
                        />
                    </el-form-item>
                    <div class="label1 2">Email:</div>
                    <el-form-item>
                        <el-input
                            v-model="email"
                            type="text"
                            placeholder="邮箱"
                            :suffix-icon="Lock"
                        />
                    </el-form-item>
                    <div class="label1 2">Birthday:</div>
                    <el-form-item>
                        <el-date-picker
                            v-model="value1"
                            type="date"
                            placeholder="Pick a day"
                            :time-zone="GMT + 8"
                            :size="size"
                        />
                    </el-form-item>

                    <el-form-item>
                        <el-button type="primary" round @click="handleSignIn"
                            >加入我们!</el-button
                        >
                    </el-form-item>
                </el-form>
            </div>
        </div>
    </div>
</template>

<script>
import { Lock, User, Plus, Calendar } from '@element-plus/icons-vue'
import { ref, onMounted, onBeforeUnmount } from 'vue'
import { ElMessage } from 'element-plus'
import axios from 'axios'

const imageUrl = ref('')
const uploadRef = ref(null) // 上传组件引用

// 文件上传前校验
const beforeAvatarUpload = file => {
    const isJpgOrPng = file.type.startsWith('image/')
    const isLt10M = file.size / 1024 / 1024 <= 10

    if (!isJpgOrPng) {
        ElMessage.error('仅支持图片文件')
    }
    if (!isLt10M) {
        ElMessage.error('文件大小不能超过 10MB')
    }
    return isJpgOrPng && isLt10M
}

// 上传成功回调，获取后端返回的URL
const handleAvatarSuccess = response => {
    if (response.imageUrl != null) {
        imageUrl.value = response.imageUrl // 关键：更新响应式数据

        ElMessage.success('图片上传成功')
    } else {
        ElMessage.error(`上传失败：${response.message}`)
    }
}
export default {
    methods: {
        updateTime() {
            this.currentTime = new Date()
        },
        handleLoginClick1(e) {
            e.preventDefault()
            this.isActive1 = true
            this.title = 'Log In'
        },
        handleCloseClick1(e) {
            e.preventDefault()
            this.isActive1 = false
            this.title = 'Welcome Back!'
        },
        handleLoginClick2(e) {
            e.preventDefault()
            this.isActive2 = true
            this.title = 'Sign In'
        },
        handleCloseClick2(e) {
            e.preventDefault()
            this.isActive2 = false
            this.title = 'Welcome Back!'
        },
        // 添加新的处理函数
        handleResize() {
            this.windowWidth = document.documentElement.clientWidth
        },
        // 修改现有点击事件处理逻辑
        handleLoginClick1(e) {
            e.preventDefault()
            if (this.windowWidth <= 800) {
                this.title = 'Log In'
                setTimeout(() => {
                    this.isActive1 = true
                }, 50) // 小延时确保css状态更新
            } else {
                this.isActive1 = true
                this.title = 'Log In'
            }
        },
        gotoResetPassword() {
            this.$router.push('/reset-password')
        },
        handleLogin() {
            axios
                .post('/api/users/login', {
                    name: this.username,
                    password: this.password
                })
                .then(response => {
                    if (response.data.message === '登录成功') {
                        localStorage.setItem('name', this.username)
                        localStorage.setItem(
                            'avatorUrl',
                            response.data.avatorUrl
                        )
                        this.$router.push('/main')
                    } else {
                        this.$message({
                            message: '用户名或密码错误',
                            type: 'error',
                            duration: 2000
                        })
                    }
                })
                .catch(error => {
                    console.error('登录请求失败', error)
                    this.$message({
                        message: '登录请求失败，请检查网络',
                        type: 'error',
                        duration: 2000
                    })
                })
        },
        handleSignIn() {
            if (this.password1 !== this.confirmPassword) {
                this.$message({
                    message: '两次密码不一致',
                    type: 'error',
                    duration: 2000
                })
                return
            }
            // 格式化日期为北京时间的 YYYY-MM-DD

            const formattedBirthday = this.value1
                ? new Date(
                      new Date(this.value1).getTime() + 8 * 60 * 60 * 1000 // 加上 8 小时（毫秒）
                  )
                      .toISOString()
                      .split('T')[0]
                : null
            // 假设后端 `birthday` 需 `datetime`，此处简单拼接时间（实际需更严谨处理）
            const userData = {
                name: this.username1,
                password: this.password1,
                email: this.email,
                birthday: formattedBirthday,
                avatar: imageUrl.value
            }
            axios
                .post('/api/users/register', userData)
                .then(response => {
                    if (response.data === '用户创建成功') {
                        this.$message({
                            message: '注册成功',
                            type: 'success',
                            duration: 2000
                        })
                        this.isActive2 = false
                        this.title = 'Welcome Back!'
                    } else {
                        this.$message({
                            message: '注册失败或用户已存在',
                            type: 'error',
                            duration: 2000
                        })
                    }
                })
                .catch(error => {
                    console.error('注册请求失败', error)
                    this.$message({
                        message: '注册请求失败，请检查网络',
                        type: 'error',
                        duration: 2000
                    })
                })
        }
    },
    setup() {
        const images = [
            'images/image-1.jpg',
            'images/image-2.jpg',
            'images/image-3.jpg',
            'images/image-4.jpg',
            'images/image-5.jpg',
            'images/image-6.jpg'
        ]
        const currentSlide = ref(0)
        let timer = null

        // 预加载所有图片
        const preloadImages = () => {
            images.forEach(img => {
                new Image().src = img
            })
        }

        const startSlideshow = () => {
            timer = setInterval(() => {
                currentSlide.value = (currentSlide.value + 1) % images.length
            }, 8000) // 总动画时间与CSS动画时长一致
        }

        onMounted(() => {
            preloadImages()
            startSlideshow()
        })

        onBeforeUnmount(() => {
            clearInterval(timer)
        })

        return {
            images,
            currentSlide,
            handleAvatarSuccess,
            beforeAvatarUpload
        }
    },
    components: {
        // 组件应在 components 域注册
        User,
        Lock,
        Plus
    },
    data() {
        return {
            User,
            Lock,
            Calendar,
            // 新增input绑定字段
            username: '',
            password: '',
            username1: '',
            password1: '',
            email: '',
            imageUrl: imageUrl,
            confirmPassword: '',
            value1: null, // 日期选择器绑定字段
            currentTime: null,
            timer: null,
            isActive1: false,
            isActive2: false,
            title: 'Welcome Back!',
            windowWidth: document.documentElement.clientWidth
        }
    },
    computed: {
        // 是否显示时间的条件判断
        showTime() {
            return this.title === 'Welcome Back!'
        },
        // 时间格式化处理
        formattedTime() {
            if (!this.currentTime) return ''
            return this.currentTime.toLocaleTimeString('zh-CN', {
                hour: '2-digit',
                minute: '2-digit',
                hour12: false
            })
        }
    },
    mounted() {
        // 初始化时间
        this.updateTime()
        // 启动定时器（每秒更新一次）
        this.timer = setInterval(() => {
            this.updateTime()
        }, 1000)
        window.addEventListener('resize', this.handleResize)
    },
    beforeDestroy() {
        // 清理定时器
        clearInterval(this.timer)
        window.removeEventListener('resize', this.handleResize)
    }
}
</script>

<style scoped>
* {
    /* 去除浏览器默认内外边距 */
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

a {
    text-decoration: none;
}

/* 去除input的轮廓 */
input {
    outline: none;
}

.big-box {
    position: relative;
    justify-content: center;
    /* align-items: center; */
    /* 溢出隐藏 */
    min-height: 100vh;
    overflow-x: hidden;
    overflow-y: hidden;
    display: flex;
    /* background: #f0f2f5; */
}

.background-slideshow {
    position: fixed;
    width: 100%;
    height: 100%;
    z-index: 0;
}

.slide {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background-size: cover;
    background-position: center;
    opacity: 0;
    transform: scale(1);
    transition: opacity 2s ease-in-out;
    /* animation: zoomIn 8s linear forwards;
  filter: brightness(0.9); */
    z-index: 0;
}

.slide.active {
    opacity: 1;
    z-index: 1;
    animation: zoomIn 8s linear forwards;
}

@keyframes zoomIn {
    from {
        transform: scale(1);
    }
    to {
        transform: scale(1.04); /* 放大8% */
    }
}

.music {
    position: absolute;
    bottom: 0;
    right: 0;
    z-index: 3;
}

.container {
    position: relative;
    margin: auto auto;
    height: 550px;
    width: 800px;
    z-index: 1;
}

.time-display {
    position: absolute;
    top: 60px; /* 距离标题的间距 */
    left: 50%;
    transform: translateX(-50%);
    font-size: 70px;
    color: #fb7299;
    font-family: '字由点字典黑';
    animation: fadeIn 1s ease;
}

@keyframes fadeIn {
    from {
        opacity: 0;
    }
    to {
        opacity: 1;
    }
}

.box,
.slide-in,
.sign-in {
    position: absolute;
    left: 25%;
    background: rgba(255, 255, 255, 1);
    margin: 0 auto;
    padding: 40px;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
    height: 100%;
    width: 50%;
    z-index: 3;
    border-radius: 10px;
}

.box {
    background-color: rgba(255, 255, 255, 0.9);
}

.slide-in,
.sign-in {
    visibility: hidden;
}

.box h1 {
    text-align: center;
    font-family: '字由点字典黑';
    color: #fb7299;
    font-size: 20px;
    margin-top: 120px;
    margin-bottom: 60px;
}

.box a,
.slide-in a.change {
    display: block;
    margin: 0 auto;
    height: 45px;
    line-height: 45px;
    width: 80%;
    background-color: #7ecafe;
    margin-top: 40px;
    border-radius: 22.5px;
    transition: filter 0.1s;
    font-weight: 600;
    text-align: center;
    color: #fff;
}

.box a:hover {
    filter: brightness(85%);
}

.box a.login {
    background-color: #aaaaaa;
    color: #fff;
    transition: opacity 0.3s ease, visibility 0s;
}

.box a.create {
    color: #fff;
    transition: opacity 0.3s ease, visibility 0s;
}

.box a.other {
    background-color: #f5f5f5;
    font-size: 12px;
    color: #000;
    opacity: 0;
    visibility: hidden;
    transition: opacity 0.3s ease, visibility 0s;
    text-align: left;
    text-indent: 28%;
}

.avatar-uploader .avatar {
    width: 178px;
    height: 178px;
    display: block;
}

.box .avatar-uploader {
    position: absolute;
    top: 180px;
    left: 50%;
    transform: translateX(-50%);
    display: none;
}

.box .imgupld {
    position: absolute;
    bottom: 150px;
    left: 50%;
    transform: translateX(-50%);
    display: none;
}

.box hr {
    position: absolute;
    border: 1px solid #f0f0f0;
    width: 80%;
    bottom: 100px;
}

.box .tt {
    position: absolute;
    width: 80%;
    text-align: center;
    bottom: 80px;
    font-size: 12px;
    color: gray;
}

.slide-in,
.sign-in {
    z-index: 1;
}

.slide-in h1,
.sign-in h1 {
    margin-top: 40px;
    text-align: center;
}

/* 激活状态 */
.container.active1 .box {
    background-color: #fff;
}

.container.active1 .slide-in {
    background-color: #fff;
    visibility: visible;
}

.container.active1 .box {
    transform: translateX(-50%);
}

.container.active1 .box h1 {
    font-size: 30px;
    margin-top: 40px;
}

.container.active2 .box h1 {
    font-size: 30px;
    margin-top: 40px;
}

.container.active1 .box a.create {
    display: none;
}

.container.active1 .box a.login {
    display: none;
}

.container.active1 .box a.other {
    position: relative;
    opacity: 1;
    visibility: visible;
    transition-delay: 0s; /* 显式覆盖可能存在的延迟 */
}

.container.active1 .box a.other img {
    position: absolute;
    left: 30px;
    top: 10%;
    height: 80%;
}

.container.active1 .box a.other img.fb {
    position: absolute;
    left: 28px;
    top: 15%;
    height: 70%;
}

.container.active1 .box a.other img.gg {
    position: absolute;
    left: 28px;
    top: 15%;
    height: 70%;
}

.container.active1 .slide-in {
    transform: translateX(50%);
    z-index: 2;
}

.container.active1 .sign-in {
    display: none;
}

.container.active2 .box {
    background-color: #fff;
}

.container.active2 .sign-in {
    background-color: #fff;
    visibility: visible;
}

.container.active2 .box a.create {
    display: none;
}

.container.active2 .box a.login {
    display: none;
}

.container.active2 .box .avatar-uploader {
    display: block;
}

.container.active2 .box .imgupld {
    display: block;
}

.container.active2 .box {
    transform: translateX(-50%);
}

.container.active2 .slide-in {
    display: none;
}

.container.active2 .sign-in {
    transform: translateX(50%);
    z-index: 2;
}

.box,
.slide-in,
.sign-in {
    transition: 0.5s ease-in-out;
}

.slide-in .el-form {
    margin-top: 60px;
}

.sign-in .el-form {
    margin-top: 0px;
}

.slide-in .el-form .label1,
.sign-in .el-form .label1 {
    font-weight: 600;
    font-size: 20px;
}

.slide-in .el-form .el-button,
.sign-in .el-form .el-button {
    width: 80%;
    margin: 0 auto;
    height: 45px;
    border-radius: 22.5px;
    font-size: 20px;
    font-weight: 600;
    /* background-color: #7ecafe; */
}

:deep(.el-input__wrapper) {
    height: 40px;
}

.slide-in .el-form-item,
.sign-in .el-form-item {
    margin-bottom: 40px;
    margin-top: 10px;
    width: 100%;
}

.sign-in .el-form-item {
    margin-bottom: 25px;
    margin-top: 5px;
}

.slide-in .user,
.slide-in .pwd {
    width: 100%;
}

.close-btn,
.close-btn2 {
    position: absolute;
    right: 20px;
    top: 20px;
    display: block;
    width: 20px;
    height: 20px;
    /* border-radius: 50%; */
    /* background-color: pink; */
}

.close-btn img,
.close-btn2 img {
    width: 100%;
}

.demo-date-picker {
    display: flex;
    width: 100%;
    padding: 0;
    flex-wrap: wrap;
}

.demo-date-picker .block {
    padding: 30px 0;
    text-align: center;
    border-right: solid 1px var(--el-border-color);
    flex: 1;
}

.demo-date-picker .block:last-child {
    border-right: none;
}

.demo-date-picker .demonstration {
    display: block;
    color: var(--el-text-color-secondary);
    font-size: 14px;
    margin-bottom: 20px;
}

/* .slide-in,
.sign-in {
    overflow-y: auto;
} */

/* 在现有样式最后添加媒体查询 */
@media (max-width: 800px) {
    .big-box {
        position: relative;
        align-items: center;
        width: 100vw;
    }

    .container {
        z-index: 0;
        position: absolute;
        min-height: 50vh;
    }

    .box,
    .slide-in,
    .sign-in {
        position: absolute;
        left: calc(50% - 150px);
        width: 300px;
        height: 300px;
        margin-top: 10%;
    }

    .box {
        z-index: 3;
    }

    .slide-in,
    .sign-in {
        z-index: 1;
    }

    .box .time-display {
        top: 30px;
        font-size: 50px;
    }

    .box h1 {
        margin-top: 70px;
        margin-bottom: 20px;
    }

    .box a {
        margin-top: 20px;
    }

    .box hr,
    .box .tt {
        display: none;
    }

    /* 桌面端横向展开样式重置 */
    .container.active1 .box,
    .container.active2 .box {
        transform: translateY(-50%);
    }

    .container.active1 .box,
    .container.active2 .box {
        padding: 0;
    }

    .container.active1 .box h1,
    .container.active2 .box h1 {
        margin-top: 20px;
    }

    .container.active2 .box .imgupld {
        top: 65px;
        font-size: 20px;
    }

    .container.active2 .box .avatar-uploader {
        top: 100px;
    }

    .container.active1 .box a {
        width: 80%;
    }

    .container.active1 .slide-in,
    .container.active2 .sign-in {
        transform: translateY(50%); /* 更合理的弹出位置 */
    }

    .slide-in,
    .sign-in {
        padding: 0 20px;
        overflow-y: auto;
    }

    .slide-in .el-form,
    .sign-in .el-form {
        margin-top: 20px;
    }

    .slide-in .el-form .label1,
    .sign-in .el-form .label1 {
        font-size: 15px;
    }

    .slide-in .el-form .el-form-item,
    .sign-in .el-form .el-form-item {
        margin-bottom: 10px;
    }

    .slide-in .el-form .el-button,
    .sign-in .el-form .el-button {
        height: 40px;
        width: 80%;
        margin-top: 10px;
    }

    .slide-in a.change {
        margin-top: 0;
        height: 40px;
        width: 80%;
        line-height: 40px;
    }
}
</style>

<style>
.avatar-uploader .el-upload {
    border: 1px dashed var(--el-border-color);
    border-radius: 6px;
    cursor: pointer;
    position: relative;
    overflow: hidden;
    transition: var(--el-transition-duration-fast);
}

.avatar-uploader .el-upload:hover {
    border-color: var(--el-color-primary);
}

.el-icon.avatar-uploader-icon {
    font-size: 28px;
    color: #8c939d;
    width: 178px;
    height: 178px;
    text-align: center;
}
</style>
