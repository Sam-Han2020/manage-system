<template>
    <div class="responsive-layout" :class="{ 'mobile-layout': isMobileView }">
        <!-- Daily Card Section -->
        <div class="section-container">
            <h2 class="section-title">欢迎{{ user.name }}！</h2>
            <div class="daily-card">
                <div class="card-image">
                    <img src="/images/bgi.jpg" alt="Daily inspiration" />
                </div>
                <div class="card-content">
                    <p class="quote-text">
                        年轻人，<br />
                        你的职责是平整土地，而非焦虑时光。<br />
                        你做三四月的事，在八九月自有答案。
                    </p>
                    <p class="quote-author">——余世存</p>
                </div>
                <div class="card-footer">
                    <div class="service-info">@samhan</div>
                    <div class="date-box">
                        <div class="date">
                            {{ currentDay }}/{{ daysInMonth }}
                        </div>
                        <div class="day">{{ dayOfWeek }}.</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Calendar Section -->
        <div class="section-container">
            <div class="big-box">
                <h2 class="section-title">日历</h2>
                <div class="calendar-container">
                    <div class="calendar-header">
                        <div class="year-month">
                            {{ year }} 年 {{ month }} 月
                        </div>
                        <div class="nav-buttons">
                            <button @click="previousMonth">上个月</button>
                            <button @click="currentMonth">今天</button>
                            <button @click="nextMonth">下个月</button>
                        </div>
                    </div>

                    <div class="calendar-body">
                        <div class="weekdays">
                            <div class="weekday">一</div>
                            <div class="weekday">二</div>
                            <div class="weekday">三</div>
                            <div class="weekday">四</div>
                            <div class="weekday">五</div>
                            <div class="weekday">六</div>
                            <div class="weekday">日</div>
                        </div>

                        <div class="days">
                            <div
                                v-for="day in calendarDays"
                                :key="day.date"
                                :class="[
                                    'day',
                                    { 'current-month': day.currentMonth },
                                    { 'other-month': !day.currentMonth },
                                    { today: day.isToday },
                                    { selected: isSelected(day.date) }
                                ]"
                                @click="selectDate(day.date)"
                            >
                                {{ day.dayNumber }}
                            </div>
                        </div>
                    </div>
                </div>
                <h2>&nbsp;</h2>
                <h2 class="section-title">视频推送</h2>
                <div class="video-container">
                    <iframe
                        src="//player.bilibili.com/player.html?isOutside=true&aid=114164760643852&bvid=BV1xYQmY7EKL&cid=28873263109&p=1"
                        scrolling="no"
                        border="0"
                        frameborder="no"
                        framespacing="0"
                        allowfullscreen="true"
                    ></iframe>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { themeEventBus } from '@/utils/themeEvent'
import axios from 'axios' // Add this import
import { ElMessage } from 'element-plus' // Add this import if you're using Element Plus

