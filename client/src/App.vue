<template>
  <Navbar />

  <!-- 
    REMOVED: Dynamic class logic.
    This <main> tag now correctly applies the same aligned layout 
    to ALL pages, including the 'Create' page.
  -->
  <main class="max-w-[82rem] mx-auto px-8 py-10">
    <RouterView :key="$route.fullPath" />
  </main>
</template>

<script setup>
// 'useRoute' is no longer needed here since the layout is consistent
import { useRoute } from 'vue-router' 
import Navbar from './components/Navbar.vue'

const route = useRoute()
</script>

<style>
body {
  background-color: #0f172a;
  color: #e2e8f0;
  margin: 0;
  font-family: 'Inter', sans-serif;
}

/* REMOVED: The padding from the global 'main' style.
  Padding is now handled by the Tailwind classes on the <main> tag.
*/
</style>