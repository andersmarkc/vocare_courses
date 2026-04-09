import { useCallback } from 'react'

function getCsrfToken() {
  const meta = document.querySelector('meta[name="csrf-token"]')
  return meta ? meta.getAttribute('content') : ''
}

export default function useApi() {
  const request = useCallback(async (path, options = {}) => {
    const response = await fetch(path, {
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': getCsrfToken(),
        ...options.headers,
      },
      ...options,
    })

    if (!response.ok) {
      const body = await response.json().catch(() => ({}))
      const error = new Error(body.error || `API error: ${response.status}`)
      error.status = response.status
      throw error
    }

    if (response.status === 204) return null
    return response.json()
  }, [])

  return { request }
}
