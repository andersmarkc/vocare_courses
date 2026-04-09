export const ROUTES = {
  login: '/login',
  dashboard: '/',
  course: (slug) => `/kursus/${slug}`,
  section: (id) => `/sektion/${id}`,
  lesson: (id) => `/lektion/${id}`,
  quiz: (id) => `/quiz/${id}`,
  quizResult: (id, attemptId) => `/quiz/${id}/resultat/${attemptId}`,
}
