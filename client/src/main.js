import { createApp } from 'vue'
import { createRouter, createWebHistory } from 'vue-router'
import App from './App.vue'
import './assets/main.css'

// ✅ Import all pages
import Home from './components/Home.vue'
import Blogs from './components/Blogs.vue'
import BlogDetail from './components/BlogDetail.vue' // ⬅️ NEW
import Analytics from './components/Analytics.vue'
import Create from './components/Create.vue'
import SignIn from './components/SignIn.vue'
import SignUp from './components/SignUp.vue'

// ✅ Define routes
const routes = [
  { path: '/', component: Home },
  { path: '/blogs', component: Blogs },
  { path: '/blogs/:id', name: 'BlogDetail', component: BlogDetail, props: true }, // ⬅️ NEW
  { path: '/analytics', component: Analytics },
  { path: '/create', component: Create },
  { path: '/signin', component: SignIn },
  { path: '/signup', component: SignUp },

  // optional: catch-all fallback
  { path: '/:pathMatch(.*)*', redirect: '/' }
]

// ✅ Create and mount app
const router = createRouter({
  history: createWebHistory(),
  routes,
})

createApp(App).use(router).mount('#app')
