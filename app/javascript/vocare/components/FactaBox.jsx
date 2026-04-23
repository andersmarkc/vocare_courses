import React from 'react'
import RichHtml from './RichHtml'

// Speech-bubble styled callout. On lg+ the tail points right toward the main
// content column; on mobile the tail points down (boxes stack above lessons).
export default function FactaBox({ title, body }) {
  return (
    <div className="relative bg-surface border border-accent/30 rounded-2xl p-5 shadow-[0_1px_0_0_rgba(229,160,75,0.08)]">
      {/* Tail — points toward the section: left on lg+, up on mobile (section is above). */}
      <span
        aria-hidden="true"
        className="hidden lg:block absolute top-6 -left-2 w-3 h-3 rotate-45 bg-surface border-b border-l border-accent/30"
      />
      <span
        aria-hidden="true"
        className="lg:hidden absolute -top-2 left-8 w-3 h-3 rotate-45 bg-surface border-t border-l border-accent/30"
      />

      {title && (
        <p className="text-[0.65rem] font-semibold tracking-[0.22em] text-accent uppercase mb-2">
          {title}
        </p>
      )}
      <RichHtml html={body} className="text-sm text-text-secondary" />
    </div>
  )
}
