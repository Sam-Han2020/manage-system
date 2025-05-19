<template>
    <div class="author-management-container">
        <div class="content-wrapper">
            <div class="content-section left-container">
                <h2 class="section-title">作者列表</h2>
                <div class="table-container">
                    <el-table
                        :data="authorData"
                        border
                        row-class-name="theme-table-row"
                        stripe
                        highlight-current-row
                    >
                        <el-table-column
                            type="index"
                            label="序号"
                            width="70"
                            align="center"
                        />
                        <el-table-column
                            prop="name"
                            label="作者姓名"
                            min-width="180"
                        />
                        <el-table-column
                            prop="articleCount"
                            label="文章数量"
                            width="100"
                            align="center"
                        />
                        <el-table-column
                            label="操作"
                            width="100"
                            align="center"
                        >
                            <template #default="scope">
                                <el-button
                                    type="primary"
                                    size="small"
                                    @click="handleEnterArticle(scope.row)"
                                >
                                    进入
                                </el-button>
                            </template>
                        </el-table-column>
                    </el-table>
                </div>
                <div class="pagination-container">
                    <el-pagination
                        v-model:current-page="currentPage"
                        v-model:page-size="pageSize"
                        :page-sizes="[5, 10, 20, 50]"
                        :total="total"
                        @size-change="handleSizeChange"
                        @current-change="handleCurrentChange"
                        layout="total, sizes, prev, pager, next, jumper"
                        background
                    />
                </div>
            </div>
            <div class="content-section right-container">
                <h2 class="section-title">作者发布文章统计图表</h2>
                <div
                    id="chart-container"
                    ref="chartContainer"
                    class="chart-container"
                />
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted, watch, onUnmounted, nextTick } from 'vue'
import axios from 'axios'
import { ElMessage } from 'element-plus'
import * as echarts from 'echarts'
import { useRouter } from 'vue-router'
const router = useRouter()

const authorData = ref([])
const currentPage = ref(1)
const pageSize = ref(5)
const total = ref(0)
const chartInstance = ref(null)
const chartContainer = ref(null)

const fetchAuthorData = async () => {
    try {
        const response = await axios.get('/api/authorts', {
            params: { page: currentPage.value - 1, size: pageSize.value }
        })
        authorData.value = response.data.records
        total.value = response.data.total
        nextTick(() => {
            updateChart()
        })
    } catch (error) {
        ElMessage.error('获取作者数据失败')
    }
}

const updateChart = () => {
    if (!chartContainer.value) return

    // Destroy previous chart instance if exists
    if (chartInstance.value) {
        chartInstance.value.dispose()
    }

    // Initialize chart
    chartInstance.value = echarts.init(chartContainer.value)

    const option = {
        title: { text: '用户发表文章统计' },
        tooltip: {
            trigger: 'axis',
            axisPointer: { type: 'shadow' }
        },
        grid: {
            left: '3%',
            right: '4%',
            bottom: '3%',
            containLabel: true
        },
        xAxis: {
            data: authorData.value.map(item => item.name),
            axisLabel: {
                interval: 0,
                rotate: authorData.value.length > 5 ? 30 : 0,
                textStyle: {
                    color: getComputedStyle(document.documentElement)
                        .getPropertyValue('--text-primary')
                        .trim()
                }
            }
        },
        yAxis: {
            type: 'value',
            axisLabel: {
                formatter: '{value} 篇',
                textStyle: {
                    color: getComputedStyle(document.documentElement)
                        .getPropertyValue('--text-primary')
                        .trim()
                }
            }
        },
        series: [
            {
                type: 'bar',
                data: authorData.value.map(item => item.articleCount),
                itemStyle: {
                    color: getComputedStyle(document.documentElement)
                        .getPropertyValue('--primary-color')
                        .trim()
                }
            }
        ]
    }

    chartInstance.value.setOption(option)
}

const handleWindowResize = () => {
    if (chartInstance.value) {
        chartInstance.value.resize()
    }
}

watch(authorData, () => {
    nextTick(() => {
        updateChart()
    })
})

onMounted(() => {
    fetchAuthorData()
    window.addEventListener('resize', handleWindowResize)
})

