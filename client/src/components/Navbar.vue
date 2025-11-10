<template>
  <nav class="glass-effect sticky top-0 z-50 shadow-lg">
    <div class="max-w-[82rem] mx-auto px-8 py-4">
      <div class="flex justify-between items-center">
        <!-- Logo -->
        <div class="flex items-center gap-3">
          <svg class="w-8 h-8 text-blue-400" fill="currentColor" viewBox="0 0 20 20">
            <path
              d="M2 11a1 1 0 011-1h2a1 1 0 011 1v5a1 1 0 01-1 1H3a1 1 0 01-1-1v-5zM8 7a1 1 0 011-1h2a1 1 0 011 1v9a1 1 0 01-1 1H9a1 1 0 01-1-1V7zM14 4a1 1 0 011-1h2a1 1 0 011 1v12a1 1 0 01-1 1h-2a1 1 0 01-1-1V4z"
            />
          </svg>
          <h1 class="gradient-text text-2xl font-bold">Blog Pulse</h1>
        </div>

        <!-- Menu -->
        <div class="flex gap-8 items-center">
          <RouterLink class="nav-link" to="/">Home</RouterLink>
          <RouterLink class="nav-link" to="/blogs">Blogs</RouterLink>
          <RouterLink class="nav-link" to="/analytics">Analytics</RouterLink>
          <RouterLink class="nav-link" to="/create">Create</RouterLink>

          <!-- ✅ Logged-in view -->
          <template v-if="user">
            <span class="text-gray-300 font-medium">Hi, {{ userDisplay }}</span>
            <button
              @click="logout"
              class="text-red-400 hover:text-red-500 font-semibold transition"
            >
              Logout
            </button>
          </template>

          <!-- ✅ Logged-out view -->
          <template v-else>
            <!-- ✅ UPDATED: Changed class from 'nav-link' to 'nav-link-signin' -->
            <RouterLink class="nav-link-signin" to="/signin">Sign In</RouterLink>
            <RouterLink
              to="/signup"
              class="btn-primary text-white px-4 py-2 rounded-lg font-semibold hover:shadow-lg"
            >
              Sign Up
            </RouterLink>
          </template>
        </div>
      </div>
    </div>
  </nav>
</template>

<script setup>
import { computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { currentUser, setUser, loadUserFromStorage } from '../stores/authStore.js'

const router = useRouter()

onMounted(() => {
  loadUserFromStorage()
})

const user = currentUser
const userDisplay = computed(() =>
  user.value?.email?.split('@')[0] || user.value?.username || 'User'
)

function logout() {
  setUser(null)
  localStorage.removeItem('token')
  router.push('/signin')
}
</script>

<style scoped>
/* Style for Home, Blogs, Analytics, Create */
.nav-link {
  @apply text-gray-300 hover:text-blue-400 font-medium transition;
}
/* Active state for Home, Blogs, Analytics, Create */
.nav-link.router-link-exact-active {
  @apply text-blue-400;
}


/* --- ✅ NEW STYLES FOR "Sign In" LINK --- */

/* 1. Default State: Blue, no underline */
.nav-link-signin {
  @apply text-blue-400 font-medium transition;
  text-decoration: none;
}

/* 2. Hover State: Simple underline */
.nav-link-signin:hover {
  text-decoration: underline;
}

/* 3. Active State: Gradient underline (like screenshot) */
.nav-link-signin.router-link-exact-active {
  position: relative;
  text-decoration: none; /* No underline, we use ::after */
}

.nav-link-signin.router-link-exact-active::after {
  content: '';
  position: absolute;
  left: 0;
  right: 0;
  bottom: -5px; /* Adjust vertical position */
  height: 2px;  /* Thickness */
  /* Using your logo's gradient for the underline */
  background: linear-gradient(to right, #6366F1, #EC4899);
}
/* --- END OF NEW STYLES --- */


.glass-effect {
  background-color: rgba(15, 23, 42, 0.8);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  border-bottom: 1px solid rgba(255, 255, 255, 0.1);
}

.gradient-text {
  background: linear-gradient(to right, #6366F1, #EC4899);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

.btn-primary {
  background: linear-gradient(135deg, #3b82f6 0%, #8b5cf6 100%);
  transition: all 0.3s ease;
}

.btn-primary:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 15px rgba(96, 165, 250, 0.3);
}
</style>