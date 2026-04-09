import React from 'react'
import { Link } from 'react-router-dom'
import useAuth from '../hooks/useAuth'

export default function Navbar() {
  const { customer, logout } = useAuth()

  const handleLogout = async () => {
    await logout()
  }

  return (
    <nav className="border-b border-white/10 bg-surface">
      <div className="max-w-7xl mx-auto px-6 h-14 flex items-center justify-between">
        <div className="flex items-center gap-8">
          <Link to="/" className="text-lg font-bold tracking-tight text-white">
            Vocare
          </Link>
          <Link to="/kursus/vocare-salgskursus" className="text-sm text-text-secondary hover:text-white transition-colors">
            Kursus
          </Link>
        </div>
        <div className="flex items-center gap-4">
          <span className="text-sm text-text-secondary">{customer?.name}</span>
          <button
            onClick={handleLogout}
            className="text-sm text-text-muted hover:text-white transition-colors"
          >
            Log ud
          </button>
        </div>
      </div>
    </nav>
  )
}