onUnmounted(() => {
    window.removeEventListener('resize', handleWindowResize)
    if (chartInstance.value) {
        chartInstance.value.dispose()
    }
})

const handleSizeChange = val => {
    pageSize.value = val
    currentPage.value = 1
    fetchAuthorData()
}

const handleCurrentChange = val => {
    currentPage.value = val
    fetchAuthorData()
}

const handleEnterArticle = author => {
    router.push({
        name: 'AuthorArticleManage',
        params: { author: JSON.stringify(author) }
    })
    localStorage.setItem('authorName', author.name)
}
</script>

<style scoped>
.author-management-container {
    max-width: 1200px;
    margin: 0 auto;
    margin-top: 60px;
    padding: 20px;
    background-color: var(--home-bg);
    min-height: calc(100vh - 60px);
    border-radius: 12px;
    overflow: auto; /* 确保内容可滚动 */
}

.content-wrapper {
    display: flex;
    flex-direction: column;
    gap: 24px;
}

.content-section {
    background: var(--card-bg);
    padding: 24px;
    border-radius: 12px;
    box-shadow: var(--box-shadow);
    border: 1px solid var(--border-color);
    width: 100%;
    transition: all 0.3s ease;
}

.chart-container {
    width: 100%;
    height: 360px;
    margin-top: 16px;
    border-radius: 8px;
    overflow: hidden;
}

.section-title {
    text-align: left;
    margin-bottom: 24px;
    color: var(--section-title-color);
    font-size: 22px;
    font-weight: 600;
    border-left: 4px solid var(--section-title-border);
    padding-left: 12px;
}

.pagination-container {
    margin-top: 24px;
    text-align: center;
    overflow-x: auto;
    padding: 8px 0;
}

.table-container {
    border-radius: 8px;
    overflow: hidden !important;
}

.chart-options {
    display: flex;
    width: 100%;
    height: -500px;
    justify-content: flex-end;
    margin-bottom: 16px;
}

.left-container {
    max-width: 600px;
    overflow: hidden;
}

.right-container {
    max-width: 600px;
    overflow: hidden;
}

.content-wrapper {
    align-content: center;
    overflow: hidden;
}

:deep(.el-table__cell .cell) {
    align-items: center;
}

/* Responsive styles */
/* Mobile Specific Styles */
@media (max-width: 768px) {
    :deep(.el-table) {
        width: 100%;
        overflow-x: auto;
        font-size: 12px;
        max-width: 80vw;
    }

    :deep(.el-table td, .el-table th) {
        padding: 6px 4px !important;
    }

    :deep(.el-button--small) {
        /* padding: 4px 8px; */
        font-size: 12px;
    }

    :deep(.el-pagination) {
        padding: 5px 0;
        font-size: 12px;
    }

    :deep(.el-pagination__sizes) {
        display: none;
    }

    :deep(.el-pagination__jump) {
        display: none;
    }

    .chart-container {
        height: 360px;
        width: 100%;
    }

    .section-title {
        font-size: 16px;
    }

    .table-container {
        width: 100%;
        overflow-x: auto;
    }

    :deep(.el-table__cell .cell) {
        /* padding: 6px 4px; */
        padding: 0 !important;
    }

    :deep(.el-table__empty-block) {
        padding: 10px;
    }
}

@media (min-width: 992px) {
    .content-wrapper {
        flex-direction: row;
        gap: 30px;
        margin-bottom: 250px;
    }

    .content-section {
        padding: 28px;
        transition: transform 0.3s ease, box-shadow 0.3s ease;
    }

    .content-section:hover {
        transform: translateY(-2px);
        box-shadow: var(--box-shadow);
    }

    .left-container {
        flex: 1;
    }

    .right-container {
        flex: 1;
    }

    .chart-container {
        height: 320px;
    }

    .section-title {
        font-size: 24px;
    }
}

/* Table responsive styles */
:deep(.el-table) {
    width: 100%;
    overflow-x: auto;
    --el-table-bg-color: var(--card-bg);
    --el-table-header-bg-color: var(--nav-active);
    --el-table-border-color: var(--border-color);
    --el-table-cell-border-color: var(--border-color);
    border-radius: 8px;
}

