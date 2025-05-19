<template>
    <div class="big-box">
        <a href="#/main" class="folder" @click.prevent="toggleCollapse">
            <el-icon v-if="isCollapsed"><Expand /></el-icon>
            <el-icon v-else><Fold /></el-icon>
        </a>

        <!-- 新增遮罩层 -->
        <div class="mask" v-show="showMask" @click="handleMaskClick"></div>
        <!-- <div class="logo">samhan</div> -->
        <img
            src="@/icons/logo.png"
            alt=""
            :class="['logo', { 'logo-collapsed': isCollapsed }]"
        />
        <div class="nav-left" :style="{ left: navLeftOffset }">
            <ul class="nav-list">
                <div
                    class="nav-block"
                    v-for="(item, index) in navItems"
                    :key="index"
                >
                    <!-- 子菜单移动到父项前 -->
                    <div
                        class="submenu-list"
                        v-show="item.expanded && item.children"
                    >
                        <li
                            v-for="(child, childIndex) in item.children"
                            :key="childIndex"
                            class="nav-item sub-item"
                            @click.stop="handleChildClick(index, childIndex)"
                            :class="{
                                'sub-active':
                                    activationState.activeChild.parentIndex ===
                                        index &&
                                    activationState.activeChild.childIndex ===
                                        childIndex
                            }"
                        >
                            <span>{{ child.text }}</span>
                        </li>
                    </div>
                    <!-- 父项 -->
                    <li
                        class="nav-item parent-item"
                        @click="
                            item.text === '退出登录'
                                ? logout()
                                : toggleExpand(item, index)
                        "
                        :class="{
                            active:
                                activationState.activeParent === index &&
                                activationState.activeChild.parentIndex === null
                        }"
                    >
                        <el-icon><component :is="item.icon" /></el-icon>
                        <span>{{ item.text }}</span>
                        <el-icon class="arrow-icon" v-if="item.children">
                            <component
                                :is="item.expanded ? ArrowUp : ArrowDown"
                            />
                        </el-icon>
                    </li>
                    <div class="blank"></div>
                </div>
            </ul>
        </div>
        <div class="main-area" :class="{ 'blur-effect': showMask }">
            <div class="nav-top">
                <!-- 修改当前路径显示 - 添加v-if条件和点击事件 -->

                <div class="time-display">{{ currentTime }}</div>
                <div class="avatar-wrapper" v-show="!hideAvatar">
                    <img :src="avatarUrl" alt="用户头像" class="avatar" />
                </div>
            </div>
            <router-view></router-view>
        </div>
    </div>
</template>

<script setup>
import { ref, watch, reactive, onMounted, onBeforeUnmount, computed } from 'vue'
import { useRouter } from 'vue-router'
// Usage in your main layout component:
import { themeEventBus } from '@/utils/themeEvent'
import {
    Fold,
    Expand,
    User,
    Setting,
    Document,
    Grid,
    ArrowUp,
    ArrowDown,
    Sunny,
    Moon,
    ArrowRightBold
} from '@element-plus/icons-vue'

const router = useRouter()
const currentTime = ref('')
const hideAvatar = ref(false)

// 新增: 当前路径显示相关
const currentPathDisplay = ref('首页')
const avatarUrl = ref(localStorage.getItem('avatorUrl') || '') // 从localStorage获取头像地址

const logout = () => {
    // 这里添加注销逻辑，例如向服务器发送注销请求
    // 示例：清除localStorage中的相关信息
    localStorage.removeItem('avatorUrl')

    // 可以添加路由跳转，跳转到登录页等
    router.push('/login')
}

// 计算路径部分用于显示
const pathParts = computed(() => {
    return currentPathDisplay.value.split(' > ')
})

// 新增: 控制路径显示的变量
const isPathHidden = ref(false)