export default {
    name: 'CalendarWithDailyCard',

    setup() {
        const currentDate = ref(new Date())
        const displayDate = ref(new Date())
        const selectedDate = ref(null)
        const isMobileView = ref(false)

        // Move the user ref inside setup
        const user = ref({
            username: '',
            email: '',
            balance: null,
            birthday: null,
            avatar: null
        })

        const isLoading = ref(true)

        // Include fetchUserInfo inside setup
        const fetchUserInfo = async () => {
            try {
                // Get username from localStorage
                const username = localStorage.getItem('name')
                if (!username) {
                    ElMessage.warning('Username not found in local storage')
                    console.warn('Username not found in local storage')
                    return
                }

                const response = await axios.get(
                    `/api/users/profile?username=${encodeURIComponent(
                        username
                    )}`
                )

                // Check if response contains data
                if (response.data) {
                    user.value = response.data
                    console.log('User data loaded:', user.value)
                } else {
                    ElMessage.warning('No user data received from server')
                    console.warn('Empty response data')
                }
            } catch (error) {
                ElMessage.error(
                    'Failed to get user information, please try again'
                )
                console.error('API request error:', error)
            } finally {
                isLoading.value = false
            }
        }

        const year = computed(() => displayDate.value.getFullYear())
        const month = computed(() => displayDate.value.getMonth() + 1)
        const currentDay = computed(() => currentDate.value.getDate())

        const daysInMonth = computed(() => {
            return new Date(
                currentDate.value.getFullYear(),
                currentDate.value.getMonth() + 1,
                0
            ).getDate()
        })

        const dayOfWeek = computed(() => {
            const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
            return days[currentDate.value.getDay()]
        })

        const checkScreenSize = () => {
            isMobileView.value = window.innerWidth < 1200
        }

        const calendarDays = computed(() => {
            const days = []

            // First day of displayed month
            const firstDayOfMonth = new Date(year.value, month.value - 1, 1)

            // Last day of displayed month
            const lastDayOfMonth = new Date(year.value, month.value, 0)

            // Get day of week of first day (0 = Sunday, 1 = Monday, etc)
            let firstWeekday = firstDayOfMonth.getDay()
            // Adjust for starting on Monday
            firstWeekday = firstWeekday === 0 ? 6 : firstWeekday - 1

            // Get the days from previous month to show
            const daysFromPrevMonth = firstWeekday
            const prevMonth = new Date(year.value, month.value - 2, 1)
            const daysInPrevMonth = new Date(
                year.value,
                month.value - 1,
                0
            ).getDate()

            // Add days from previous month
            for (
                let i = daysInPrevMonth - daysFromPrevMonth + 1;
                i <= daysInPrevMonth;
                i++
            ) {
                const date = new Date(
                    prevMonth.getFullYear(),
                    prevMonth.getMonth(),
                    i
                )
                days.push({
                    date: date,
                    dayNumber: i,
                    currentMonth: false,
                    isToday: isSameDay(date, currentDate.value)
                })
            }

            // Add days from current month
            for (let i = 1; i <= lastDayOfMonth.getDate(); i++) {
                const date = new Date(year.value, month.value - 1, i)
                days.push({
                    date: date,
                    dayNumber: i,
                    currentMonth: true,
                    isToday: isSameDay(date, currentDate.value)
                })
            }

            // Calculate how many days from next month we need to show
            const totalDaysToShow = 42 // 6 rows of 7 days
            const daysFromNextMonth = totalDaysToShow - days.length

            // Add days from next month
            for (let i = 1; i <= daysFromNextMonth; i++) {
                const date = new Date(year.value, month.value, i)
                days.push({
                    date: date,
                    dayNumber: i,
                    currentMonth: false,
                    isToday: isSameDay(date, currentDate.value)
                })
            }

            return days
        })

        // Utility function to check if two dates are the same day
        const isSameDay = (date1, date2) => {
            return (
                date1.getFullYear() === date2.getFullYear() &&
                date1.getMonth() === date2.getMonth() &&
                date1.getDate() === date2.getDate()
            )
        }

        // Navigation functions
        const previousMonth = () => {
            displayDate.value = new Date(year.value, month.value - 2, 1)
        }

        const nextMonth = () => {
            displayDate.value = new Date(year.value, month.value, 1)
        }

        const currentMonth = () => {
            displayDate.value = new Date()
        }

        // Date selection
        const selectDate = date => {
            selectedDate.value = date
        }

        const isSelected = date => {
            if (!selectedDate.value) return false
            return isSameDay(date, selectedDate.value)
        }

        // Add theme listener
        const applyThemeToHomePage = () => {
            // This function will be called when theme changes
            // Any specific DOM manipulations for the home page can be done here
            // The CSS variables will handle most styling automatically
        }

        onMounted(() => {
            fetchUserInfo()
            // Initialize with current date
            displayDate.value = new Date()

            // Check initial screen size
            checkScreenSize()

            // Add event listener for window resize
            window.addEventListener('resize', checkScreenSize)
            // Listen for theme changes
            themeEventBus.on('themeChanged', applyThemeToHomePage)

            // Apply current theme from localStorage
            const currentTheme = localStorage.getItem('theme') || 'light'
            if (currentTheme === 'dark') {
                applyThemeToHomePage('dark')
            }
        })

        onUnmounted(() => {
            // Remove event listener when component is unmounted
            window.removeEventListener('resize', checkScreenSize)
            // Remove event listener
            themeEventBus.off('themeChanged', applyThemeToHomePage)
        })

        return {
            year,
            month,
            calendarDays,
            previousMonth,
            nextMonth,
            currentMonth,
            selectDate,
            isSelected,
            currentDay,
            daysInMonth,
            dayOfWeek,
            isMobileView,
            user, // Add this
            isLoading // Add this
        }
    }
}
</script>

<style scoped>
.responsive-layout {
    display: flex;
    width: 100%;
    gap: 24px;
    margin: 0 auto;
    padding: 16px;
    max-width: 1200px;
    justify-content: center;
    margin-top: 60px;
    background-color: var(--home-bg);
    background-size: cover;
    background-position: center;
    background-attachment: fixed;
    min-height: 100vh;
    padding: 40px 16px;
    transition: background-color 0.3s ease;
}

.mobile-layout {
    flex-direction: column;
    align-items: center;
    margin-top: 60px;
}

/* Section container for consistent layout */
.section-container {
    display: flex;
    flex-direction: column;
    width: 90%;
}

/* Section title styles */
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

/* Daily Card Styles */
.daily-card {
    width: 100%;
    max-width: 400px;
    background-color: var(--card-bg);
    border: 1px solid var(--border-color);
    border-radius: 8px;
    overflow: hidden;
    box-shadow: var(--box-shadow);
    display: flex;
    flex-direction: column;
    margin-bottom: 16px;
    flex-shrink: 0;
    transition: background-color 0.3s ease, border 0.3s ease,
        box-shadow 0.3s ease;
}

.mobile-layout .daily-card {
    max-width: 400px; /* Slightly wider on mobile */
    width: 100%;
}

.card-image {
    width: 100%;
    position: relative;
    padding-bottom: 100%; /* 1:1 Aspect Ratio */
    overflow: hidden;
    background-color: #f5f5f5;
}