@media (max-width: 768px) {
    :deep(.el-table td, .el-table th) {
        padding: 8px 6px !important;
    }

    :deep(.el-table-column--min-width) {
        width: auto !important;
    }

    :deep(.el-button--small) {
        /* padding: 6px 12px; */
        font-size: 12px;
    }

    :deep(.el-pagination) {
        padding: 10px 0;
    }

    :deep(.el-pagination__sizes) {
        margin-right: 10px;
    }

    :deep(.el-pagination__jump) {
        margin-left: 10px;
    }

    .table-container {
        width: 100%;
        overflow-x: auto;
    }

    :deep(.el-pagination) {
        justify-content: center;
        flex-wrap: wrap;
    }
}

/* Table theme adaptation */
:deep(.el-table--border) {
    border-color: var(--border-color);
    border-radius: 8px;
    overflow: hidden;
}

:deep(.el-table__header-wrapper) {
    background-color: var(--nav-active);
}

:deep(.el-table__header th) {
    color: var(--text-primary);
    border-bottom-color: var(--border-color);
    font-weight: 600;
    padding: 14px 12px;
}

:deep(.theme-table-row) {
    background-color: var(--card-bg) !important;
    transition: background-color 0.2s ease;
}

:deep(.el-table__body tr) {
    background-color: var(--card-bg) !important;
}

:deep(.el-table__body tr:hover) {
    background-color: var(--nav-hover) !important;
}

:deep(.el-table td, .el-table th) {
    padding: 12px 16px;
    color: var(--text-primary);
    border-bottom: 1px solid var(--border-color);
}

:deep(.el-table__cell) {
    border-right: 1px solid var(--border-color);
}

:deep(.el-table__empty-block) {
    color: var(--text-tertiary);
    padding: 20px;
}

/* Pagination component theme adaptation */
:deep(.el-pagination) {
    --el-pagination-item-bg-color: var(--card-bg);
    --el-pagination-item-active-bg-color: var(--calendar-selected-bg);
    --el-pagination-item-active-text-color: white;
    --el-pagination-item-hover-bg-color: var(--nav-hover);
    --el-pagination-text-color: var(--text-primary);
    --el-pagination-item-disabled-bg-color: var(--card-bg);
    --el-pagination-item-disabled-text-color: var(--text-tertiary);
    --el-pagination-border-color: var(--border-color);
    display: flex;
    justify-content: center;
}

:deep(
        .el-pagination__sizes,
        .el-pagination__control,
        .el-pagination__btn-group button,
        .el-pagination__jump-label
    ) {
    border-color: var(--border-color) !important;
}

:deep(
        .el-pagination__item,
        .el-pagination__sizes,
        .el-pagination__control,
        .el-pagination__btn-group button,
        .el-pagination__jump-label
    ) {
    background-color: var(--card-bg) !important;
    color: var(--text-primary) !important;
}

:deep(
        .el-pagination__item:hover,
        .el-pagination__sizes:hover,
        .el-pagination__control:hover,
        .el-pagination__btn-group button:hover
    ) {
    background-color: var(--nav-hover) !important;
    border-color: var(--nav-hover) !important;
}

:deep(
        .el-pagination__item.is-active,
        .el-pagination__sizes.is-active,
        .el-pagination__control.is-active,
        .el-pagination__btn-group button.is-active
    ) {
    background-color: var(--calendar-selected-bg) !important;
    color: white !important;
    border-color: var(--calendar-selected-bg) !important;
}

:deep(
        .el-pagination__item.is-disabled,
        .el-pagination__sizes.is-disabled,
        .el-pagination__control.is-disabled,
        .el-pagination__btn-group button.is-disabled
    ) {
    background-color: var(--card-bg) !important;
    color: var(--text-tertiary) !important;
    border-color: var(--border-color) !important;
}

/* Dark theme special handling */
[data-theme='dark'] :deep(.el-table__header th) {
    color: var(--text-primary);
    background-color: var(--nav-active);
}

[data-theme='dark'] :deep(.theme-table-row) {
    background-color: var(--card-bg) !important;
}

[data-theme='dark'] :deep(.el-table__body tr:hover) {
    background-color: var(--nav-active) !important;
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
    overflow: hidden;
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
</style>