// 新增: 检查是否是主题设置路径
const isThemePath = computed(() => {
    return (
        currentPathDisplay.value.includes('系统设置 > 浅色模式') ||
        currentPathDisplay.value.includes('系统设置 > 深色模式')
    )
})

// 新增: 路径点击处理函数
const handlePathClick = () => {
    // 获取当前路径的第一部分（如果有多部分）
    const pathParts = currentPathDisplay.value.split(' > ')
    const parentText = pathParts[0]

    // 查找对应的导航项
    const navIndex = navItems.value.findIndex(item => item.text === parentText)

    if (navIndex !== -1) {
        // 如果只有父项
        if (pathParts.length === 1 && navItems.value[navIndex].path) {
            router.push(navItems.value[navIndex].path)
        }
        // 如果还有子项
        else if (pathParts.length > 1) {
            const childText = pathParts[1]
            const childItem = navItems.value[navIndex].children?.find(
                child => child.text === childText
            )

            if (childItem && childItem.path) {
                router.push(childItem.path)
            }
        }
    }
}

// 监听路由变化
watch(
    () => router.currentRoute.value.path,
    newPath => {
        // 设置是否隐藏头像
        hideAvatar.value = newPath.startsWith('/main/profile')
        // 找到匹配的导航项索引
        const matchedIndex = navItems.value.findIndex(
            item => item.path && newPath.startsWith(item.path)
        )

        if (matchedIndex !== -1) {
            activationState.activeParent = matchedIndex
            activationState.activeChild = {
                parentIndex: null,
                childIndex: null
            }

            // 设置当前路径显示
            updateCurrentPathDisplay(navItems.value[matchedIndex])
        }

        // 检查子菜单路径匹配
        navItems.value.forEach((item, parentIdx) => {
            if (item.children) {
                const childIdx = item.children.findIndex(
                    child => child.path && newPath.startsWith(child.path)
                )
                if (childIdx !== -1) {
                    activationState.activeParent = parentIdx
                    activationState.activeChild = {
                        parentIndex: parentIdx,
                        childIndex: childIdx
                    }

                    // 设置当前路径显示（包含父子结构）
                    updateCurrentPathDisplay(item, item.children[childIdx])
                }
            }
        })
    },
    () => router.currentRoute.value,
    () => {
        // Slight delay to ensure the DOM is updated
        setTimeout(() => {
            applyTheme()
        }, 50)
    }
)

// 修改: 更新路径显示的方法
const updateCurrentPathDisplay = (parent, child = null) => {
    // 检查是否是主题设置
    if (
        parent.text === '系统设置' &&
        child &&
        (child.text === '浅色模式' || child.text === '深色模式')
    ) {
        // 可以选择不更新路径，或者设置为空
        // 这里选择保留当前路径不变
        return
    }

    if (child) {
        currentPathDisplay.value = `${parent.text} > ${child.text}`
    } else {
        currentPathDisplay.value = parent.text
    }
}

const updateTime = () => {
    const now = new Date()
    currentTime.value = now.toLocaleTimeString('zh-CN', {
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit',
        hour12: false
    })
}

// 新增响应式状态
const isMobile = ref(false)
const showMask = ref(false)

let timer = null

onMounted(() => {
    const avatarUrlFromLocal = localStorage.getItem('avatorUrl')
    if (avatarUrlFromLocal) {
        avatarUrl.value = avatarUrlFromLocal
    }
    checkScreenSize()
    window.addEventListener('resize', checkScreenSize)

    // 设置首页为激活状态
    activationState.activeParent = 0
    activationState.activeChild = { parentIndex: null, childIndex: null }

    // 初始化当前路径显示
    currentPathDisplay.value = navItems.value[0].text

    // 折叠所有其他父级菜单（与点击逻辑保持一致）
    navItems.value.forEach((navItem, idx) => {
        if (idx !== 0) navItem.expanded = false
    })

    updateTime()
    timer = setInterval(updateTime, 1000)

    applyTheme()
    // 恢复主题激活状态
    const savedTheme = localStorage.getItem('theme')
    const themeIndex = savedTheme === 'dark' ? 1 : 0
    activationState.activeChild = {
        parentIndex: 3, // 假设系统设置是第四个导航项
        childIndex: themeIndex
    }

    // If user navigates directly to a route, ensure theme is applied
    setTimeout(() => {
        applyTheme()
    }, 100)

    // 初始化路径显示 - 根据当前路由路径设置
    const currentPath = router.currentRoute.value.path
    initCurrentPathDisplay(currentPath)
})

