import React, { useState, useEffect } from 'react'
import { useParams } from 'react-router-dom'
import useApi from '../../hooks/useApi'
import SectionCard from '../SectionCard'

export default function CoursePage() {
  const { slug } = useParams()
  const { request } = useApi()
  const [course, setCourse] = useState(null)
  const [sections, setSections] = useState([])

  useEffect(() => {
    request(`/api/v1/courses/${slug}`)
      .then((data) => {
        setCourse(data.course)
        setSections(data.sections)
      })
      .catch(() => {})
  }, [request, slug])

  if (!course) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="animate-pulse text-text-secondary">Indlæser kursus...</div>
      </div>
    )
  }

  return (
    <div className="max-w-5xl mx-auto px-6 py-12">
      <div className="mb-12">
        <h1 className="font-serif text-3xl md:text-4xl font-bold mb-3">{course.title}</h1>
        <p className="text-text-secondary text-lg max-w-2xl">{course.description}</p>
      </div>

      <p className="text-xs font-semibold tracking-[0.2em] text-text-secondary uppercase mb-6">
        {sections.length} Kapitler
      </p>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {sections.map((section) => (
          <SectionCard key={section.id} section={section} />
        ))}
      </div>
    </div>
  )
}
