<template>
  <section class="max-w-md mx-auto glass-effect p-10 rounded-lg">
    <h2 class="gradient-text text-3xl font-bold mb-6 text-center">Sign In</h2>

    <form @submit.prevent="handleSignIn">
      <div class="mb-6">
        <label class="block text-sm font-medium mb-3 text-gray-300">Email</label>
        <input
          v-model="email"
          type="email"
          class="form-input w-full px-4 py-3 rounded-lg"
          placeholder="you@example.com"
          required
        />
      </div>

      <div class="mb-6">
        <label class="block text-sm font-medium mb-3 text-gray-300">Password</label>
        <input
          v-model="password"
          type="password"
          class="form-input w-full px-4 py-3 rounded-lg"
          placeholder="••••••••"
          required
        />
      </div>

      <button
        type="submit"
        class="btn-primary text-white px-8 py-3 rounded-lg font-semibold w-full hover:shadow-lg"
      >
        Sign In
      </button>
    </form>

    <!-- ✅ Google Sign-In -->
    <div class="mt-6 flex justify-center">
      <div
        id="g_id_onload"
        :data-client_id="googleClientId"
        data-context="signin"
        data-ux_mode="popup"
        data-callback="handleCredentialResponse"
      ></div>
      <div class="g_id_signin" data-type="standard" data-size="large"></div>
    </div>

    <p class="text-gray-400 text-center mt-6">
      Don’t have an account?
      <RouterLink to="/signup" class="text-blue-400 hover:underline">Sign up</RouterLink>
    </p>

    <p
      class="text-center text-sm mt-4"
      :class="messageType === 'success' ? 'text-green-400' : 'text-red-400'"
    >
      {{ message }}
    </p>
  </section>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { setUser } from '../stores/authStore.js'

// 🔽 UPDATED: Use the environment variable
const API_BASE = import.meta.env.VITE_API_BASE
const googleClientId = import.meta.env.VITE_GOOGLE_CLIENT_ID

const router = useRouter()
const email = ref('')
const password = ref('')
const message = ref('')
const messageType = ref('')

async function handleSignIn() {
  message.value = ''
  try {
    // 🔽 UPDATED: Use the API_BASE variable
    const res = await fetch(`${API_BASE}/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email: email.value, password: password.value })
    })
    const data = await res.json()
    if (!res.ok) throw new Error(data.error || 'Login failed')

    message.value = '✅ Login successful!'
    messageType.value = 'success'
    localStorage.setItem('token', data.token)

    const userData = { email: email.value }
    setUser(userData)

    setTimeout(() => router.push('/'), 800)
  } catch (err) {
    message.value = '❌ ' + err.message
    messageType.value = 'error'
  }
}

// ✅ Google Sign-In integration
onMounted(() => {
  const script = document.createElement('script')
  script.src = 'https://accounts.google.com/gsi/client'
  script.async = true
  script.defer = true
  document.head.appendChild(script)

  window.handleCredentialResponse = async (response) => {
    try {
      // 🔽 UPDATED: Use the API_BASE variable
      const res = await fetch(`${API_BASE}/google-login`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ token: response.credential })
      })
      const data = await res.json()
      if (!res.ok) throw new Error(data.error || 'Google login failed')

      message.value = '✅ Google Sign-In successful!'
      messageType.value = 'success'
      localStorage.setItem('token', data.token)

      const payload = JSON.parse(atob(data.token.split('.')[1]))
      const userData = { email: payload.email }
      setUser(userData)

      setTimeout(() => router.push('/'), 800)
    // ✅ SYNTAX FIX: Moved the brace to the correct line
    } catch (err) {
      message.value = '❌ ' + err.message
      messageType.value = 'error'
    }
  }
})
</script>

<style scoped>
/* ... (styles are all correct) ... */
.gradient-text {
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
section {
  animation: fadeIn 0.4s ease;
}
@keyframes fadeIn {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}
</style>