import React, { createContext, useContext, useState, useEffect, useCallback } from 'react'
import useApi from './useApi'

const AuthContext = createContext(null)

export function AuthProvider({ children }) {
  const { request } = useApi()
  const [customer, setCustomer] = useState(null)
  const [progress, setProgress] = useState(null)
  const [loading, setLoading] = useState(true)

  const checkAuth = useCallback(async () => {
    try {
      const data = await request('/api/v1/auth/me')
      setCustomer(data.customer)
      setProgress(data.progress)
    } catch {
      setCustomer(null)
      setProgress(null)
    } finally {
      setLoading(false)
    }
  }, [request])

  useEffect(() => { checkAuth() }, [checkAuth])

  const login = async (code, { name, email, phone, company } = {}) => {
    const data = await request('/api/v1/auth/login', {
      method: 'POST',
      body: JSON.stringify({ code, name, email, phone, company }),
    })
    setCustomer(data.customer)
    return data
  }

  const logout = async () => {
    await request('/api/v1/auth/logout', { method: 'DELETE' })
    setCustomer(null)
    setProgress(null)
  }

  const refreshProgress = async () => {
    try {
      const data = await request('/api/v1/auth/me')
      setProgress(data.progress)
    } catch { /* ignore */ }
  }

  return (
    <AuthContext.Provider value={{ customer, progress, loading, login, logout, refreshProgress }}>
      {children}
    </AuthContext.Provider>
  )
}

export default function useAuth() {
  const ctx = useContext(AuthContext)
  if (!ctx) throw new Error('useAuth must be used within AuthProvider')
  return ctx
}