.card-image img {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    object-fit: cover;
    border-bottom: 1px solid var(--border-color);
    transition: border-bottom 0.3s ease;
}

.card-content {
    padding: 24px;
    flex-grow: 1;
    display: flex;
    flex-direction: column;
    justify-content: center;
}

.quote-text {
    font-size: 16px;
    line-height: 1.8;
    color: var(--text-primary);
    text-align: center;
    margin-bottom: 16px;
    transition: color 0.3s ease;
}

.quote-author {
    font-size: 14px;
    color: var(--text-secondary);
    text-align: center;
    transition: color 0.3s ease;
}

.card-footer {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 12px 16px;
    border-top: 1px solid var(--border-color);
    transition: border-top 0.3s ease;
}

.service-info {
    font-size: 12px;
    color: var(--text-tertiary);
    transition: color 0.3s ease;
}

.date-box {
    text-align: right;
    padding: 8px;
    border: 1px solid var(--border-color);
    transition: border 0.3s ease;
}

.date {
    font-size: 16px;
    color: var(--text-primary);
    font-weight: bold;
    transition: color 0.3s ease;
}

.day {
    font-size: 14px;
    color: var(--text-secondary);
    transition: color 0.3s ease;
}

/* Calendar Styles */
.big-box {
    width: 100%;
    max-width: 600px; /* Set a max-width for calendar */
    height: auto;
    display: flex;
    flex-direction: column;
    /* margin-top: 100px; */
    margin-bottom: 200px;
}

.calendar-container {
    width: 100%;
    border: 1px solid var(--border-color);
    border-radius: 4px;
    overflow: hidden;
    background-color: var(--card-bg);
    box-shadow: var(--box-shadow);
    display: flex;
    flex-direction: column;
    transition: background-color 0.3s ease, border 0.3s ease,
        box-shadow 0.3s ease;
}

.calendar-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 12px 16px;
    border-bottom: 1px solid var(--border-color);
    transition: border-bottom 0.3s ease;
}

.year-month {
    font-weight: bold;
    font-size: 18px;
    color: var(--text-primary);
    transition: color 0.3s ease;
}

.nav-buttons {
    display: flex;
    gap: 8px;
}

.nav-buttons button {
    padding: 4px 12px;
    background-color: transparent;
    border: 1px solid var(--border-color);
    border-radius: 4px;
    cursor: pointer;
    transition: all 0.2s;
    color: var(--text-primary);
}

.nav-buttons button:hover {
    background-color: var(--button-hover);
}

.calendar-body {
    display: flex;
    flex-direction: column;
    flex: 1;
}

.weekdays {
    display: grid;
    grid-template-columns: repeat(7, 1fr);
    text-align: center;
    border-bottom: 1px solid var(--border-color);
    transition: border-bottom 0.3s ease;
}

.weekday {
    padding: 12px 0;
    font-weight: bold;
    color: var(--text-primary);
    transition: color 0.3s ease;
}

.days {
    display: grid;
    grid-template-columns: repeat(7, 1fr);
    flex: 1;
}

.day {
    height: 50px;
    display: flex;
    justify-content: center;
    align-items: center;
    cursor: pointer;
    border-right: 1px solid var(--border-color);
    border-bottom: 1px solid var(--border-color);
    transition: all 0.2s, border-right 0.3s ease, border-bottom 0.3s ease;
}

.day:hover {
    background-color: var(--calendar-hover);
}

.other-month {
    color: var(--text-tertiary);
    transition: color 0.3s ease;
}

.today {
    background-color: var(--calendar-today-bg);
    font-weight: bold;
    color: var(--calendar-today-color);
    transition: background-color 0.3s ease, color 0.3s ease;
}

.selected {
    background-color: var(--calendar-selected-bg);
    color: white;
    font-weight: bold;
    transition: background-color 0.3s ease;
}

/* 视频容器样式 */
.video-container {
    position: relative;
    width: 100%;
    height: 0;
    padding-bottom: 56.25%;
    border-radius: 8px;
    overflow: hidden;
    box-shadow: var(--box-shadow);
    transition: box-shadow 0.3s ease;
}

.video-container iframe {
    position: absolute;
    top: 0;
    left: 0;
    width: 100%;
    height: 100%;
    border: 1px solid var(--border-color);
    transition: border 0.3s ease;
}

/* Responsive adjustments */
@media (max-width: 800px) {
    .responsive-layout {
        padding: 8px;
    }

    .big-box {
        max-width: 100%;
        width: 100%;
    }

    .daily-card {
        margin: 0 auto 16px;
    }

    .mobile-layout .section-container {
        align-items: center;
    }

    .mobile-layout .section-title {
        width: 100%;
        max-width: 400px;
    }

    .video-container {
        padding-bottom: 70%; /* 移动端更多高度 */
        /* margin-top: 20px; */
    }
}

@media (max-width: 480px) {
    .calendar-header {
        flex-direction: column;
        gap: 8px;
    }

    .day {
        height: 40px;
    }
}
</style>
