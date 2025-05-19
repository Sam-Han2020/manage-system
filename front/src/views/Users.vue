<template>
    <div>
        <el-dialog
            v-model="addDialogVisible"
            title="联系人"
            width="600px"
            @closed="resetForm"
        >
            <el-form
                :model="addForm"
                :rules="formRules"
                ref="addFormRef"
                label-width="80px"
            >
                <el-form-item label="姓名" prop="name">
                    <el-input v-model="addForm.name" />
                </el-form-item>

                <el-form-item label="省份" prop="provinceId">
                    <el-select
                        v-model="addForm.provinceId"
                        placeholder="请选择省份"
                        @change="handleProvinceChange"
                    >
                        <el-option
                            v-for="province in provinces"
                            :key="province.id"
                            :label="province.name"
                            :value="province.id"
                        />
                    </el-select>
                </el-form-item>

                <el-form-item label="城市" prop="cityId">
                    <el-select
                        v-model="addForm.cityId"
                        placeholder="请先选择城市"
                        :disabled="!addForm.provinceId"
                    >
                        <el-option
                            v-for="city in cities"
                            :key="city.id"
                            :label="city.name"
                            :value="city.id"
                        />
                    </el-select>
                </el-form-item>

                <el-form-item label="详细地址" prop="address">
                    <el-input v-model="addForm.address" />
                </el-form-item>

                <el-form-item label="邮编" prop="zip">
                    <el-input v-model="addForm.zip" />
                </el-form-item>
            </el-form>

            <template #footer>
                <el-button @click="addDialogVisible = false">取消</el-button>
                <el-button type="primary" @click="submitAddForm"
                    >提交</el-button
                >
            </template>
        </el-dialog>
        <div class="user-management-container">
            <div class="user-management-header">
                <h2 class="section-title">联系人管理列表</h2>
            </div>

            <div class="table-operations">
                <el-button type="primary" size="small" @click="handleAdd">
                    <el-icon><Plus /></el-icon> 新增
                </el-button>

                <div class="search-box">
                    <el-input
                        v-model="searchQuery"
                        placeholder="输入关键词"
                        prefix-icon="Search"
                        clearable
                        @clear="loadUserData"
                        @keyup.enter="handleSearch"
                    />
                    <el-button type="primary" @click="handleSearch"
                        >搜索</el-button
                    >
                </div>
            </div>

            <!-- Desktop Table (shows on screens larger than 800px) -->
            <div v-if="!isMobileView" class="desktop-table-container">
                <el-table
                    :data="userData"
                    border
                    stripe
                    :header-cell-style="headerCellStyle"
                    :cell-style="cellStyle"
                >
                    <el-table-column
                        type="selection"
                        width="55"
                        align="center"
                    />
                    <el-table-column
                        label="序号"
                        type="index"
                        width="70"
                        align="center"
                    />
                    <el-table-column
                        prop="date"
                        label="日期"
                        min-width="160"
                        align="center"
                    />
                    <el-table-column
                        prop="name"
                        label="姓名"
                        min-width="100"
                        align="center"
                    />
                    <el-table-column
                        prop="province"
                        label="省份"
                        min-width="80"
                        align="center"
                    />
                    <el-table-column
                        prop="city"
                        label="城市"
                        min-width="80"
                        align="center"
                    />
                    <el-table-column
                        prop="address"
                        label="地址"
                        min-width="250"
                        align="center"
                        show-overflow-tooltip
                    />
                    <el-table-column
                        prop="zip"
                        label="邮编"
                        min-width="100"
                        align="center"
                    />
                    <el-table-column
                        label="操作"
                        min-width="120"
                        align="center"
                    >
                        <template #default="scope">
                            <el-button
                                size="small"
                                type="primary"
                                @click="handleEdit(scope.row)"
                                text
                                >编辑</el-button
                            >
                            <el-button
                                size="small"
                                type="danger"
                                @click="handleDelete(scope.row)"
                                text
                                >删除</el-button
                            >
                        </template>
                    </el-table-column>
                </el-table>
            </div>

            <!-- Mobile View (shows on screens smaller than 800px) -->
            <div v-else class="mobile-table-view">
                <div
                    v-for="(user, index) in userData"
                    :key="user.id"
                    class="mobile-card"
                >
                    <div class="mobile-card-header">
                        <span class="mobile-card-index">{{
                            (currentPage - 1) * pageSize + index + 1
                        }}</span>
                        <span class="mobile-card-name">{{ user.name }}</span>
                    </div>
                    <div class="mobile-card-content">
                        <div class="mobile-card-item">
                            <span class="mobile-item-label">日期:</span>
                            <span class="mobile-item-value">{{
                                user.date
                            }}</span>
                        </div>
                        <div class="mobile-card-item">
                            <span class="mobile-item-label">城市:</span>
                            <span class="mobile-item-value">{{
                                user.city
                            }}</span>
                        </div>
                        <!-- <div class="mobile-card-item">
                            <span class="mobile-item-label">地区:</span>
                            <span class="mobile-item-value">{{
                                user.area
                            }}</span>
                        </div> -->
                        <div class="mobile-card-item">
                            <span class="mobile-item-label">地址:</span>
                            <span class="mobile-item-value">{{
                                user.address
                            }}</span>
                        </div>
                        <div class="mobile-card-item">
                            <span class="mobile-item-label">邮编:</span>
                            <span class="mobile-item-value">{{
                                user.zip
                            }}</span>
                        </div>
                    </div>
                    <div class="mobile-card-actions">
                        <el-button
                            size="small"
                            type="primary"
                            @click="handleEdit(user)"
                            >编辑</el-button
                        >
                        <el-button
                            size="small"
                            type="danger"
                            @click="handleDelete(user)"
                            >删除</el-button
                        >
                    </div>
                </div>
            </div>

            <div class="pagination-container">
                <span class="pagination-info"
                    >共 {{ total }} 条，每页 {{ pageSize }}/页</span
                >
                <el-pagination
                    :current-page="currentPage"
                    :page-size="pageSize"
                    :page-sizes="[5, 10, 20, 50]"
                    layout="prev, pager, next, jumper, sizes"
                    :total="total"
                    @size-change="handleSizeChange"
                    @current-change="handleCurrentChange"
                    @update:current-page="currentPage = $event"
                    @update:page-size="pageSize = $event"
                />
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted, computed, onUnmounted, reactive } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus } from '@element-plus/icons-vue'
import axios from 'axios'
const isEditMode = ref(false)
const currentContactId = ref(null)

