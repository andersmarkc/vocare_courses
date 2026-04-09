import React from 'react'
import { Link } from 'react-router-dom'
import { CheckCircleIcon, PlayCircleIcon, MusicalNoteIcon, DocumentTextIcon } from './Icons'
import { ROUTES } from '../lib/routes'

function LessonIcon({ contentType }) {
  switch (contentType) {
    case 'video': return <PlayCircleIcon className="w-4 h-4" />
    case 'audio': return <MusicalNoteIcon className="w-4 h-4" />
    default: return <DocumentTextIcon className="w-4 h-4" />
  }
}

export default function LessonSidebar({ section, lessons, currentLessonId }) {
  return (
    <div className="bg-surface border-l border-white/5 h-full">
      <div className="p-4 border-b border-white/5">
        <p className="text-xs font-semibold tracking-[0.15em] text-accent uppercase">
          Kapitel {section?.position}
        </p>
        <h3 className="text-sm font-semibold mt-1 truncate">{section?.title}</h3>
      </div>

      <div className="overflow-y-auto">
        {lessons.map((lesson, idx) => {
          const isCurrent = lesson.id === currentLessonId
          return (
            <Link
              key={lesson.id}
              to={ROUTES.lesson(lesson.id)}
              className={`flex items-center gap-3 px-4 py-3 text-sm border-l-2 transition-colors ${
                isCurrent
                  ? 'border-accent bg-accent/10 text-white'
                  : 'border-transparent hover:bg-surface-light text-text-secondary hover:text-white'
              }`}
            >
              <span className="text-text-muted text-xs w-5 text-right">{idx + 1}.</span>
              <div className={lesson.completed ? 'text-success' : isCurrent ? 'text-accent' : 'text-text-muted'}>
                {lesson.completed ? <CheckCircleIcon className="w-4 h-4" /> : <LessonIcon contentType={lesson.content_type} />}
              </div>
              <span className="truncate flex-1">{lesson.title}</span>
            </Link>
          )
        })}
      </div>
    </div>
  )
}