// 新增: 初始化路径显示
const initCurrentPathDisplay = currentPath => {
    // 检查主菜单项匹配
    const parentMatch = navItems.value.find(
        item => item.path && currentPath.startsWith(item.path)
    )

    if (parentMatch) {
        currentPathDisplay.value = parentMatch.text
        return
    }

    // 检查子菜单项匹配
    for (const parent of navItems.value) {
        if (parent.children) {
            const childMatch = parent.children.find(
                child => child.path && currentPath.startsWith(child.path)
            )
            if (childMatch) {
                // 检查是否是主题设置路径
                if (
                    parent.text === '系统设置' &&
                    (childMatch.text === '浅色模式' ||
                        childMatch.text === '深色模式')
                ) {
                    // 不更新路径
                    return
                }

                currentPathDisplay.value = `${parent.text} > ${childMatch.text}`
                return
            }
        }
    }

    // 默认显示首页
    currentPathDisplay.value = '首页'
}

onBeforeUnmount(() => {
    window.removeEventListener('resize', checkScreenSize)
    if (timer) clearInterval(timer)
})

// 在script setup部分添加
const isManualToggle = ref(false) // 新增手动操作标识

// 修改checkScreenSize函数
const checkScreenSize = () => {
    const prevIsMobile = isMobile.value
    isMobile.value = window.innerWidth <= 800

    // 新增: 检查是否需要隐藏路径
    isPathHidden.value = window.innerWidth < 1200

    // 当切换到桌面端时强制关闭遮罩
    if (!isMobile.value) {
        showMask.value = false
    }

    // 仅在首次进入移动端时自动收起导航
    if (isMobile.value && !prevIsMobile) {
        navLeftOffset.value = '-220px'
        isCollapsed.value = true
        // 重置手动操作状态避免干扰
        isManualToggle.value = false
    }
    // 当从移动端回到桌面时强制显示导航
    else if (!isMobile.value && prevIsMobile) {
        navLeftOffset.value = '0px'
        isCollapsed.value = false
        isManualToggle.value = false
    }

    // 强制同步遮罩状态
    if (isMobile.value) {
        showMask.value = !isCollapsed.value && navLeftOffset.value === '0px'
    }
}

const isCollapsed = ref(false)
const navLeftOffset = ref('0px')

// 修改toggleCollapse函数
const toggleCollapse = () => {
    isCollapsed.value = !isCollapsed.value
    navLeftOffset.value = isCollapsed.value ? '-220px' : '0px'
    showMask.value = !isCollapsed.value && isMobile.value

    isManualToggle.value = isMobile.value && !isCollapsed.value
}

// 修改遮罩点击处理
const handleMaskClick = () => {
    if (isMobile.value) {
        isCollapsed.value = true
        navLeftOffset.value = '-220px'
        showMask.value = false
        // 保持手动操作标记为true
    }
}

const activeIndex = ref(0)
const handleNavClick = index => {
    activeIndex.value = index
    // 这里可以添加路由跳转逻辑
}

const navItems = ref([
    {
        text: '首页',
        icon: Document,
        path: '/main/home' // 新增路径属性
    },
    {
        text: '个人中心',
        icon: User,
        path: '/main/profile' // 新增路径属性
    },
    {
        text: '功能菜单',
        icon: Grid,
        expanded: false,
        children: [
            { text: '联系人管理', path: '/main/users' },
            { text: '文章管理', path: '/main/articles' }
        ],
        activeChild: null
    },
    {
        text: '系统设置',
        icon: Setting,
        expanded: false,
        children: [{ text: '浅色模式' }, { text: '深色模式' }],
        activeChild: null
    },
    {
        text: '退出登录',
        icon: User
    }
])