// 修改handleEdit方法
const handleEdit = async row => {
    try {
        // 获取联系人详情
        const response = await axios.get(`/api/contacts/${row.id}`)
        const contact = response.data

        // 加载省份
        await loadProvinces()

        // 填充表单
        addForm.name = contact.name
        addForm.provinceId = contact.provinceId
        addForm.cityId = contact.cityId
        addForm.address = contact.address
        addForm.zip = contact.zip

        // 加载对应城市
        if (contact.provinceId) {
            await handleProvinceChange(contact.provinceId)
        }

        // 设置编辑模式
        currentContactId.value = contact.id
        isEditMode.value = true
        addDialogVisible.value = true
    } catch (error) {
        ElMessage.error('获取联系人详情失败')
    }
}

// 新增相关状态
const addDialogVisible = ref(false)
const addFormRef = ref(null)
const provinces = ref([])
const cities = ref([])

const addForm = reactive({
    name: '',
    provinceId: null,
    cityId: null,
    address: '',
    zip: ''
})

const formRules = {
    name: [{ required: true, message: '请输入姓名', trigger: 'blur' }],
    provinceId: [{ required: true, message: '请选择省份', trigger: 'change' }],
    cityId: [{ required: true, message: '请选择城市', trigger: 'change' }],
    address: [{ required: true, message: '请输入详细地址', trigger: 'blur' }],
    zip: [
        { required: true, message: '请输入邮编', trigger: 'blur' },
        { pattern: /^\d{6}$/, message: '邮编必须为6位数字', trigger: 'blur' }
    ]
}

// 修改handleAdd方法
const handleAdd = () => {
    loadProvinces()
    addDialogVisible.value = true
}

// 加载省份数据
const loadProvinces = async () => {
    try {
        const response = await axios.get('/api/regions/provinces')
        provinces.value = response.data
    } catch (error) {
        ElMessage.error('加载省份数据失败')
    }
}

// 省份变化时加载城市
const handleProvinceChange = async provinceId => {
    try {
        const response = await axios.get(
            `/api/regions/cities?provinceId=${provinceId}`
        )
        cities.value = response.data
        addForm.cityId = null // 重置城市选择
    } catch (error) {
        ElMessage.error('加载城市数据失败')
    }
}

