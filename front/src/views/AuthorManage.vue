<template>
    <div class="profile-container">
        <div class="top-section">
            <div class="left-container" v-show="!isLoading">
                <!-- Avatar area with better mobile handling -->
                <div class="avatar-container">
                    <img
                        :src="author.avatar"
                        alt="作者头像"
                        class="avatar"
                        v-if="author.avatar"
                    />
                    <div class="avatar-placeholder" v-else>
                        <img
                            src="https://via.placeholder.com/300x300"
                            alt="默认头像"
                            style="width: 100%; height: 100%; object-fit: cover"
                        />
                    </div>
                </div>
            </div>
            <div class="right-container" v-show="!isLoading">
                <h2 class="user-info-title">作者基本信息</h2>
                <!-- User info table with improved mobile layout -->
                <div class="table-responsive">
                    <el-table :data="authorInfo" style="width: 100%">
                        <el-table-column
                            prop="label"
                            label="信息项"
                            width="100"
                        ></el-table-column>
                        <el-table-column
                            prop="value"
                            label="详情"
                        ></el-table-column>
                    </el-table>
                </div>
                <div class="return-button-container">
                    <el-button type="primary" @click="goBack">返回</el-button>
                </div>
            </div>
        </div>
        <div class="article-management" v-show="!isLoading">
            <div class="article-ops">
                <div class="action-buttons">
                    <el-button type="primary" @click="showAddDialog"
                        >+ 新增</el-button
                    >
                </div>
                <div class="search-container">
                    <el-input
                        placeholder="请输入标题"
                        v-model="searchTitle"
                        prefix-icon="el-icon-search"
                        class="search-input"
                    ></el-input>
                    <el-button type="primary" @click="searchArticles"
                        >搜索</el-button
                    >
                </div>
            </div>
            <div class="table-responsive">
                <el-table :data="articles" border style="width: 100%">
                    <el-table-column
                        type="index"
                        label="序号"
                        width="60"
                    ></el-table-column>
                    <el-table-column
                        prop="title"
                        label="文章标题"
                        min-width="120"
                        show-overflow-tooltip
                    ></el-table-column>
                    <el-table-column
                        prop="content"
                        label="文章内容"
                        min-width="150"
                        show-overflow-tooltip
                    ></el-table-column>
                    <el-table-column label="操作" width="150" fixed="right">
                        <template #default="scope">
                            <el-button
                                type="text"
                                @click="showEditDialog(scope.row)"
                                >修改</el-button
                            >
                            <el-button
                                type="text"
                                @click="deleteArticle(scope.row.id)"
                                >删除</el-button
                            >
                        </template>
                    </el-table-column>
                </el-table>
            </div>
        </div>
        <div class="loading" v-show="isLoading">
            <el-loading type="spinner" color="#64B5F6" />
            <p>加载中...</p>
        </div>
        <!-- Add article dialog with viewport width -->
        <el-dialog
            v-model="addDialogVisible"
            title="新增文章"
            :class="['add-dialog', $attrs.class]"
            append-to-body
            destroy-on-close
        >
            <el-form
                :model="newArticle"
                label-width="80px"
                label-position="top"
            >
                <el-form-item label="标题" required>
                    <el-input
                        v-model="newArticle.title"
                        placeholder="请输入标题"
                        class="title-input"
                    />
                </el-form-item>
                <el-form-item label="内容" required>
                    <el-input
                        v-model="newArticle.content"
                        type="textarea"
                        :rows="5"
                        placeholder="请输入文章内容"
                    />
                </el-form-item>
            </el-form>
            <template #footer>
                <div class="dialog-footer">
                    <el-button @click="addDialogVisible = false"
                        >取消</el-button
                    >
                    <el-button type="primary" @click="saveArticle"
                        >确认</el-button
                    >
                </div>
            </template>
        </el-dialog>
        <!-- Edit article dialog with viewport width -->
        <el-dialog
            v-model="editDialogVisible"
            title="编辑文章"
            :class="['edit-dialog', $attrs.class]"
            append-to-body
            destroy-on-close
        >
            <el-form
                :model="currentArticle"
                label-width="80px"
                label-position="top"
            >
                <el-form-item label="标题" required>
                    <el-input
                        v-model="currentArticle.title"
                        placeholder="请输入标题"
                        class="title-input"
                    />
                </el-form-item>
                <el-form-item label="内容" required>
                    <el-input
                        v-model="currentArticle.content"
                        type="textarea"
                        :rows="5"
                        placeholder="请输入文章内容"
                    />
                </el-form-item>
            </el-form>
            <template #footer>
                <div class="dialog-footer">
                    <el-button @click="editDialogVisible = false"
                        >取消</el-button
                    >
                    <el-button type="primary" @click="updateArticle"
                        >确认</el-button
                    >
                </div>
            </template>
        </el-dialog>
    </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRouter } from 'vue-router'