// 修改后统一管理激活状态
const activationState = reactive({
    activeParent: null,
    activeChild: { parentIndex: null, childIndex: null }
})

// 更新后的切换方法
const toggleExpand = (item, index) => {
    if (item.path) {
        // 有路径的直接跳转
        router.push(item.path)
        activationState.activeParent = index
        activationState.activeChild = { parentIndex: null, childIndex: null }

        // 更新路径显示
        updateCurrentPathDisplay(item)
    } else if (item.children) {
        // 有子菜单的处理逻辑
        item.expanded = !item.expanded
        activationState.activeParent = index
        activationState.activeChild = { parentIndex: null, childIndex: null }
    }

    // 折叠其他父级菜单
    navItems.value.forEach((navItem, idx) => {
        if (idx !== index && !navItem.path) {
            // 只折叠有子菜单的项
            navItem.expanded = false
        }
    })
}

// 更新后的子项点击处理
const handleChildClick = (parentIdx, childIdx, event) => {
    if (event) event.stopPropagation()
    // 新增主题判断逻辑（假设系统设置是navItems的第三个元素）
    if (parentIdx === 3) {
        // 获取主题模式
        const theme = navItems.value[parentIdx].children[childIdx].text
            .toLowerCase()
            .includes('深')
            ? 'dark'
            : 'light'

        // 应用主题
        currentTheme.value = theme
        localStorage.setItem('theme', theme)
        applyTheme()

        // Emit theme change event for other components
        themeEventBus.emit('themeChanged', theme)

        // 设置激活状态
        activationState.activeParent = parentIdx
        activationState.activeChild = {
            parentIndex: parentIdx,
            childIndex: childIdx
        }

        // 不更新路径显示
        return
    }

    activationState.activeParent = parentIdx
    activationState.activeChild = {
        parentIndex: parentIdx,
        childIndex: childIdx
    }
    // Add navigation logic for submenu items
    const parent = navItems.value[parentIdx]
    const child = parent.children[childIdx]

    // 更新路径显示
    updateCurrentPathDisplay(parent, child)

    // Check if child has a path property and navigate
    if (child.path) {
        router.push(child.path)
    }
}

// 新增主题相关状态和方法
const currentTheme = ref(localStorage.getItem('theme') || 'light')

