<template>
  <section>
    <!-- Hero Section -->
    <div class="glass-effect p-12 mb-12 text-center">
      <h2 class="gradient-text text-4xl font-bold mb-4">Welcome to Blog Pulse</h2>
      <!-- ✅ FIX: Added 'pb-1' to give 'g' and 'p' characters room -->
      <p class="text-gray-300 text-lg mb-8 pb-1">
        Share your expertise, track your impact, and visualize your growth.
      </p>
      <RouterLink
        to="/create"
        class="btn-primary px-8 py-3 rounded-lg font-semibold inline-block"
      >
        Create Your First Post
      </RouterLink>
    </div>

    <!-- About Section -->
    <section class="mb-16">
      <h2 class="gradient-text text-3xl font-bold mb-8">About Blog Pulse</h2>
      <div class="glass-effect p-8 rounded-lg mb-8">
        <p class="text-gray-300 text-lg leading-relaxed mb-6">
          Blog Pulse is a modern, intuitive blogging platform designed for creators, developers,
          and professionals who want to share their knowledge and insights with the world. Whether
          you're writing technical tutorials, sharing industry expertise, or documenting your journey,
          Blog Pulse provides the tools you need to succeed.
        </p>
        <p class="text-gray-300 text-lg leading-relaxed">
          Built with modern web technologies and a focus on user experience, our platform combines
          beautiful design with powerful analytics to help you understand your audience and grow
          your readership.
        </p>
      </div>
    </section>

    <!-- Features Section -->
    <section class="mb-16">
      <h2 class="gradient-text text-3xl font-bold mb-8">Why Choose Blog Pulse?</h2>
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        <div class="feature-card">
          <div class="feature-icon">📝</div>
          <h3 class="text-xl font-bold text-blue-400 mb-3">Easy Publishing</h3>
          <p class="text-gray-300">
            Create and publish posts in seconds with our intuitive editor.
          </p>
        </div>
        <div class="feature-card">
          <div class="feature-icon">📊</div>
          <h3 class="text-xl font-bold text-blue-400 mb-3">Real-Time Analytics</h3>
          <p class="text-gray-300">
            Track your posts' performance with detailed insights.
          </p>
        </div>
        <div class="feature-card">
          <div class="feature-icon">🎨</div>
          <h3 class="text-xl font-bold text-blue-400 mb-3">Modern Design</h3>
          <p class="text-gray-300">
            Beautiful, responsive interface that looks great on all devices.
          </p>
        </div>
        <div class="feature-card">
          <div class="feature-icon">⚡</div>
          <h3 class="text-xl font-bold text-blue-400 mb-3">Lightning Fast</h3>
          <p class="text-gray-300">
            Optimized performance ensures your readers get the best experience.
          </p>
        </div>
        <div class="feature-card">
          <div class="feature-icon">👥</div>
          <h3 class="text-xl font-bold text-blue-400 mb-3">Community</h3>
          <p class="text-gray-300">
            Connect with other creators and readers.
          </p>
        </div>
        <div class="feature-card">
          <div class="feature-icon">🔒</div>
          <h3 class="text-xl font-bold text-blue-400 mb-3">Secure & Reliable</h3>
          <p class="text-gray-300">
            Your content is protected with enterprise-grade security.
          </p>
        </div>
      </div>
    </section>

    <!-- Latest Posts Section -->
    <section class="mb-12">
      <h2 class="gradient-text text-3xl font-bold mb-8">Latest Posts</h2>
      <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
        <template v-if="latest.length">
          <article
            v-for="post in latest.slice(0, 3)"
            :key="post.id"
            class="p-6 rounded-lg bg-[#111827] border border-[#1E293B] hover:border-[#3B82F6] transition duration-300"
          >
            <!-- Clickable Title -->
            <RouterLink
              :to="`/blogs/${post.id}?from=home`"
              class="block hover:text-[#60A5FA] transition"
            >
              <h3
                class="text-xl font-bold cursor-pointer transition"
                style="color: rgb(96 165 250 / var(--tw-text-opacity, 1));"
              >
                {{ post.title }}
              </h3>
            </RouterLink>

            <p class="text-sm text-gray-400 mb-4">
              by {{ post.author }} • {{ formatDate(post.created_at) }}
            </p>

            <!-- ✅ FIX: Added 'leading-relaxed' here to prevent 'g' clipping -->
            <p class="text-gray-300 mb-4 line-clamp-2 leading-relaxed">
              {{ preview(post.content) }}
            </p>

            <!-- Read More -->
            <RouterLink
              :to="`/blogs/${post.id}?from=home`"
              class="font-semibold transition duration-300 read-more"
            >
              Read More
            </RouterLink>
          </article>
        </template>

        <p v-else class="text-gray-400 col-span-full text-center py-12">
          No posts yet. Create one to get started!
        </p>
      </div>
    </section>
  </section>
</template>

<script setup>
import { ref, onMounted } from 'vue'

// 🔽 UPDATED: Use the environment variable
const API_BASE = import.meta.env.VITE_API_BASE
const latest = ref([])

const fetchLatest = async () => {
  try {
    // 🔽 UPDATED: Use the API_BASE variable
    const res = await fetch(`${API_BASE}/blogs`)
    const data = await res.json()
    latest.value = Array.isArray(data)
      ? data.sort((a, b) => new Date(b.created_at) - new Date(a.created_at))
      : []
  } catch (e) {
    console.error('Error loading latest posts', e)
  }
}

const formatDate = (d) => new Date(d).toLocaleDateString()
const preview = (text) => {
  const s = text?.replace(/[\n\r]+/g, ' ') || ''
  return s.length > 180 ? s.slice(0, 180) + '...' : s
}

onMounted(fetchLatest)
</script>

<style scoped>
.glass-effect {
  background-color: rgba(15, 23, 42, 0.8);
  backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.feature-card {
  background-color: rgba(30, 41, 59, 0.6);
  padding: 1.5rem;
  border-radius: 1rem;
  text-align: center;
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}
.feature-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 4px 15px rgba(96, 165, 250, 0.2);
}

.gradient-text {
  background: linear-gradient(135deg, #3b82f6 0%, #8b5cf6 50%, #ec4899 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
}

.btn-primary {
  background: linear-gradient(135deg, #3b82f6 0%, #8b5cf6 100%);
  color: white;
  transition: all 0.3s ease;
}
.btn-primary:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 15px rgba(96, 165, 250, 0.3);
}

/* Read More Hover Effect */
.read-more {
  color: rgb(96 165 250 / var(--tw-text-opacity, 1));
  text-decoration: none;
}
.read-more:hover {
  color: #8b5cf6;
  text-decoration: none;
}
</style>