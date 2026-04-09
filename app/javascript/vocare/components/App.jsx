import React from 'react'
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom'
import { AuthProvider } from '../hooks/useAuth'
import useAuth from '../hooks/useAuth'
import Navbar from './Navbar'
import LoginPage from './pages/LoginPage'
import DashboardPage from './pages/DashboardPage'
import CoursePage from './pages/CoursePage'
import SectionPage from './pages/SectionPage'
import LessonPage from './pages/LessonPage'
import QuizPage from './pages/QuizPage'

function ProtectedRoute({ children }) {
  const { customer, loading } = useAuth()

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="animate-pulse text-text-secondary">Indlæser...</div>
      </div>
    )
  }

  if (!customer) return <Navigate to="/login" replace />
  return children
}

function AppRoutes() {
  const { customer, loading } = useAuth()

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="animate-pulse text-text-secondary">Indlæser...</div>
      </div>
    )
  }

  return (
    <>
      {customer && <Navbar />}
      <Routes>
        <Route path="/login" element={customer ? <Navigate to="/" replace /> : <LoginPage />} />
        <Route path="/" element={<ProtectedRoute><DashboardPage /></ProtectedRoute>} />
        <Route path="/kursus/:slug" element={<ProtectedRoute><CoursePage /></ProtectedRoute>} />
        <Route path="/sektion/:id" element={<ProtectedRoute><SectionPage /></ProtectedRoute>} />
        <Route path="/lektion/:id" element={<ProtectedRoute><LessonPage /></ProtectedRoute>} />
        <Route path="/quiz/:id" element={<ProtectedRoute><QuizPage /></ProtectedRoute>} />
        <Route path="/quiz/:id/resultat/:attemptId" element={<ProtectedRoute><QuizPage /></ProtectedRoute>} />
        <Route path="*" element={<Navigate to="/" replace />} />
      </Routes>
    </>
  )
}

export default function App() {
  return (
    <BrowserRouter>
      <AuthProvider>
        <AppRoutes />
      </AuthProvider>
    </BrowserRouter>
  )
}