import axios from 'axios'
import { ElMessage } from 'element-plus'
const editDialogVisible = ref(false)
const currentArticle = ref({
    id: null,
    title: '',
    content: '',
    authorName: ''
})

const showEditDialog = article => {
    currentArticle.value = {
        ...article,
        authorName: authorName.value // 确保作者名正确
    }
    editDialogVisible.value = true
}

const updateArticle = async () => {
    if (!currentArticle.value.title || !currentArticle.value.content) {
        ElMessage.warning('标题和内容为必填项')
        return
    }

    try {
        await axios.put(
            `/api/articles/${currentArticle.value.id}`,
            currentArticle.value
        )
        editDialogVisible.value = false
        fetchArticles()
        ElMessage.success('修改成功')
    } catch (error) {
        ElMessage.error('修改文章失败')
        console.error('修改文章错误:', error)
    }
}
const router = useRouter()
const isLoading = ref(true)

// 从 localStorage 中获取作者名
const authorName = ref(localStorage.getItem('authorName') || '')

// 作者信息相关
const author = ref({
    name: '',
    email: '',
    money: 0,
    birthday: '',
    avatar: ''
})
const authorInfo = ref([])

// 文章相关
const articles = ref([])
const searchTitle = ref('')
const addDialogVisible = ref(false)
const newArticle = ref({
    authorName: '', // 从 localStorage 自动填充
    title: '',
    content: ''
})

// 获取作者详细信息（使用 localStorage 中的作者名）
const fetchAuthorInfo = async () => {
    if (!authorName.value) {
        ElMessage.error('未获取到作者信息，请重新登录')
        router.push('/login') // 示例：跳转到登录页
        return
    }

    try {
        const response = await axios.get(`/api/authorts/${authorName.value}`)
        author.value = response.data

        // 更新作者信息表格
        authorInfo.value = [
            { label: '用户名', value: author.value.name },
            { label: '邮箱', value: author.value.email },
            { label: '余额', value: author.value.money },
            { label: '生日', value: formattedBirthday.value }
        ]

        // 自动填充新文章的作者名
        newArticle.value.authorName = author.value.name
    } catch (error) {
        ElMessage.error('获取作者信息失败')
        console.error('Error fetching author:', error)
    }
}

// 获取文章列表（使用 localStorage 中的作者名）
const fetchArticles = async () => {
    if (!authorName.value) return

    try {
        const params = {
            authorName: authorName.value, // 从 localStorage 取作者名
            title: searchTitle.value
        }
        const response = await axios.get('/api/articles', { params })
        articles.value = response.data.datas // 假设后端返回文章列表

        isLoading.value = false
    } catch (error) {
        ElMessage.error('获取文章列表失败')
        console.error('Error fetching articles:', error)
    } finally {
    }
}

// 格式化生日
const formattedBirthday = computed(() => {
    if (!author.value.birthday) return ''
    const date = new Date(author.value.birthday)
    return `${date.getFullYear()}年${date.getMonth() + 1}月${date.getDate()}日`
})

