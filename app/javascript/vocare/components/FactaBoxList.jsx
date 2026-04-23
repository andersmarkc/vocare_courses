import React from 'react'
import FactaBox from './FactaBox'

export default function FactaBoxList({ boxes }) {
  if (!boxes || boxes.length === 0) return null
  return (
    <aside className="space-y-5">
      {boxes.map((box) => (
        <FactaBox key={box.id} title={box.title} body={box.body} />
      ))}
    </aside>
  )
}
