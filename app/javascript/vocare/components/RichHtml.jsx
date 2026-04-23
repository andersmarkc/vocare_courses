import React from 'react'

// Renders sanitized HTML from the Rails API. The server runs every rich-text
// field through Rails::HTML5::SafeListSanitizer on save, so `html` is the
// single unsafe-by-design surface we intentionally trust.
export default function RichHtml({ html, className = '' }) {
  if (!html) return null
  return (
    <div
      className={`rich-html ${className}`.trim()}
      dangerouslySetInnerHTML={{ __html: html }}
    />
  )
}