const applyTheme = () => {
    const root = document.documentElement
    if (currentTheme.value === 'dark') {
        // Dark theme settings for navigation
        root.style.setProperty('--nav-bg', '#1a1a1a')
        root.style.setProperty('--nav-text', '#ffffff')
        root.style.setProperty('--nav-hover', '#333333')
        root.style.setProperty('--nav-active', '#2c2c2c')
        root.style.setProperty('--nav-border', '#333333')
        root.style.setProperty('--nav-top-bg', '#1a1a1a')
        root.style.setProperty('--nav-icon-color', '#cccccc')
        root.style.setProperty('--time-display-color', '#ff91b4')
        root.style.setProperty('--path-display-color', '#7ec2ff') // 新增路径颜色

        // Dark theme settings for home page
        root.style.setProperty('--home-bg', '#121212')
        root.style.setProperty('--card-bg', '#1e1e1e')
        root.style.setProperty('--text-primary', '#ffffff')
        root.style.setProperty('--text-secondary', '#aaaaaa')
        root.style.setProperty('--text-tertiary', '#888888')
        root.style.setProperty('--border-color', '#333333')
        root.style.setProperty('--calendar-today-bg', '#1e3a5f')
        root.style.setProperty('--calendar-today-color', '#7ec2ff')
        root.style.setProperty('--calendar-selected-bg', '#0f5694')
        root.style.setProperty('--calendar-hover', '#2a2a2a')
        root.style.setProperty('--button-hover', '#333333')
        root.style.setProperty('--box-shadow', '0 4px 12px rgba(0, 0, 0, 0.5)')
        root.style.setProperty('--section-title-color', '#ffffff')
        root.style.setProperty('--section-title-border', '#0f5694')
    } else {
        // Light theme settings for navigation
        root.style.setProperty('--nav-bg', '#ffffff')
        root.style.setProperty('--nav-text', '#606266')
        root.style.setProperty('--nav-hover', '#f5f5f5')
        root.style.setProperty('--nav-active', '#f0f0f0')
        root.style.setProperty('--nav-border', '#e6e6e6')
        root.style.setProperty('--nav-top-bg', '#ffffff')
        root.style.setProperty('--nav-icon-color', '#808080')
        root.style.setProperty('--time-display-color', '#fb7299')
        root.style.setProperty('--path-display-color', '#fb7299') // 新增路径颜色

        // Light theme settings for home page
        root.style.setProperty('--home-bg', '#ffffff')
        root.style.setProperty('--card-bg', '#ffffff')
        root.style.setProperty('--text-primary', '#333333')
        root.style.setProperty('--text-secondary', '#666666')
        root.style.setProperty('--text-tertiary', '#999999')
        root.style.setProperty('--border-color', '#e0e0e0')
        root.style.setProperty('--calendar-today-bg', '#e6f7ff')
        root.style.setProperty('--calendar-today-color', '#1890ff')
        root.style.setProperty('--calendar-selected-bg', '#1890ff')
        root.style.setProperty('--calendar-hover', '#f9f9f9')
        root.style.setProperty('--button-hover', '#f0f0f0')
        root.style.setProperty('--box-shadow', '0 4px 12px rgba(0, 0, 0, 0.08)')
        root.style.setProperty('--section-title-color', '#333333')
        root.style.setProperty('--section-title-border', '#1890ff')
    }

    // Update the folder icon color based on theme
    const folderIcon = document.querySelector('a.folder')
    if (folderIcon) {
        folderIcon.style.color =
            currentTheme.value === 'dark' ? '#cccccc' : '#808080'
    }
}

const folderIcon = document.querySelector('a.folder')
if (folderIcon) {
    folderIcon.style.color =
        currentTheme.value === 'dark' ? '#cccccc' : '#808080'
}

const resetActivation = currentParent => {
    navItems.value.forEach((item, index) => {
        if (index !== currentParent) {
            item.expanded = false
            item.activeChild = null
        }
    })
}
</script>

<script>
export default {}
</script>

<style scoped>
.big-box {
    position: relative;
    min-height: 100vh;
    overflow-x: hidden;
    overflow-y: auto;
    display: flex;
}

a.folder {
    position: absolute;
    position: fixed;
    left: 20px;
    top: 10px;
    width: 40px;
    height: 40px;
    border-radius: 20px;
    color: #808080;
    text-align: center;
    font-size: 25px;
    z-index: 1010;
}

a.folder:hover {
    background-color: var(--nav-hover);
    will-change: background-color;
    transition-delay: 0.1s;
}

a.folder .el-icon {
    position: absolute;
    top: calc(50% - 12.5px);
    left: calc(50% - 12.5px);
}

.logo {
    position: fixed;
    left: 70px;
    top: 7px;
    height: 45px;
    font-size: 30px;
    color: #7ecafe;
    font-family: '江西拙楷';
    z-index: 4;
}

/* 折叠状态样式 */
.logo-collapsed {
    position: absolute !important;
    left: 70px !important;
    top: 7px !important;
}

.big-box .nav-left {
    position: fixed;
    width: 220px;
    height: 100vh;
    overflow-y: auto;
    box-shadow: 0 2px 5px rgba(0, 0, 0, 0.3);
    padding: 60px 0 20px 0;
    background: var(--nav-bg);
    transition: left 0.3s ease, background-color 0.3s ease;
}

