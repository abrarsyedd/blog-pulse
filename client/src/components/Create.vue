<template>
  <section>
    <!-- Page Title -->
    <h2
      class="page-headline-gradient text-3xl font-bold mb-8"
    >
      Create New Post
    </h2>

    <!-- Form Card -->
    <div class="glass-effect p-10 rounded-lg">
      <form @submit.prevent="createPost">
        <!-- Post Title -->
        <div class="mb-6">
          <label class="block text-sm font-medium mb-2 text-gray-300">Post Title</label>
          <input
            v-model="title"
            type="text"
            placeholder="Enter your post title"
            class="form-input w-full px-4 py-3 rounded-lg"
            required
          />
        </div>

        <!-- Author Name -->
        <div class="mb-6">
          <label class="block text-sm font-medium mb-2 text-gray-300">Author Name</label>
          <input
            v-model="author"
            type="text"
            placeholder="Enter author name"
            class="form-input w-full px-4 py-3 rounded-lg"
            required
          />
        </div>

        <!-- Content -->
        <div class="mb-6">
          <label class="block text-sm font-medium mb-2 text-gray-300">Content</label>
          <textarea
            v-model="content"
            rows="10"
            placeholder="Write your post content here..."
            class="form-input w-full px-4 py-3 rounded-lg resize-none"
            required
          ></textarea>
        </div>

        <!-- Publish Button -->
        <button
          type="submit"
          class="btn-primary text-white px-8 py-3 rounded-lg font-semibold w-full hover:shadow-lg transition"
          :disabled="!isAuthenticated || loading"
        >
          {{ loading ? 'Publishing...' : 'Publish Post' }}
        </button>

        <!-- Auth Message -->
        <p
          v-if="!isAuthenticated"
          class="text-center text-sm text-gray-400 mt-4"
        >
          ⚠️ Please
          <RouterLink to="/signin" class="text-blue-400 hover:text-[#8b5cf6] transition">sign in</RouterLink>
          or
          <RouterLink to="/signup" class="text-blue-400 hover:text-[#8b5cf6] transition">sign up</RouterLink>
          to publish a post.
        </p>

        <!-- Feedback Message -->
        <p
          v-if="message"
          class="text-center text-sm mt-6"
          :class="messageType === 'success' ? 'text-green-400' : 'text-red-400'"
        >
          {{ message }}
        </p>
      </form>
    </div>
  </section>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import { currentUser, loadUserFromStorage } from '../stores/authStore.js'

// 🔽 UPDATED: Use the environment variable
const API_BASE = import.meta.env.VITE_API_BASE

const router = useRouter()
const title = ref('')
const author = ref('')
const content = ref('')
const message = ref('')
const messageType = ref('')
const loading = ref(false)

loadUserFromStorage()
const isAuthenticated = computed(() => !!currentUser.value)

async function createPost() {
  if (!isAuthenticated.value) {
    message.value = '⚠️ You must be signed in to publish posts.'
    messageType.value = 'error'
    return
  }

  loading.value = true
  message.value = ''
  const token = localStorage.getItem('token')

  try {
    // 🔽 UPDATED: Use the API_BASE variable
    const res = await fetch(`${API_BASE}/create-post`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify({
        title: title.value,
        author: author.value,
        content: content.value,
      }),
    })

    const data = await res.json()
    if (!res.ok) throw new Error(data.error || 'Failed to publish post')

    message.value = '✅ Post published successfully!'
    messageType.value = 'success'
    title.value = ''
    author.value = ''
    content.value = ''

    setTimeout(() => router.push('/blogs'), 1500)
  } catch (err) {
    message.value = '❌ ' + err.message
    messageType.value = 'error'
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
/* ✅ ADDED: Your new gradient class */
.page-headline-gradient {
  background: linear-gradient(135deg, #3b82f6 0%, #8b5cf6 50%, #ec4899 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

.glass-effect {
  background-color: rgba(15, 23, 42, 0.8);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.08);
}

.form-input {
  background-color: rgba(255, 255, 255, 0.05);
  border: 1px solid rgba(255, 255, 255, 0.15);
  color: #e2e8f0;
  transition: all 0.2s ease;
}

.form-input:focus {
  border-color: #6366f1;
  outline: none;
  box-shadow: 0 0 5px #6366f1;
}

.btn-primary {
  background: linear-gradient(135deg, #3b82f6 0%, #8b5cf6 100%);
  transition: all 0.3s ease;
}

.btn-primary:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 15px rgba(96, 165, 250, 0.3);
}

button[disabled] {
  opacity: 0.6;
  cursor: not-allowed;
}

section {
  animation: fadeIn 0.4s ease;
}
@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
</style>