import React, { useState, useEffect } from 'react'
import { useParams, Link } from 'react-router-dom'
import useApi from '../../hooks/useApi'
import { PlayCircleIcon, MusicalNoteIcon, DocumentTextIcon, CheckCircleIcon, AcademicCapIcon } from '../Icons'
import { ROUTES } from '../../lib/routes'
import RichHtml from '../RichHtml'
import FactaBoxList from '../FactaBoxList'

function LessonIcon({ contentType }) {
  switch (contentType) {
    case 'video': return <PlayCircleIcon className="w-5 h-5" />
    case 'audio': return <MusicalNoteIcon className="w-5 h-5" />
    default: return <DocumentTextIcon className="w-5 h-5" />
  }
}

function formatDuration(seconds) {
  if (!seconds) return null
  const mins = Math.floor(seconds / 60)
  return `${mins} min`
}

export default function SectionPage() {
  const { id } = useParams()
  const { request } = useApi()
  const [section, setSection] = useState(null)
  const [lessons, setLessons] = useState([])
  const [factaBoxes, setFactaBoxes] = useState([])
  const [quizId, setQuizId] = useState(null)
  const [error, setError] = useState(null)

  useEffect(() => {
    request(`/api/v1/sections/${id}`)
      .then((data) => {
        setSection(data.section)
        setLessons(data.lessons)
        setFactaBoxes(data.facta_boxes || [])
        setQuizId(data.quiz_id)
      })
      .catch((err) => setError(err.message))
  }, [request, id])

  if (error) {
    return (
      <div className="max-w-3xl mx-auto px-6 py-16 text-center">
        <p className="text-error text-lg">{error}</p>
      </div>
    )
  }

  if (!section) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="animate-pulse text-text-secondary">Indlæser sektion...</div>
      </div>
    )
  }

  const allLessonsComplete = lessons.every((l) => l.completed)
  const hasFactaBoxes = factaBoxes.length > 0

  return (
    <div className="max-w-6xl mx-auto px-6 py-12">
      <div className={hasFactaBoxes ? 'lg:grid lg:grid-cols-[minmax(0,48rem)_16rem] lg:gap-10 lg:justify-center' : ''}>
        <div className={hasFactaBoxes ? '' : 'max-w-3xl mx-auto'}>
          <p className="text-xs font-semibold tracking-[0.2em] text-accent uppercase mb-2">
            Kapitel {String(section.position).padStart(2, '0')}
          </p>
          <h1 className="font-serif text-3xl font-bold mb-3">{section.title}</h1>
          {section.description && (
            <RichHtml html={section.description} className="text-text-secondary mb-10" />
          )}

          {/* Lesson list */}
          <div className="space-y-2">
            {lessons.map((lesson) => (
              <Link
                key={lesson.id}
                to={ROUTES.lesson(lesson.id)}
                className="flex items-center gap-4 bg-surface rounded-xl border border-white/5 px-5 py-4 hover:border-accent/30 hover:bg-surface-light transition-all group"
              >
                <div className={`${lesson.completed ? 'text-success' : 'text-text-muted group-hover:text-accent'} transition-colors`}>
                  {lesson.completed ? <CheckCircleIcon className="w-5 h-5" /> : <LessonIcon contentType={lesson.content_type} />}
                </div>
                <div className="flex-1 min-w-0">
                  <p className="text-sm font-medium truncate">{lesson.title}</p>
                </div>
                <div className="flex items-center gap-3 text-xs text-text-muted">
                  {formatDuration(lesson.duration_seconds) && (
                    <span>{formatDuration(lesson.duration_seconds)}</span>
                  )}
                  <span className="capitalize">{lesson.content_type === 'text' ? 'Tekst' : lesson.content_type === 'video' ? 'Video' : 'Lyd'}</span>
                </div>
              </Link>
            ))}
          </div>

          {/* Quiz card */}
          {quizId && (
            <div className="mt-8">
              <Link
                to={allLessonsComplete ? ROUTES.quiz(quizId) : '#'}
                className={`flex items-center gap-4 rounded-xl border px-5 py-5 transition-all ${
                  allLessonsComplete
                    ? 'bg-accent/10 border-accent/30 hover:bg-accent/20'
                    : 'bg-surface border-white/5 opacity-50 cursor-not-allowed'
                }`}
                onClick={(e) => { if (!allLessonsComplete) e.preventDefault() }}
              >
                <AcademicCapIcon className={`w-6 h-6 ${allLessonsComplete ? 'text-accent' : 'text-text-muted'}`} />
                <div className="flex-1">
                  <p className="font-semibold">Sektionsquiz</p>
                  <p className="text-sm text-text-secondary">
                    {allLessonsComplete ? 'Klar til at tage quizzen' : 'Gennemfør alle lektioner først'}
                  </p>
                </div>
              </Link>
            </div>
          )}
        </div>

        {hasFactaBoxes && (
          <div className="mt-10 lg:mt-0 lg:pt-24">
            <FactaBoxList boxes={factaBoxes} />
          </div>
        )}
      </div>
    </div>
  )
}
