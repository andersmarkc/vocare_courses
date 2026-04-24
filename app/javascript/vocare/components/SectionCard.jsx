import React from 'react'
import { Link } from 'react-router-dom'
import { CheckCircleIcon, LockClosedIcon } from './Icons'
import { ROUTES } from '../lib/routes'

function stripHtml(html) {
  if (!html) return ''
  return html.replace(/<[^>]*>/g, ' ').replace(/\s+/g, ' ').trim()
}

export default function SectionCard({ section }) {
  const { id, title, description, position, locked, completed, lessons_completed, lessons_total, quiz_id } = section
  const plainDescription = stripHtml(description)

  if (locked) {
    return (
      <div className="bg-surface rounded-xl border border-white/5 p-6 opacity-50">
        <div className="flex items-start justify-between mb-3">
          <span className="text-xs font-semibold text-text-muted tracking-wider">
            KAPITEL {String(position).padStart(2, '0')}
          </span>
          <LockClosedIcon className="w-5 h-5 text-locked" />
        </div>
        <h3 className="text-lg font-semibold mb-2 text-text-secondary">{title}</h3>
        <p className="text-sm text-text-muted line-clamp-2">{plainDescription}</p>
        <p className="text-xs text-text-muted mt-4">
          Gennemfør forrige sektion først
        </p>
      </div>
    )
  }

  return (
    <Link
      to={ROUTES.section(id)}
      className={`block bg-surface rounded-xl border p-6 transition-all hover:border-accent/50 hover:bg-surface-light ${
        completed ? 'border-success/30' : 'border-white/10'
      }`}
    >
      <div className="flex items-start justify-between mb-3">
        <span className="text-xs font-semibold text-accent tracking-wider">
          KAPITEL {String(position).padStart(2, '0')}
        </span>
        {completed && <CheckCircleIcon className="w-5 h-5 text-success" />}
      </div>
      <h3 className="text-lg font-semibold mb-2">{title}</h3>
      <p className="text-sm text-text-secondary line-clamp-2 mb-4">{plainDescription}</p>
      <div className="flex items-center justify-between">
        <div className="flex items-center gap-2">
          <div className="flex-1 w-24 bg-surface-light rounded-full h-1.5">
            <div
              className="bg-accent h-1.5 rounded-full transition-all duration-300"
              style={{ width: `${lessons_total > 0 ? (lessons_completed / lessons_total) * 100 : 0}%` }}
            />
          </div>
          <span className="text-xs text-text-muted">{lessons_completed}/{lessons_total}</span>
        </div>
      </div>
    </Link>
  )
}
