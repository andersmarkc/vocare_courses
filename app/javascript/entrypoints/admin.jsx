import { mountRichEditors } from '../vocare/admin/mountRichEditors.js'
import './admin.css'

function init() {
  mountRichEditors()
}

if (document.readyState === 'loading') {
  document.addEventListener('DOMContentLoaded', init)
} else {
  init()
}

document.addEventListener('turbo:load', init)
