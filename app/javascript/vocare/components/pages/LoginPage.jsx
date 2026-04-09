import React, { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import useAuth from '../../hooks/useAuth'
import { SpinnerIcon } from '../Icons'

export default function LoginPage() {
  const { login } = useAuth()
  const navigate = useNavigate()

  const [code, setCode] = useState('')
  const [name, setName] = useState('')
  const [email, setEmail] = useState('')
  const [needsName, setNeedsName] = useState(false)
  const [error, setError] = useState(null)
  const [loading, setLoading] = useState(false)

  const handleSubmit = async (e) => {
    e.preventDefault()
    setError(null)
    setLoading(true)

    try {
      const data = await login(code, { name: name || undefined, email: email || undefined })
      if (data.first_login && !name) {
        setNeedsName(true)
        setLoading(false)
        return
      }
      navigate('/')
    } catch (err) {
      if (err.status === 401 && err.message.includes('Navn')) {
        setNeedsName(true)
      } else {
        setError(err.message)
      }
      setLoading(false)
    }
  }

  return (
    <div className="min-h-screen flex flex-col items-center justify-center px-6">
      <div className="max-w-md w-full text-center">
        {/* Hero heading — MasterClass style */}
        <h1 className="font-serif font-bold text-5xl md:text-6xl tracking-tight leading-tight mb-4">
          BLIV DEN BEDSTE
          <br />
          SÆLGER
        </h1>

        {/* Gold accent bar */}
        <div className="w-16 h-1 bg-accent mx-auto mb-6" />

        <p className="text-text-secondary text-lg mb-12">
          Vocare Salgskursus — 8 kapitler om telefonsalg
        </p>

        {/* Login form */}
        <form onSubmit={handleSubmit} className="space-y-4">
          <div>
            <input
              type="text"
              value={code}
              onChange={(e) => setCode(e.target.value.toUpperCase())}
              placeholder="VOCARE-XXXX-XXXX"
              className="w-full bg-surface border border-white/10 rounded-lg px-4 py-4 text-center text-lg font-mono text-white placeholder-text-muted focus:outline-none focus:border-accent focus:ring-1 focus:ring-accent transition-colors"
              autoFocus
              required
            />
          </div>

          {needsName && (
            <>
              <div>
                <input
                  type="text"
                  value={name}
                  onChange={(e) => setName(e.target.value)}
                  placeholder="Dit navn"
                  className="w-full bg-surface border border-white/10 rounded-lg px-4 py-3 text-white placeholder-text-muted focus:outline-none focus:border-accent focus:ring-1 focus:ring-accent transition-colors"
                  required
                  autoFocus
                />
              </div>
              <div>
                <input
                  type="email"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  placeholder="Email (valgfrit)"
                  className="w-full bg-surface border border-white/10 rounded-lg px-4 py-3 text-white placeholder-text-muted focus:outline-none focus:border-accent focus:ring-1 focus:ring-accent transition-colors"
                />
              </div>
            </>
          )}

          {error && (
            <p className="text-error text-sm">{error}</p>
          )}

          <button
            type="submit"
            disabled={loading}
            className="w-full bg-accent hover:bg-accent-hover text-black font-semibold rounded-lg px-6 py-4 text-lg transition-colors disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2"
          >
            {loading ? (
              <>
                <SpinnerIcon className="w-5 h-5" />
                Indlæser...
              </>
            ) : (
              needsName ? 'Start kurset' : 'Log ind'
            )}
          </button>
        </form>
      </div>
    </div>
  )
}
