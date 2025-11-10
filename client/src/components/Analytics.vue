<template>
  <section>
    <!-- ✅ UPDATED: Class changed for the new gradient -->
    <h2 class="page-headline-gradient text-3xl font-bold mb-8">Analytics & Insights</h2>

    <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
      <div class="glass-effect p-8 rounded-lg">
        <h3 class="text-xl font-semibold mb-6 text-blue-400">Posts Over Time</h3>
        <div class="chart-container"><canvas ref="postsOverTime"></canvas></div>
      </div>

      <div class="glass-effect p-8 rounded-lg">
        <h3 class="text-xl font-semibold mb-6 text-blue-400">Monthly Post Trend</h3>
        <div class="chart-container"><canvas ref="monthlyPosts"></canvas></div>
      </div>

      <div class="glass-effect p-8 rounded-lg">
        <h3 class="text-xl font-semibold mb-6 text-blue-400">Topics Frequency</h3>
        <div class="chart-container"><canvas ref="topics"></canvas></div>
      </div>

      <div class="glass-effect p-8 rounded-lg">
        <h3 class="text-xl font-semibold mb-6 text-blue-400">Top Authors</h3>
        <div class="chart-container"><canvas ref="topAuthors"></canvas></div>
      </div>

      <div class="glass-effect p-8 rounded-lg">
        <h3 class="text-xl font-semibold mb-6 text-blue-400">Growth Dimensions</h3>
        <div class="chart-container"><canvas ref="engagement"></canvas></div>
      </div>
    </div>
  </section>
</template>

<script setup>
import { ref, onMounted, onBeforeUnmount } from 'vue'
import { Chart } from 'chart.js/auto'

const postsOverTime = ref(null)
const monthlyPosts = ref(null)
const topics = ref(null)
const topAuthors = ref(null)
const engagement = ref(null)

let charts = {}

function makeLine(el, labels, data, label) {
  const ctx = el.getContext('2d')
  return new Chart(ctx, {
    type: 'line',
    data: {
      labels,
      datasets: [{
        label,
        data,
        fill: true,
        borderColor: '#3b82f6',
        backgroundColor: 'rgba(59,130,246,0.07)',
        pointBackgroundColor: '#10b981',
        pointRadius: 5,
        borderWidth: 3,
        tension: 0.5
      }]
    },
    options: {
      plugins: { legend: { labels: { color: '#e2e8f0' } } },
      responsive: true,
      maintainAspectRatio: false,
      scales: {
        y: { ticks: { color: '#e2e8f0' } },
        x: { ticks: { color: '#e2e8f0' } }
      }
    }
  })
}

function makeBar(el, labels, data, label) {
  const ctx = el.getContext('2d')
  return new Chart(ctx, {
    type: 'bar',
    data: {
      labels,
      datasets: [{
        label,
        data,
        backgroundColor: '#8b5cf6',
        borderRadius: 5,
        borderSkipped: false,
        barThickness: 30,
        maxBarThickness: 40
      }]
    },
    options: {
      plugins: { legend: { labels: { color: '#e2e8f0' } } },
      responsive: true,
      maintainAspectRatio: false,
      scales: {
        y: {
          ticks: { color: '#e2e8f0' },
          grid: { color: 'rgba(100, 100, 100, 0.1)' }
        },
        x: {
          ticks: { color: '#e2e8f0' },
          grid: { display: false }
        }
      }
    }
  })
}

onMounted(() => {
  charts.postsOverTime = makeLine(postsOverTime.value, ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'], [5,8,6,10,13,11,14], 'Posts per Day')
  charts.monthlyPosts = makeLine(monthlyPosts.value, ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'], Array.from({ length: 12 }, (_, i) => 10 + Math.round(Math.random() * 6)), 'Monthly Posts')
  charts.topics = makeBar(topics.value, ['AWS','Azure','Lambda','Terraform','DevOps','Automation','Containers'], [15,8,12,10,17,14,9], 'Topics Frequency')
  charts.topAuthors = makeBar(topAuthors.value, ['John Smith','Sarah Wilson','Mike Johnson','Emily Davis','Alex Brown'], [8,6,12,5,9], 'Posts per Author')
  charts.engagement = makeBar(engagement.value, ['Reach','Quality','Impact','Comments','Shares','Engagement'], [14,18,22,9,15,12], 'Growth Dimensions')
})

onBeforeUnmount(() => {
  Object.values(charts).forEach(c => c && c.destroy())
})
</script>

<!-- ✅ ADDED: <style scoped> block for the new class -->
<style scoped>
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

.chart-container {
  height: 300px; /* Or any fixed height */
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