// 提交表单
// 修改提交方法
const submitAddForm = async () => {
    try {
        await addFormRef.value.validate()

        const formData = {
            ...addForm,
            provinceId: addForm.provinceId,
            cityId: addForm.cityId
        }

        if (isEditMode.value) {
            await axios.put(`/api/contacts/${currentContactId.value}`, formData)
            ElMessage.success('更新成功')
        } else {
            await axios.post('/api/contacts', formData)
            ElMessage.success('新增成功')
        }

        addDialogVisible.value = false
        loadUserData()
    } catch (error) {
        if (!error.response) {
            ElMessage.error('表单验证失败，请检查输入')
        }
    }
}

// 修改重置方法
const resetForm = () => {
    addFormRef.value?.resetFields()
    cities.value = []
    isEditMode.value = false
    currentContactId.value = null
}
// 模拟数据

// 状态变量
const userData = ref([])
const currentPage = ref(1)
const pageSize = ref(5)
const total = ref(0)
const searchQuery = ref('')
const isMobileView = ref(false)
let resizeObserver = null

// 修改loadUserData方法，适配MyBatis-Plus的分页参数（page从1开始）
const loadUserData = async () => {
    try {
        const response = await axios.get('/api/contacts', {
            params: {
                page: currentPage.value, // 直接传递当前页（从1开始）
                size: pageSize.value,
                search: searchQuery.value
            }
        })
        userData.value = response.data.records // MyBatis-Plus返回的列表字段是records
        total.value = response.data.total // 总记录数
    } catch (error) {
        ElMessage.error('加载用户数据失败，请重试')
        console.error('API请求错误:', error.response || error)
    }
}
// 防抖函数
function debounce(fn, delay) {
    let timer = null
    return function () {
        const context = this
        const args = arguments
        clearTimeout(timer)
        timer = setTimeout(function () {
            fn.apply(context, args)
        }, delay)
    }
}

// 响应式检测屏幕宽度 (使用防抖)
const checkScreenSize = debounce(() => {
    isMobileView.value = window.innerWidth < 1200
}, 50)

// 添加事件监听器
onMounted(() => {
    loadUserData()

    // 初始化视图模式
    isMobileView.value = window.innerWidth < 1200

    // 使用 RAF 方式优化 ResizeObserver
    if (typeof window !== 'undefined') {
        let rafId = null
        const handleResize = () => {
            if (rafId) {
                cancelAnimationFrame(rafId)
            }
            rafId = requestAnimationFrame(() => {
                checkScreenSize()
                rafId = null
            })
        }

        window.addEventListener('resize', handleResize)

        // 使用 onUnmounted 代替 return 闭包函数
        onUnmounted(() => {
            window.removeEventListener('resize', handleResize)
            if (rafId) {
                cancelAnimationFrame(rafId)
            }
        })
    }
})

// 设置表格样式，根据当前主题
const headerCellStyle = computed(() => {
    return {
        backgroundColor: 'var(--nav-active)',
        color: 'var(--text-primary)',
        fontWeight: 'bold',
        borderColor: 'var(--border-color)'
    }
})

const cellStyle = computed(() => {
    return {
        backgroundColor: 'var(--card-bg)',
        color: 'var(--text-primary)',
        borderColor: 'var(--border-color)'
    }
})

const handleDelete = row => {
    ElMessageBox.confirm(`确定要删除用户 ${row.name} 吗？`, '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
    })
        .then(async () => {
            try {
                await axios.delete('/api/contacts?id=' + row.id)
                ElMessage.success('删除成功')
                loadUserData() // 删除成功后刷新列表
            } catch (error) {
                ElMessage.error('删除失败')
                console.error('删除请求失败:', error)
            }
        })
        .catch(() => {
            ElMessage.info('已取消删除')
        })
}

const handleSearch = () => {
    currentPage.value = 1 // 重置到第一页
    loadUserData()
}

const handleSizeChange = val => {
    pageSize.value = val
    loadUserData()
}

const handleCurrentChange = val => {
    currentPage.value = val
    loadUserData()
}
</script>

