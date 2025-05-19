<template>
    <div class="profile-container">
        <div class="profile-header">
            <div class="avatar-container">
                <img
                    :src="user.avatar"
                    alt="User avatar"
                    class="avatar"
                    v-if="user.avatar"
                />
                <div class="avatar-placeholder" v-else>
                    {{ getInitials(user.name || '') }}
                </div>
            </div>
            <h1 class="username">{{ user.name || 'Loading...' }}</h1>
        </div>

        <div class="profile-details">
            <div class="detail-item">
                <div class="detail-label">Email</div>
                <div class="detail-value">
                    {{ user.email || 'Not available' }}
                </div>
            </div>

            <div class="detail-item">
                <div class="detail-label">Balance</div>
                <div class="detail-value">
                    {{ formatCurrency(user.balance) }}
                </div>
            </div>

            <div class="detail-item">
                <div class="detail-label">Birthday</div>
                <div class="detail-value">{{ formattedBirthday }}</div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import axios from 'axios'
import { ElMessage } from 'element-plus' // For error notifications

const user = ref({
    username: '',
    email: '',
    balance: null,
    birthday: null,
    avatar: null
})
const isLoading = ref(true)

// Fetch user information
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
            `/api/users/profile?username=${encodeURIComponent(username)}`
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
        ElMessage.error('Failed to get user information, please try again')
        console.error('API request error:', error)
    } finally {
        isLoading.value = false
    }
}

// Computed property for formatted birthday
const formattedBirthday = computed(() => {
    if (!user.value.birthday) return 'Not provided'

    try {
        // Clean date string (remove duplicate time part)
        const cleanedDateStr = user.value.birthday.replace(/\s00:00:00$/, '')
        const date = new Date(cleanedDateStr)

        // Validate date
        if (isNaN(date.getTime())) {
            throw new Error('Invalid date format')
        }

        return formatDate(date)
    } catch (e) {
        console.error('Date parsing error:', user.value.birthday, e)
        return 'Invalid date' // Fallback for invalid dates
    }
})

// Function to get initials from username
const getInitials = username => {
    if (!username) return ''
    return username
        .split(' ')
        .map(name => name.charAt(0))
        .join('')
        .toUpperCase()
}

// Format currency with locale
const formatCurrency = amount => {
    if (amount === undefined || amount === null) return '$1250.75'
    return new Intl.NumberFormat('en-US', {
        style: 'currency',
        currency: 'USD'
    }).format(amount)
}

// Format date in a readable format
const formatDate = dateInput => {
    if (!dateInput) return 'Not provided'
    const date = new Date(dateInput)
    if (isNaN(date.getTime())) return 'Invalid date'

    return new Intl.DateTimeFormat('en-US', {
        year: 'numeric',
        month: 'long',
        day: 'numeric'
    }).format(date)
}

// Fetch user data on component mount
onMounted(() => {
    fetchUserInfo()
})
</script>

<style scoped>
.profile-container {
    max-width: 800px;
    margin: 0 auto;
    margin-top: 60px;
    height: 100vh;
    padding: 2rem;
    background-color: var(--home-bg);
    border-radius: 8px;
    box-shadow: var(--box-shadow);
    color: var(--text-primary);
}

.profile-header {
    display: flex;
    align-items: center;
    margin-bottom: 2rem;
    padding-bottom: 1rem;
    border-bottom: 1px solid var(--border-color);
}

.avatar-container {
    margin-right: 1.5rem;
}

.avatar {
    width: 100px;
    height: 100px;
    border-radius: 50%;
    object-fit: cover;
    border: 1px solid var(--border-color);
}

.avatar-placeholder {
    width: 100px;
    height: 100px;
    border-radius: 50%;
    background-color: var(--calendar-selected-bg);
    color: white;
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 2rem;
    font-weight: bold;
}

.username {
    font-size: 2rem;
    margin: 0;
    color: var(--text-primary);
}

.profile-details {
    display: flex;
    flex-direction: column;
    gap: 1.5rem;
}

.detail-item {
    display: flex;
    flex-direction: column;
    padding: 1rem;
    background-color: var(--card-bg);
    border-radius: 6px;
    border: 1px solid var(--border-color);
    transition: all 0.2s ease;
}

.detail-item:hover {
    background-color: var(--button-hover);
}

.detail-label {
    font-size: 0.9rem;
    color: var(--text-tertiary);
    margin-bottom: 0.25rem;
}

.detail-value {
    font-size: 1.2rem;
    color: var(--text-secondary);
    font-weight: 500;
}

/* Balance value color special styling */
.detail-item:nth-child(2) .detail-value {
    color: var(--time-display-color);
}

@media (max-width: 600px) {
    .profile-header {
        flex-direction: column;
        text-align: center;
    }

    .avatar-container {
        margin-right: 0;
        margin-bottom: 1rem;
    }
}
</style>
