<template>
  <!-- Main Section -->
  <section>
    <!-- Title -->
    <h2
      class="page-headline-gradient text-3xl font-bold mb-6"
    >
      All Blogs
    </h2>

    <!-- 🔍 Search Bar -->
    <div class="mb-8">
      <input
        v-model="searchQuery"
        type="text"
        placeholder="Search blogs by title, author, or keyword..."
        class="w-full p-3 rounded-md bg-[#111827] border border-[#1E293B] text-gray-200 placeholder-gray-500 focus:outline-none focus:ring-2 focus:ring-[#3B82F6]"
      />
    </div>

    <!-- 🌀 Loading -->
    <div v-if="loading" class="text-gray-400 text-center text-lg py-10">
      Loading blogs...
    </div>

    <!-- 🪶 Empty -->
    <div v-else-if="filteredBlogs.length === 0" class="text-gray-400 text-center py-10 text-lg">
      No blogs found.
    </div>

    <!-- 🧩 Blogs Grid -->
    <div v-else class="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
      <article
        v-for="blog in filteredBlogs"
        :key="blog.id"
        class="p-6 rounded-lg bg-[#111827] border border-[#1E293B] hover:border-[#3B82F6] transition duration-300"
      >
        <!-- Blog Title as Clickable RouterLink -->
        <RouterLink
          :to="`/blogs/${blog.id}`"
          class="block mb-2 transition"
          style="text-decoration: none;"
        >
          <h3
            class="text-lg font-bold cursor-pointer transition"
            style="color: rgb(96 165 250 / var(--tw-text-opacity, 1));"
          >
            {{ blog.title }}
          </h3>
        </RouterLink>

        <!-- Author and Date -->
        <p class="text-gray-400 text-sm mb-3">
          by <span class="font-semibold text-gray-300">{{ blog.author }}</span> •
          {{ formatDate(blog.created_at) }}
        </p>

        <!-- Content Preview -->
        <p class="text-gray-300 text-sm leading-relaxed mb-4">
          {{ truncate(blog.content, 250) }}
        </p>

        <!-- Read More Button -->
        <RouterLink
          :to="`/blogs/${blog.id}`"
          class="font-semibold transition"
          style="color: rgb(96 165 250 / var(--tw-text-opacity, 1)); text-decoration: none;"
        >
          Read More
        </RouterLink>
      </article>
    </div>
  </section>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'

// 🔽 UPDATED: Use the environment variable
const API_BASE = import.meta.env.VITE_API_BASE

// State Variables
const blogs = ref([])
const loading = ref(true)
const searchQuery = ref('')

// Fetch All Blogs on Mount
onMounted(async () => {
  try {
    // 🔽 UPDATED: Use the API_BASE variable
    const res = await fetch(`${API_BASE}/blogs`)
    const data = await res.json()
    blogs.value = Array.isArray(data) ? data : []
  } catch (err) {
    console.error('Error loading blogs:', err)
  } finally {
    loading.value = false
  }
})

// Search Filter
const filteredBlogs = computed(() => {
  if (!searchQuery.value) return blogs.value
  const q = searchQuery.value.toLowerCase()
  return blogs.value.filter(
    b =>
      b.title.toLowerCase().includes(q) ||
      b.author.toLowerCase().includes(q) ||
      b.content.toLowerCase().includes(q)
  )
})

// Helper: Truncate Text
function truncate(text, length) {
  if (!text) return ''
  return text.length > length ? text.slice(0, length) + '…' : text
}

// Helper: Format Date
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
/* ✅ ADDED: Your new gradient class */
.page-headline-gradient {
  background: linear-gradient(135deg, #3b82f6 0%, #8b5cf6 50%, #ec4899 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

/* Card Styling */
article {
  box-shadow: 0 0 0 1px rgba(255, 255, 255, 0.03);
  transition: transform 0.25s ease, box-shadow 0.25s ease;
}
article:hover {
  transform: translateY(-5px);
  box-shadow: 0 4px 15px rgba(96, 165, 250, 0.15);
}

/* Smooth Appearance Animation */
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

/* Hover Effect for Read More & Title */
a:hover h3,
a:hover {
  color: #8b5cf6 !important;
}
</style>