onMounted(async () => {
    // 检查 localStorage 中是否有作者名
    if (!authorName.value) {
        ElMessage.error('请先登录或选择作者')
        router.push('/author-list') // 示例：跳转到作者列表页
        return
    }

    try {
        await fetchAuthorInfo()
        await fetchArticles()
    } catch (error) {
        isLoading.value = false
    }
})

const goBack = () => {
    router.go(-1) // 返回上一页
}

const showAddDialog = () => {
    addDialogVisible.value = true
}

const saveArticle = async () => {
    if (!newArticle.value.title || !newArticle.value.content) {
        ElMessage.warning('标题和内容为必填项')
        return
    }

    try {
        await axios.post('/api/articles', newArticle.value)
        addDialogVisible.value = false
        fetchArticles()
    } catch (error) {
        ElMessage.error('保存文章失败，请重试')
        console.error('保存文章错误:', error)
    }
}

const searchArticles = () => {
    fetchArticles()
}

const deleteArticle = async id => {
    if (!window.confirm('确定要删除这篇文章吗？')) return

    try {
        await axios.delete(`/api/articles/${id}`)
        fetchArticles()
    } catch (error) {
        ElMessage.error('删除文章失败，请重试')
        console.error('删除文章错误:', error)
    }
}
</script>
<style scoped>
.profile-container {
    display: flex;
    flex-direction: column;
    gap: 20px;
    max-width: 1200px;
    margin: 20px auto;
    padding: 15px;
}

.top-section {
    display: flex;
    flex-direction: column;
    gap: 20px;
}

.left-container {
    width: 100%;
    background: var(--card-bg);
    padding: 20px;
    border-radius: 8px;
    box-shadow: var(--box-shadow);
    border: 1px solid var(--border-color);
}

.right-container {
    width: 100%;
    background: var(--card-bg);
    padding: 20px;
    border-radius: 8px;
    box-shadow: var(--box-shadow);
    border: 1px solid var(--border-color);
}

.user-info-title {
    text-align: center;
    margin-bottom: 20px;
    color: var(--text-primary);
    font-size: 20px;
}

.avatar-container {
    max-width: 250px;
    margin: 0 auto;
}

.avatar-placeholder {
    height: 250px;
    background-color: var(--avatar-placeholder-bg);
    display: flex;
    justify-content: center;
    align-items: center;
    border-radius: 8px;
}

.avatar {
    width: 100%;
    height: 250px;
    object-fit: cover;
    border-radius: 8px;
}

.return-button-container {
    display: flex;
    justify-content: center;
    margin-top: 20px;
}

.article-management {
    background: var(--card-bg);
    padding: 15px;
    border-radius: 8px;
    box-shadow: var(--box-shadow);
    border: 1px solid var(--border-color);
}

.article-ops {
    display: flex;
    flex-direction: column;
    gap: 10px;
    margin-bottom: 15px;
}

.el-table {
    width: 100% !important;
    overflow-x: auto;
}

/* 修改后的样式 */
.action-buttons {
    display: flex;
    gap: 10px; /* 按钮间距 */
}

.search-container {
    display: flex;
    gap: 10px; /* 搜索框和按钮间距 */
    align-items: center;
}

.search-input {
    flex: 1; /* 搜索栏占满可用空间 */
}

/* Responsive table adjustments */
:deep(.el-table) {
    max-width: 100%;
    overflow-x: auto;
}

/* Table cell styles */
:deep(.el-table td, .el-table th) {
    background-color: var(--card-bg);
    color: var(--text-primary);
    border-bottom-color: var(--border-color);
    padding: 8px;
}

/* Header style enhancement */
:deep(.el-table__header th) {
    background-color: var(--table-header-bg);
    color: var(--text-primary);
    font-weight: 600;
}

/* Pagination component adaptation */
:deep(.el-pagination) {
    --el-pagination-bg-color: var(--card-bg);
    --el-pagination-text-color: var(--text-primary);
    --el-pagination-button-disabled-bg-color: var(--card-bg);
    --el-pagination-button-bg-color: var(--card-bg);
    margin-top: 15px;
    display: flex;
    justify-content: center;
    flex-wrap: wrap;
}