<style scoped>
.user-management-container {
    background-color: var(--card-bg);
    /* border-radius: 8px; */
    padding: 20px;
    /* box-shadow: var(--box-shadow); */
    width: 80%;
    min-height: 100vh;
    margin: 0 auto;
    margin-top: 60px;
    overflow-x: auto;
    transition: all 0.3s ease-in-out; /* 添加布局过渡效果 */
    will-change: transform, width, height; /* 提示浏览器优化属性变化 */
    transform: translateZ(0); /* 强制硬件加速 */
}

.user-management-header {
    margin-bottom: 20px;
    text-align: center;
}

.section-title {
    font-size: 20px;
    font-weight: 600;
    color: var(--section-title-color);
    margin-bottom: 16px;
    text-align: left;
    padding-left: 4px;
    border-left: 4px solid var(--section-title-border);
    padding-left: 12px;
    transition: color 0.3s ease, border-left 0.3s ease;
}

.table-operations {
    display: flex;
    justify-content: space-between;
    margin-bottom: 20px;
    align-items: center;
}

.search-box {
    display: flex;
    align-items: center;
    gap: 10px;
}

.desktop-table-container {
    width: 100%;
    overflow-x: auto; /* 允许在桌面视图中水平滚动 */
}

.pagination-container {
    margin-top: 20px;
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.pagination-info {
    color: var(--text-secondary);
    font-size: 14px;
}

/* 移动视图样式 */
.mobile-table-view {
    display: flex;
    flex-direction: column;
    gap: 15px;
    width: 100%;
}

.mobile-card {
    background-color: var(--card-bg);
    border-radius: 8px;
    border: 1px solid var(--border-color);
    overflow: hidden;
}

.mobile-card-header {
    display: flex;
    align-items: center;
    padding: 10px;
    background-color: var(--nav-active);
    color: var(--text-primary);
}

.mobile-card-index {
    background-color: var(--primary-color, #409eff);
    color: white;
    border-radius: 50%;
    width: 24px;
    height: 24px;
    display: flex;
    align-items: center;
    justify-content: center;
    margin-right: 10px;
    font-size: 12px;
}

.mobile-card-name {
    font-weight: bold;
    flex-grow: 1;
}

.mobile-card-content {
    padding: 10px;
}

.mobile-card-item {
    display: flex;
    margin-bottom: 8px;
    align-items: baseline;
}

.mobile-item-label {
    min-width: 60px;
    font-weight: 500;
    color: var(--text-secondary);
}

.mobile-item-value {
    color: var(--text-primary);
    word-break: break-word;
}

.mobile-card-actions {
    display: flex;
    justify-content: flex-end;
    padding: 10px;
    gap: 10px;
    border-top: 1px solid var(--border-color);
}

:deep(.el-input__wrapper),
:deep(.el-select__wrapper) {
    background-color: var(--card-bg);
}

:deep(.el-input__inner),
:deep(.el-select__placeholder span) {
    color: var(--text-primary) !important;
}

/* 锁定操作按钮的父容器 */
:deep(.el-table__body-wrapper tr td:last-child .cell) {
    min-width: 120px !important;
    max-width: 120px !important;
}

/* 操作按钮固定尺寸 */
:deep(.el-table__row .el-button--small) {
    width: 40px;
    flex-shrink: 0; /* 禁止内容变化缩小 */
    /* margin-right: 20px; */
}

/* 隐藏可能的弹出层影响 */
:deep(.el-tooltip__popper) {
    display: none !important;
}

/* 适配深色模式的额外样式 */
/* Add these styles to your <style scoped> section */

/* Table outer borders */
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

:deep(.el-dialog) {
    background-color: var(--card-bg) !important;
}

:deep(.el-dialog__title),
:deep(.el-form-item__label) {
    color: var(--text-primary);
}

/* 响应式样式 */
@media (max-width: 800px) {
    .user-management-container {
        padding: 15px;
        margin: 0 auto;
        margin-top: 60px;
        width: 90vw;
    }

    .table-operations {
        flex-direction: column;
        align-items: stretch;
        gap: 10px;
    }

    .search-box {
        width: 100%;
    }

    .search-box .el-input {
        flex-grow: 1;
    }

    .pagination-container {
        flex-direction: column;
        gap: 10px;
    }

    .pagination-info {
        text-align: center;
    }

    :deep(.el-pagination) {
        width: 100%;
        justify-content: center;
    }

    :deep(.el-button) {
        height: 30px;
        font-size: 14px;
    }

    .section-title {
        text-align: center;
        border: none;
    }
}
</style>
