import { useCallback } from 'react'
import useApi from './useApi'

export default function useProgress() {
  const { request } = useApi()

  const markComplete = useCallback(async (lessonId) => {
    return request(`/api/v1/lessons/${lessonId}/progress`, {
      method: 'POST',
      body: JSON.stringify({ completed: true }),
    })
  }, [request])

  const updatePosition = useCallback(async (lessonId, seconds) => {
    return request(`/api/v1/lessons/${lessonId}/progress`, {
      method: 'POST',
      body: JSON.stringify({ position_seconds: seconds }),
    })
  }, [request])

  return { markComplete, updatePosition }
}
