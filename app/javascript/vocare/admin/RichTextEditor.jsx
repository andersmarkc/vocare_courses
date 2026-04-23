import React, { useEffect, useCallback } from 'react'
import { useEditor, EditorContent } from '@tiptap/react'
import StarterKit from '@tiptap/starter-kit'
import Underline from '@tiptap/extension-underline'
import Link from '@tiptap/extension-link'

const BUTTON_BASE =
  'px-2 py-1 text-xs font-medium rounded-md border border-transparent text-gray-500 hover:bg-gray-100 hover:text-gray-900 transition-colors'
const BUTTON_ACTIVE =
  'px-2 py-1 text-xs font-medium rounded-md border border-gray-900 text-gray-900 bg-gray-100 transition-colors'

function ToolbarButton({ editor, label, onClick, active }) {
  return (
    <button
      type="button"
      tabIndex={-1}
      onMouseDown={(e) => e.preventDefault()}
      onClick={onClick}
      className={active ? BUTTON_ACTIVE : BUTTON_BASE}
    >
      {label}
    </button>
  )
}

function Divider() {
  return <span className="mx-1 h-5 w-px bg-gray-200 self-center" aria-hidden="true" />
}

export default function RichTextEditor({ initialHTML, onChange }) {
  const editor = useEditor({
    extensions: [
      StarterKit.configure({
        heading: { levels: [2, 3, 4] },
      }),
      Underline,
      Link.configure({
        openOnClick: false,
        autolink: true,
        linkOnPaste: true,
        HTMLAttributes: { rel: 'noopener nofollow', target: '_blank' },
      }),
    ],
    content: initialHTML || '',
    onUpdate: ({ editor }) => {
      const html = editor.isEmpty ? '' : editor.getHTML()
      onChange(html)
    },
    editorProps: {
      attributes: {
        class: 'rich-html outline-none px-4 py-3 min-h-[10rem]',
      },
    },
  })

  useEffect(() => {
    return () => editor?.destroy()
  }, [editor])

  const toggleLink = useCallback(() => {
    if (!editor) return
    const previous = editor.getAttributes('link').href
    const url = window.prompt('URL', previous || 'https://')
    if (url === null) return
    if (url === '') {
      editor.chain().focus().extendMarkRange('link').unsetLink().run()
      return
    }
    editor.chain().focus().extendMarkRange('link').setLink({ href: url }).run()
  }, [editor])

  if (!editor) return null

  return (
    <>
      <div className="flex flex-wrap gap-1 px-3 py-2 border-b border-gray-100">
        <ToolbarButton editor={editor} label="B" onClick={() => editor.chain().focus().toggleBold().run()} active={editor.isActive('bold')} />
        <ToolbarButton editor={editor} label="I" onClick={() => editor.chain().focus().toggleItalic().run()} active={editor.isActive('italic')} />
        <ToolbarButton editor={editor} label="U" onClick={() => editor.chain().focus().toggleUnderline().run()} active={editor.isActive('underline')} />
        <Divider />
        <ToolbarButton editor={editor} label="H2" onClick={() => editor.chain().focus().toggleHeading({ level: 2 }).run()} active={editor.isActive('heading', { level: 2 })} />
        <ToolbarButton editor={editor} label="H3" onClick={() => editor.chain().focus().toggleHeading({ level: 3 }).run()} active={editor.isActive('heading', { level: 3 })} />
        <Divider />
        <ToolbarButton editor={editor} label="• Liste" onClick={() => editor.chain().focus().toggleBulletList().run()} active={editor.isActive('bulletList')} />
        <ToolbarButton editor={editor} label="1. Liste" onClick={() => editor.chain().focus().toggleOrderedList().run()} active={editor.isActive('orderedList')} />
        <ToolbarButton editor={editor} label="„Citat“" onClick={() => editor.chain().focus().toggleBlockquote().run()} active={editor.isActive('blockquote')} />
        <Divider />
        <ToolbarButton editor={editor} label="Link" onClick={toggleLink} active={editor.isActive('link')} />
        <Divider />
        <ToolbarButton editor={editor} label="↶" onClick={() => editor.chain().focus().undo().run()} />
        <ToolbarButton editor={editor} label="↷" onClick={() => editor.chain().focus().redo().run()} />
      </div>
      <EditorContent editor={editor} />
    </>
  )
}
