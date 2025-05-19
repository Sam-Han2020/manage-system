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
        <div class="container">
            <a href="#" class="close-btn" @click="handleCloseClick1">
                <img src="@/icons/off.svg" alt="" />
            </a>
            <h1>修改密码</h1>
            <el-form>
                <div class="info">
                    <h3>Username:</h3>
                    <el-form-item>
                        <el-input
                            v-model="username"
                            style="width: 240px"
                            placeholder="用户名"
                            :suffix-icon="User"
                        />
                    </el-form-item>
                    <h3>Password:</h3>
                    <el-form-item>
                        <el-input
                            v-model="old_password"
                            style="width: 240px"
                            type="password"
                            placeholder="旧密码"
                            show-password
                            :suffix-icon="Lock"
                        />
                    </el-form-item>
                </div>
                <div class="newpwd">
                    <h3>New Password:</h3>
                    <el-form-item>
                        <el-input
                            v-model="new_password"
                            style="width: 240px"
                            type="password"
                            placeholder="新密码"
                            show-password
                            :suffix-icon="Lock"
                        />
                    </el-form-item>
                    <h3>Confirm Password:</h3>
                    <el-form-item>
                        <el-input
                            v-model="comf_password"
                            style="width: 240px"
                            type="password"
                            placeholder="确认密码"
                            show-password
                            :suffix-icon="Lock"
                        />
                    </el-form-item>
                </div>
                <el-form-item>
                    <el-button type="primary" round @click="handleSubmit"
                        >提交更改</el-button
                    >
                </el-form-item>
            </el-form>
        </div>
    </div>
</template>

<script>
import { Lock, User } from '@element-plus/icons-vue'
import { ref, onMounted, onBeforeUnmount } from 'vue'
import { ElMessage } from 'element-plus'
import axios from 'axios'
export default {
    methods: {
        // ✅ 添加事件处理器
        handleCloseClick1(e) {
            e.preventDefault()
            // 使用router返回上一页
            // this.$router.go(-1)

            // 或者指定回退路径
            this.$router.push('/login')
        },
        handleSubmit() {
            if (
                !this.username ||
                !this.old_password ||
                !this.new_password ||
                !this.comf_password
            ) {
                ElMessage.error('请填写完整信息')
                return
            }

            if (this.new_password !== this.comf_password) {
                ElMessage.error('两次输入的新密码不一致')
                return
            }

            if (!this.validatePassword(this.new_password)) {
                ElMessage.error('密码需包含大小写字母和数字，长度6-16位')
                return
            }

            if (this.new_password === this.old_password) {
                ElMessage.error('新密码不能与旧密码相同')
                return
            }

            // 这里是调用修改密码API的示例
        
      axios.post('/api/users/changePassword', {  // 替换为实际API路径
        username: this.username,
        old_password: this.old_password,
        new_password: this.new_password
      })
      .then(response => {
        if (response.data.code === 200) {  // 假设后端成功状态码为200
          ElMessage.success('密码修改成功');
          this.$router.push('/login');  // 跳转登录页
        } else {
          ElMessage.error(response.data.message || '密码修改失败');
        }
      })
      .catch(error => {
        console.error('请求失败:', error);
        ElMessage.error('网络请求失败，请检查网络连接');
      });
        },
        validatePassword(password) {
            const regex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[^]{6,16}$/
            return regex.test(password)
        }
    },
    data() {
        return {
            Lock,
            User,
            username: '',
            old_password: '',
            new_password: '',
            comf_password: ''
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
            ElMessage
        }
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

.container {
    position: relative;
    margin: auto auto;
    height: 350px;
    width: 800px;
    z-index: 1;
    border-radius: 10px;
    background-color: #fff;
    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

/* 标题样式 */
.container h1 {
    z-index: 3;
    text-align: center;
    color: #fb7299;
    font-size: 28px;
    margin-top: 20px;
    margin-bottom: 40px;
    font-family: '字由点字典黑';
}

.container h3 {
    padding-left: 30px;
    margin-bottom: 10px;
}

/* 表单布局调整 */
.el-form {
    margin-top: 0px;
    display: flex;
    flex-direction: column;
    gap: 24px;
}

/* 输入框样式优化 */
.el-input {
    width: 80% !important; /* 覆盖行内样式 */
    margin: 0 auto;
    margin-bottom: 20px;
}

.el-input__wrapper {
    border-radius: 20px !important;
    padding: 12px 20px !important;
}

/* 按钮样式 */
.el-button {
    position: absolute;
    bottom: -220px;
    left: calc(50% - 100px);
    width: 200px;
    height: 40px;
    font-size: 16px;
}

.container .info {
    position: absolute;
    left: 0;
    width: 50%;
    height: 45%;
    border-right: 3px dashed gray;
}

.container .newpwd {
    position: absolute;
    right: 0;
    width: 50%;
    height: 45%;
}

.close-btn {
    position: absolute;
    right: 20px;
    top: 20px;
    display: block;
    width: 20px;
    height: 20px;
    /* border-radius: 50%; */
    /* background-color: pink; */
}

.close-btn img {
    width: 100%;
}

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
        width: 300px;
        height: 450px;
    }
    .container .info,
    .container .newpwd {
        width: 80%;
        left: 10%;
    }

    .info h3,
    .newpwd h3 {
        margin-bottom: 10px;
    }

    .el-input {
        margin-bottom: 10px;
    }

    .container .info {
        top: 70px;
        border: none;
    }

    .container .newpwd {
        top: 220px;
        border: none;
    }

    .el-button {
        height: 30px;
        width: 60%;
        left: 20%;
        bottom: -310px;
    }
}
</style>
