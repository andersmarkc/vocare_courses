import React, { useState, useEffect, useCallback } from 'react'
import { useParams, Link } from 'react-router-dom'
import useApi from '../../hooks/useApi'
import useProgress from '../../hooks/useProgress'
import useAuth from '../../hooks/useAuth'
import LessonSidebar from '../LessonSidebar'
import { CheckCircleIcon, ArrowRightIcon } from '../Icons'
import { ROUTES } from '../../lib/routes'

function VideoPlayer({ videoUrl }) {
  return (
    <div className="relative w-full aspect-video bg-black rounded-lg overflow-hidden">
      <iframe
        src={videoUrl}
        className="absolute inset-0 w-full h-full"
        frameBorder="0"
        allow="autoplay; fullscreen; picture-in-picture"
        allowFullScreen
        title="Video lektion"
      />
    </div>
  )
}

function AudioPlayer({ audioUrl }) {
  return (
    <div className="bg-surface rounded-xl border border-white/10 p-8">
      <div className="flex items-center justify-center mb-6">
        <div className="w-24 h-24 bg-accent/20 rounded-full flex items-center justify-center">
          <svg className="w-10 h-10 text-accent" fill="none" viewBox="0 0 24 24" strokeWidth={1.5} stroke="currentColor">
            <path strokeLinecap="round" strokeLinejoin="round" d="M19.114 5.636a9 9 0 010 12.728M16.463 8.288a5.25 5.25 0 010 7.424M6.75 8.25l4.72-4.72a.75.75 0 011.28.53v15.88a.75.75 0 01-1.28.53l-4.72-4.72H4.51c-.88 0-1.704-.507-1.938-1.354A9.01 9.01 0 012.25 12c0-.83.112-1.633.322-2.396C2.806 8.756 3.63 8.25 4.51 8.25H6.75z" />
          </svg>
        </div>
      </div>
      <audio controls className="w-full" src={audioUrl}>
        Din browser understøtter ikke audio.
      </audio>
    </div>
  )
}

function TextContent({ body }) {
  return (
    <div className="bg-surface rounded-xl border border-white/10 p-8">
      <div
        className="prose prose-invert prose-sm max-w-none text-text-secondary leading-relaxed"
        style={{ whiteSpace: 'pre-wrap' }}
      >
        {body}
      </div>
    </div>
  )
}

export default function LessonPage() {
  const { id } = useParams()
  const { request } = useApi()
  const { markComplete } = useProgress()
  const { refreshProgress } = useAuth()
  const [lesson, setLesson] = useState(null)
  const [progress, setProgress] = useState(null)
  const [section, setSection] = useState(null)
  const [sectionLessons, setSectionLessons] = useState([])
  const [nextTarget, setNextTarget] = useState(null)
  const [completing, setCompleting] = useState(false)

  const loadLesson = useCallback(async () => {
    const data = await request(`/api/v1/lessons/${id}`)
    setLesson(data.lesson)
    setProgress(data.progress)
    setSection(data.section)
    setNextTarget(data.next_target)

    const sectionData = await request(`/api/v1/sections/${data.section.id}`)
    setSectionLessons(sectionData.lessons)
  }, [request, id])

  useEffect(() => { loadLesson() }, [loadLesson])

  const handleMarkComplete = async () => {
    setCompleting(true)
    try {
      await markComplete(lesson.id)
      setProgress({ ...progress, completed: true })
      await refreshProgress()
      await loadLesson()
    } finally {
      setCompleting(false)
    }
  }

  if (!lesson) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="animate-pulse text-text-secondary">Indlæser lektion...</div>
      </div>
    )
  }

  const nextHref = nextTarget
    ? nextTarget.type === 'quiz'
      ? ROUTES.quiz(nextTarget.id)
      : nextTarget.type === 'section'
        ? ROUTES.section(nextTarget.id)
        : ROUTES.lesson(nextTarget.id)
    : null

  const nextLabel = nextTarget
    ? nextTarget.type === 'quiz'
      ? `Gå til ${nextTarget.title.toLowerCase()}`
      : nextTarget.section_title
        ? `Næste kapitel: ${nextTarget.section_title}`
        : `Næste lektion: ${nextTarget.title}`
    : null

  return (
    <div className="flex h-[calc(100vh-3.5rem)]">
      {/* Main content */}
      <div className="flex-1 overflow-y-auto">
        <div className="max-w-4xl mx-auto px-6 py-8">
          {/* Content area */}
          {lesson.content_type === 'video' && lesson.video_url && (
            <VideoPlayer videoUrl={lesson.video_url} />
          )}
          {lesson.content_type === 'audio' && lesson.audio_url && (
            <AudioPlayer audioUrl={lesson.audio_url} />
          )}
          {lesson.content_type === 'text' && lesson.body && (
            <TextContent body={lesson.body} />
          )}
          {lesson.content_type === 'audio' && !lesson.audio_url && (
            <div className="bg-surface rounded-xl border border-white/10 p-8 text-center text-text-muted">
              Lydfil ikke uploadet endnu
            </div>
          )}

          {/* Lesson info + actions */}
          <div className="mt-8 flex items-start justify-between gap-4">
            <div>
              <p className="text-xs text-accent font-semibold tracking-wider uppercase mb-1">
                Lektion {lesson.position}
              </p>
              <h1 className="text-2xl font-bold">{lesson.title}</h1>
            </div>

            <div className="flex items-center gap-3 shrink-0">
              {progress?.completed ? (
                <span className="flex items-center gap-2 text-success text-sm font-medium">
                  <CheckCircleIcon className="w-5 h-5" />
                  Gennemført
                </span>
              ) : (
                <button
                  onClick={handleMarkComplete}
                  disabled={completing}
                  className="bg-accent hover:bg-accent-hover text-black font-semibold rounded-lg px-5 py-2.5 text-sm transition-colors disabled:opacity-50"
                >
                  {completing ? 'Gemmer...' : 'Markér som gennemført'}
                </button>
              )}
            </div>
          </div>

          {/* Next target button — always points forward in the flow */}
          {nextTarget && (
            <Link
              to={nextHref}
              className="mt-8 inline-flex items-center gap-2 bg-surface hover:bg-surface-light border border-white/10 hover:border-accent/40 rounded-lg px-5 py-3 text-sm font-medium transition-all group"
            >
              <span>{nextLabel}</span>
              <ArrowRightIcon className="w-4 h-4 text-accent group-hover:translate-x-0.5 transition-transform" />
            </Link>
          )}

          {/* Body text for video/audio lessons */}
          {lesson.content_type !== 'text' && lesson.body && (
            <div className="mt-8 text-text-secondary text-sm leading-relaxed" style={{ whiteSpace: 'pre-wrap' }}>
              {lesson.body}
            </div>
          )}
        </div>
      </div>

      {/* Sidebar — desktop only */}
      <div className="hidden lg:block w-72 shrink-0">
        <LessonSidebar
          section={section}
          lessons={sectionLessons}
          currentLessonId={lesson.id}
        />
      </div>
    </div>
  )
}
