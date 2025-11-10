import { createRouter, createWebHistory } from 'vue-router'

// ✅ Page imports
import Home from '../components/Home.vue'
import Blogs from '../components/Blogs.vue'
import Analytics from '../components/Analytics.vue'
import Create from '../components/Create.vue'
import SignIn from '../components/SignIn.vue'
import SignUp from '../components/SignUp.vue'
import BlogDetail from '../components/BlogDetail.vue' // ✅ new file

const routes = [
  { path: '/', name: 'Home', component: Home },
  { path: '/blogs', name: 'Blogs', component: Blogs },
  { path: '/analytics', name: 'Analytics', component: Analytics },
  { path: '/create', name: 'Create', component: Create },
  { path: '/signin', name: 'SignIn', component: SignIn },
  { path: '/signup', name: 'SignUp', component: SignUp },

  // ✅ Blog detail page
  { path: '/blogs/:id', name: 'BlogDetail', component: BlogDetail, props: true },

  // fallback for invalid URLs
  { path: '/:pathMatch(.*)*', redirect: '/' }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