.nav-left {
    transition: left 0.3s ease;
    /* background: #fff; 给个背景色确保覆盖内容 */
    z-index: 2;
}

.nav-left .blank {
    height: 40px;
    width: 100%;
}

.nav-list {
    list-style: none;
    padding: 0;
    margin: 0;
}

.nav-item {
    position: relative;
    height: 40px;
    width: 100%;
    display: flex;
    align-items: center;
    padding: 0 20px;
    cursor: pointer;
    transition: all 0.3s ease;
    color: var(--nav-text);
    font-size: 16px;
    font-weight: 500;
}

.arrow-icon {
    position: absolute;
    right: 20px;
    transition: transform 0.3s ease;
    color: var(--nav-icon-color);
}

.is-expanded .arrow-icon {
    transform: rotate(180deg);
}

.nav-item.active .arrow-icon {
    color: var(--el-color-primary);
}

.nav-item .el-icon {
    margin-left: 20px;
    margin-right: 10px;
}

.nav-item span {
    /* font-size: 18px; */
    white-space: nowrap;
}

.nav-item:hover {
    background: var(--nav-hover);
}

.nav-item.active {
    background: var(--nav-active);
}

.main-area {
    margin-left: 220px; /* 与导航栏宽度一致 */
    transition: margin 0.3s ease;
    flex: 1;
    background-color: var(--nav-bg);
    overflow-x: auto;
}

/* 折叠时主内容区域的调整 */
.is-collapsed .main-area {
    margin-left: 0;
}

/* 如果要实现更平滑的图标切换 */
.el-icon {
    transition: transform 0.3s ease;
}

/* 添加子项激活状态 */
.nav-item.sub-item.active,
.nav-item.sub-item.sub-active {
    background: #f0f0f0 !important;
}

/* 同时保持父级激活状态 */
.nav-item.active {
    background: var(--nav-hover);
}

/* 子菜单缩进样式 */
.submenu-list .nav-item {
    padding-left: 50px !important;
}

/* 调整父项样式 */
.parent-item {
    order: 2; /* 始终在子项下方 */
}

.submenu-list {
    order: 1;
    width: 100%;
    background: var(--nav-bg);
    border-radius: 4px;
    margin: 4px 0;
    transition: all 0.3s ease;
}

/* 子项独立样式 */
.submenu-list .sub-item {
    height: 40px;
    padding-left: 65px !important;
    color: var(--nav-text);
    font-size: 16px;
}

.submenu-list .sub-item:hover {
    background: var(--nav-hover);
}

.nav-item.sub-item.active,
.nav-item.sub-item.sub-active {
    background: var(--nav-active) !important;
}

.submenu-list .sub-item:first-child {
    margin-top: 4px;
}

.submenu-list .sub-item:last-child {
    margin-bottom: 4px;
}

.arrow-icon {
    transition: transform 0.3s ease, color 0.3s ease;
}

.parent-item.active .arrow-icon {
    color: var(--el-color-primary);
}

.main-area {
    position: absolute;
    margin-left: 220px; /* 导航展开时的边距 */
    transition: margin-left 0.3s cubic-bezier(0.4, 0, 0.2, 1), filter 0.3s ease; /* 同步过渡效果 */
    flex: 1;
    min-width: calc(100% - 220px); /* 防止内容溢出 */
    width: auto;
}

.nav-left[style*='-220px'] + .main-area {
    /* 当导航折叠时 */
    margin-left: 0;
    min-width: 100%;
}

.main-area .nav-top {
    position: absolute;
    width: 100%;
    height: 60px;
    background-color: var(--nav-top-bg);
    transition: background-color 0.3s ease;
}

