import React from 'react'
import { createRoot } from 'react-dom/client'
import RichTextEditor from './RichTextEditor.jsx'

const MOUNTED = new WeakSet()

function mountOne(shell) {
  if (MOUNTED.has(shell)) return
  const textareaId = shell.dataset.textareaId
  const textarea = textareaId ? document.getElementById(textareaId) : null
  if (!textarea) return

  // Clear placeholder children from the HAML partial — React owns the shell now.
  shell.innerHTML = ''

  const root = createRoot(shell)
  root.render(
    React.createElement(RichTextEditor, {
      initialHTML: textarea.value || '',
      onChange: (html) => {
        textarea.value = html
        textarea.dispatchEvent(new Event('input', { bubbles: true }))
      },
    })
  )

  MOUNTED.add(shell)
}

export function mountRichEditors(root = document) {
  root.querySelectorAll('[data-rich-editor]').forEach(mountOne)
}
