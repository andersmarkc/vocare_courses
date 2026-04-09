import React, { useState, useEffect } from 'react'
import { Link } from 'react-router-dom'
import useAuth from '../../hooks/useAuth'
import useApi from '../../hooks/useApi'
import ProgressRing from '../ProgressRing'
import { ROUTES } from '../../lib/routes'

export default function DashboardPage() {
  const { customer, progress } = useAuth()
  const { request } = useApi()
  const [course, setCourse] = useState(null)
  const [sections, setSections] = useState([])

  useEffect(() => {
    request('/api/v1/courses/vocare-salgskursus')
      .then((data) => {
        setCourse(data.course)
        setSections(data.sections)
      })
      .catch(() => {})
  }, [request])

  const nextSection = sections.find((s) => !s.locked && !s.completed)
  const nextSectionLocked = sections.find((s) => s.locked)

  return (
    <div className="max-w-4xl mx-auto px-6 py-16">
      {/* Welcome — MasterClass "Welcome back" style */}
      <div className="text-center mb-16">
        <h1 className="font-serif text-4xl md:text-5xl font-bold mb-3">
          Velkommen tilbage
        </h1>
        <p className="text-text-secondary text-lg">
          Fortsæt dit kursus, {customer?.name?.split(' ')[0]}
        </p>
      </div>

      {/* Section label — MasterClass "YOUR CLASSES" style */}
      <p className="text-xs font-semibold tracking-[0.2em] text-text-secondary text-center uppercase mb-8">
        Dit kursus
      </p>

      {/* Course card — MasterClass progress card style */}
      {course && (
        <div className="bg-surface rounded-2xl overflow-hidden border border-white/5">
          <div className="p-8 md:p-12 flex flex-col md:flex-row items-center gap-8">
            {/* Left: course info */}
            <div className="flex-1 text-center md:text-left">
              <h2 className="text-2xl font-bold mb-2">{course.title}</h2>
              <p className="text-text-secondary text-sm mb-6">{course.description}</p>

              {nextSection && (
                <p className="text-text-secondary text-sm mb-6">
                  Næste:{' '}
                  <span className="text-white">
                    {String(nextSection.position).padStart(2, '0')}. {nextSection.title}
                  </span>
                </p>
              )}

              <Link
                to={nextSection ? ROUTES.section(nextSection.id) : ROUTES.course(course.slug)}
                className="inline-flex items-center gap-2 bg-accent hover:bg-accent-hover text-black font-semibold rounded-lg px-8 py-3 text-base transition-colors"
              >
                Fortsæt kurset
              </Link>
            </div>

            {/* Right: progress ring */}
            <div className="flex flex-col items-center gap-3">
              <ProgressRing
                completed={progress?.completed_lessons || 0}
                total={progress?.total_lessons || 0}
                size={140}
                strokeWidth={10}
              />
              <p className="text-xs font-semibold tracking-[0.15em] text-text-secondary uppercase">
                Lektioner gennemført
              </p>
            </div>
          </div>
        </div>
      )}

      {/* Section progress mini overview */}
      {sections.length > 0 && (
        <div className="mt-12 grid grid-cols-2 md:grid-cols-4 gap-4">
          {sections.map((section) => (
            <div
              key={section.id}
              className={`rounded-xl p-4 border ${
                section.completed
                  ? 'bg-success/10 border-success/20'
                  : section.locked
                    ? 'bg-surface border-white/5 opacity-40'
                    : 'bg-surface border-white/10'
              }`}
            >
              <p className="text-xs text-text-muted mb-1">Kapitel {section.position}</p>
              <p className="text-sm font-medium truncate mb-2">{section.title}</p>
              <div className="flex items-center gap-2">
                <div className="flex-1 bg-surface-light rounded-full h-1.5">
                  <div
                    className="bg-accent h-1.5 rounded-full transition-all duration-300"
                    style={{ width: `${section.lessons_total > 0 ? (section.lessons_completed / section.lessons_total) * 100 : 0}%` }}
                  />
                </div>
                <span className="text-xs text-text-muted">
                  {section.lessons_completed}/{section.lessons_total}
                </span>
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}