/* Input theme adaptation */
:deep(.el-input__inner) {
    background-color: var(--card-bg);
    border-color: var(--border-color);
    color: var(--text-primary);
}

/* Button group unified theme */
:deep(.el-button) {
    background-color: var(--button-bg);
    border-color: var(--border-color);
    color: var(--text-primary);
}

/* Dialog styles */
:deep(.edit-dialog),
:deep(.add-dialog) {
    --el-dialog-bg-color: var(--card-bg);
    --el-text-color-primary: var(--text-primary);
    --el-border-color-light: var(--border-color);
    width: 90% !important;
    max-width: 600px;
}

:deep(.edit-dialog .el-dialog__header),
:deep(.add-dialog .el-dialog__header) {
    border-bottom: 1px solid var(--border-color);
    padding: 15px;
}

:deep(.edit-dialog .el-dialog__title),
:deep(.add-dialog .el-dialog__title) {
    color: var(--text-primary);
    font-size: 18px;
}

:deep(.edit-dialog .el-dialog__body),
:deep(.add-dialog .el-dialog__body) {
    padding: 15px;
}

:deep(.edit-dialog .el-input__inner),
:deep(.edit-dialog .el-textarea__inner),
:deep(.add-dialog .el-input__inner),
:deep(.add-dialog .el-textarea__inner) {
    background-color: var(--card-bg);
    color: var(--text-primary);
    border-color: var(--border-color);
}

:deep(.edit-dialog .el-input__inner::placeholder),
:deep(.edit-dialog .el-textarea__inner::placeholder),
:deep(.add-dialog .el-input__inner::placeholder),
:deep(.add-dialog .el-textarea__inner::placeholder) {
    color: var(--text-tertiary);
}

:deep(.edit-dialog .el-form-item__label),
:deep(.add-dialog .el-form-item__label) {
    color: var(--text-primary);
}

:deep(.el-button) {
    margin-left: 15px;
}

/* Root theme variables */
:root {
    --card-bg: #ffffff;
    --table-header-bg: #f5f7fa;
    --row-hover-bg: #f5f8ff;
    --text-primary: #333333;
    --text-tertiary: #999999;
    --border-color: #e0e0e0;
    --button-bg: #ffffff;
    --box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);
    --avatar-placeholder-bg: #f2f2f2;
}

[data-theme='dark'] {
    --card-bg: #2d2d2d;
    --table-header-bg: #3a3e45;
    --row-hover-bg: #4e535c;
    --text-primary: #e0e0e0;
    --text-tertiary: #888888;
    --border-color: #444444;
    --button-bg: #444444;
    --box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.2);
    --avatar-placeholder-bg: #444444;
}

/* Media queries for responsiveness */
@media (max-width: 768px) {
    .profile-container {
        padding: 30px;
        margin: 40px auto;
        margin-top: 80px;
        width: 100vw;
    }
}

@media (min-width: 768px) {
    .profile-container {
        padding: 30px;
        margin: 40px auto;
        margin-top: 80px;
    }

    .article-ops {
        flex-direction: row;
        align-items: center;
    }

    .top-section {
        flex-direction: row;
    }

    .left-container {
        width: 300px;
        flex-shrink: 0;
    }

    .right-container {
        flex: 1;
    }

    .return-button-container {
        justify-content: flex-end;
    }
}

@media (min-width: 992px) {
    .profile-container {
        padding: 50px;
        margin: 60px auto;
    }
}

@media (min-width: 1200px) {
    .profile-container {
        padding: 80px;
        margin: 80px auto;
    }
}

/* Table outer borders */

:deep(.el-input__prefix) {
    background-color: var(--card-bg);
}

:deep(.el-input__wrapper) {
    background-color: var(--card-bg);
}

:deep(.el-table) {
    border-color: var(--border-color) !important;
}

:deep(.el-table--border) {
    border-color: var(--border-color) !important;
}

/* Table cell borders */
:deep(.el-table td.el-table__cell),
:deep(.el-table th.el-table__cell.is-leaf) {
    border-color: var(--border-color) !important;
}

