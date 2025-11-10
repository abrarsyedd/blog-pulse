import { ref } from 'vue'

export const currentUser = ref(null)

export function setUser(user) {
  currentUser.value = user
  if (user) {
    localStorage.setItem('user', JSON.stringify(user))
  } else {
    localStorage.removeItem('user')
  }
}

export function loadUserFromStorage() {
  const stored = localStorage.getItem('user')
  if (stored) currentUser.value = JSON.parse(stored)
}