/* 修改当前路径显示样式 - 添加可点击样式 */
.current-path {
    position: absolute;
    left: 10%;
    top: calc(50% + 5px);
    transform: translateY(-50%);
    font-size: 18px;
    color: var(--path-display-color);
    font-weight: 500;
    padding: 5px 12px;
    cursor: pointer; /* 添加指针样式表明可点击 */
    transition: opacity 0.2s ease;
    display: flex;
    align-items: center;
}

.current-path:hover {
    opacity: 0.8; /* 悬停时轻微变淡以提示可点击 */
    text-decoration: underline; /* 添加下划线效果 */
}

/* 添加右箭头图标样式 */
.path-arrow {
    margin: 0 5px;
    font-size: 14px;
    color: var(--path-display-color);
}

.nav-top .avatar {
    position: absolute;
    right: 10%;
    top: 8px;
    height: 44px;
    width: 44px;
    border-radius: 50%;
}

.nav-top .time-display {
    position: absolute;
    right: 20%;
    top: calc(50% + 5px);
    transform: translateY(-50%);
    font-size: 25px;
    color: var(--time-display-color);
    font-weight: 500;
    padding: 5px 12px;
}

a.folder {
    color: var(--nav-icon-color);
}

a.folder:hover {
    background-color: var(--nav-hover);
}
/* 新增响应式样式 */
@media screen and (max-width: 800px) {
    .nav-left {
        width: 220px;
        left: -220px; /* 初始隐藏 */
        transition: left 0.3s ease;
        box-shadow: 2px 0 8px rgba(0, 0, 0, 0.15);
        z-index: 1000;
    }

    .nav-left.mobile-nav {
        left: 0;
    }

    .main-area {
        margin-left: 0 !important; /* 强制覆盖桌面样式 */
        min-width: 100vw; /* 全屏显示 */
        transition: filter 0.3s ease; /* 只保留模糊过渡 */
    }

    .mask {
        position: fixed;
        top: 0;
        left: 0;
        right: 0;
        bottom: 0;
        width: 100vw;
        height: 100vh;
        background: rgba(0, 0, 0, 0.4);
        border: none;
        z-index: 998;
        transition: opacity 0.3s;
    }

    /* 增加导航栏的z-index */
    .nav-left {
        z-index: 999; /* 原2改为999 */
    }

    .logo {
        z-index: 1000; /* 原4改为1000 */
    }

    a.folder {
        z-index: 1001;
    }

    .folder {
        display: block; /* 移动端始终显示折叠按钮 */
    }

    .nav-top .time-display {
        right: 25%;
        font-size: 20px;
    }

    /* 移动端调整路径显示位置 */
    .current-path {
        left: 20%;
        font-size: 16px;
    }
}
.avatar-wrapper {
    position: relative;
    cursor: pointer;
}

.avatar {
    width: 40px;
    height: 40px;
    border-radius: 50%;
    object-fit: cover;
    border: 2px solid var(--border-color);
}

.dropdown-menu {
    position: absolute;
    right: 0;
    top: 50px;
    min-width: 160px;
    background: var(--card-bg);
    border-radius: 4px;
    box-shadow: var(--box-shadow);
    border: 1px solid var(--border-color);
    z-index: 1000;
}

.menu-item {
    display: flex;
    align-items: center;
    padding: 12px 16px;
    color: var(--text-primary);
    transition: all 0.3s;

    &:hover {
        background-color: var(--hover-bg);
    }

    i {
        margin-right: 8px;
        font-size: 16px;
    }
}

/* 主题变量 */
:root {
    --card-bg: #ffffff;
    --text-primary: #303133;
    --border-color: #ebeef5;
    --hover-bg: #f5f7fa;
    --box-shadow: 0 2px 12px rgba(0, 0, 0, 0.1);
}

[data-theme='dark'] {
    --card-bg: #2d2d2d;
    --text-primary: #e5e5e5;
    --border-color: #434343;
    --hover-bg: #3a3a3a;
    --box-shadow: 0 2px 12px rgba(0, 0, 0, 0.3);
}
</style>
