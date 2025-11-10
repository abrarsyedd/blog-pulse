<template>
  <section class="py-10">
    <!-- Loading State -->
    <div v-if="loading" class="text-center text-gray-400 py-10 text-lg">
      Loading blog...
    </div>

    <!-- Not Found -->
    <div v-else-if="!blog" class="text-center text-gray-400 py-10 text-lg">
      Blog not found.
    </div>

    <!-- Blog Content -->
    <div
      v-else
      class="glass-effect p-10 rounded-2xl shadow-lg max-w-[82rem] mx-auto border border-[#1E293B]"
    >
      <h1
        class="text-4xl font-bold mb-4"
        style="color: rgb(96 165 250 / var(--tw-text-opacity, 1));"
      >
        {{ blog.title }}
      </h1>

      <p class="text-gray-400 text-sm mb-6">
        by <span class="font-semibold text-gray-300">{{ blog.author }}</span> •
        {{ formatDate(blog.created_at) }}
      </p>

      <p class="text-gray-300 leading-relaxed whitespace-pre-line text-lg">
        {{ blog.content }}
      </p>

      <!-- ✅ Smart Back Button -->
      <RouterLink
        :to="fromHome ? '/' : '/blogs'"
        class="inline-block mt-10 text-[#60A5FA] hover:text-[#8b5cf6] transition font-semibold"
        style="text-decoration: none;"
      >
        ← Back
      </RouterLink>
    </div>
  </section>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { useRoute } from 'vue-router'

// 🔽 UPDATED: Use the environment variable
const API_BASE = import.meta.env.VITE_API_BASE

const route = useRoute()
const blog = ref(null)
const loading = ref(true)

// ✅ Detect if user came from Home page
const fromHome = computed(() => route.query.from === 'home')

onMounted(async () => {
  try {
    // 🔽 UPDATED: Use the API_BASE variable
    const res = await fetch(`${API_BASE}/blogs/${route.params.id}`)
    if (res.ok) {
      blog.value = await res.json()
    } else {
      blog.value = null
    }
  } catch (err) {
    console.error('Error fetching blog:', err)
  } finally {
    loading.value = false
  }
})

function formatDate(iso) {
  if (!iso) return ''
  return new Date(iso).toLocaleDateString(undefined, {
    year: 'numeric',
    month: 'short',
    day: 'numeric'
  })
}
</script>

<style scoped>
.glass-effect {
  background-color: rgba(15, 23, 42, 0.85);
  backdrop-filter: blur(12px);
  border: 1px solid rgba(255, 255, 255, 0.05);
}

/* Smooth transition for entire section */
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