/* Table border lines */
:deep(.el-table--border::after),
:deep(.el-table--border::before),
:deep(.el-table__inner-wrapper::before) {
    background-color: var(--border-color) !important;
}

/* Fixed columns borders */
:deep(.el-table__fixed-right::before),
:deep(.el-table__fixed::before) {
    background-color: var(--border-color) !important;
}

/* Border patches */
:deep(.el-table__border-left-patch),
:deep(.el-table__fixed-right-patch) {
    background-color: var(--border-color) !important;
}

/* Footer borders if you have them */
:deep(.el-table__footer-wrapper tbody td.el-table__cell) {
    border-color: var(--border-color) !important;
}

/* Header borders when sticky */
:deep(.el-table.is-scrolling-left .el-table__fixed-right.has-gutter),
:deep(.el-table.is-scrolling-right .el-table__fixed.has-gutter) {
    border-color: var(--border-color) !important;
}

/* Additional vertical borders */
:deep(.el-table .el-table__cell) {
    border-right-color: var(--border-color) !important;
}

/* Append slot borders if you use them */
:deep(.el-table__append-wrapper) {
    border-color: var(--border-color) !important;
}

:deep(.el-table th.el-table__cell) {
    background-color: var(--nav-active) !important;
    color: var(--text-primary) !important;
    border-color: var(--border-color) !important;
}

:deep(.el-table td.el-table__cell) {
    background-color: var(--card-bg) !important;
    color: var(--text-primary) !important;
    border-color: var(--border-color) !important;
}

:deep(
        .el-table--striped
            .el-table__body
            tr.el-table__row--striped
            td.el-table__cell
    ) {
    background-color: var(--nav-hover) !important;
}

:deep(.el-table__row) {
    height: 60px;
}

:deep(.el-table__body tr:hover td.el-table__cell) {
    background-color: var(--nav-hover) !important;
}

:deep(.el-pagination) {
    --el-pagination-font-size: 14px;
    --el-pagination-bg-color: transparent;
    --el-pagination-text-color: var(--text-secondary);
    --el-pagination-button-color: var(--text-secondary);
    --el-pagination-hover-color: var(--calendar-today-color);
    --el-pagination-button-bg-color: var(--card-bg);
    --el-pagination-button-disabled-color: var(--text-tertiary);
    --el-pagination-button-disabled-bg-color: var(--card-bg);
    --el-pagination-hover-bg-color: var(--nav-hover);
}

:deep(.el-table) {
    --el-table-border-color: var(--border-color) !important;
    --el-table-header-border-color: var(--border-color) !important;
    --el-table-border: 1px solid var(--border-color) !important;
    --el-table-cell-border-color: var(--border-color) !important;
}

/* Force override with !important for all possible table elements */
:deep(.el-table),
:deep(.el-table__inner-wrapper),
:deep(.el-table__header-wrapper),
:deep(.el-table__body-wrapper),
:deep(.el-table__footer-wrapper),
:deep(.el-table__header),
:deep(.el-table__body),
:deep(.el-table__footer),
:deep(.el-table__cell),
:deep(.el-table th.el-table__cell),
:deep(.el-table td.el-table__cell),
:deep(.el-table .el-table__cell.is-leaf),
:deep(.el-table--border),
:deep(.el-table--group) {
    border-color: var(--border-color) !important;
}

/* Target horizontal and vertical divider lines */
:deep(.el-table::before),
:deep(.el-table::after),
:deep(.el-table__inner-wrapper::before),
:deep(.el-table__inner-wrapper::after),
:deep(.el-table--border::before),
:deep(.el-table--border::after) {
    background-color: var(--border-color) !important;
}

/* Ensure the top edge of the table is correctly colored */
:deep(.el-table__header-wrapper tr:first-child th.el-table__cell) {
    border-top-color: var(--border-color) !important;
}

:deep(.el-overlay-dialog) {
    background-color: var(--card-bg) !important;
}

:deep(.el-button span) {
    color: var(--text-primary) !important;
}
</style>
