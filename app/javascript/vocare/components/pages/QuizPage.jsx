import React, { useState, useEffect, useRef, useCallback } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import useApi from '../../hooks/useApi'
import useAuth from '../../hooks/useAuth'
import { SpinnerIcon, CheckCircleIcon, AcademicCapIcon } from '../Icons'

function QuestionInput({ question, value, onChange, disabled }) {
  return (
    <div className="bg-surface rounded-xl border border-white/10 p-6">
      <div className="flex items-start gap-3 mb-4">
        <span className="text-accent font-bold text-lg">{question.position}.</span>
        <p className="text-base font-medium leading-relaxed">{question.question_text}</p>
      </div>
      <textarea
        value={value}
        onChange={(e) => onChange(question.id, e.target.value)}
        disabled={disabled}
        rows={4}
        placeholder="Skriv dit svar her..."
        className="w-full bg-background border border-white/10 rounded-lg px-4 py-3 text-sm text-white placeholder-text-muted focus:outline-none focus:border-accent focus:ring-1 focus:ring-accent transition-colors resize-none disabled:opacity-50"
      />
    </div>
  )
}

function AnswerResult({ answer }) {
  return (
    <div className={`rounded-xl border p-6 ${answer.passed ? 'bg-success/5 border-success/20' : 'bg-error/5 border-error/20'}`}>
      <div className="flex items-start justify-between mb-3">
        <p className="font-medium">{answer.question_text}</p>
        <span className={`text-sm font-bold px-2 py-1 rounded ${answer.passed ? 'bg-success/20 text-success' : 'bg-error/20 text-error'}`}>
          {answer.ai_score}/100
        </span>
      </div>
      <div className="text-sm text-text-secondary mb-3">
        <span className="text-text-muted">Dit svar: </span>
        {answer.student_answer}
      </div>
      {answer.ai_evaluation && (
        <div className="text-sm text-text-secondary border-t border-white/5 pt-3 mt-3">
          <span className="text-accent text-xs font-semibold uppercase tracking-wider">AI feedback</span>
          <p className="mt-1">{answer.ai_evaluation}</p>
        </div>
      )}
    </div>
  )
}

export default function QuizPage() {
  const { id, attemptId } = useParams()
  const navigate = useNavigate()
  const { request } = useApi()
  const { refreshProgress } = useAuth()

  const [quiz, setQuiz] = useState(null)
  const [questions, setQuestions] = useState([])
  const [answers, setAnswers] = useState({})
  const [attempt, setAttempt] = useState(null)
  const [attemptAnswers, setAttemptAnswers] = useState([])
  const [submitting, setSubmitting] = useState(false)
  const [evaluating, setEvaluating] = useState(false)
  const [error, setError] = useState(null)
  const pollRef = useRef(null)

  // Load quiz
  useEffect(() => {
    if (attemptId) {
      // Load existing attempt results
      request(`/api/v1/quiz_attempts/${attemptId}`)
        .then((data) => {
          setAttempt(data.attempt)
          setAttemptAnswers(data.answers)
          if (!data.attempt.completed_at) setEvaluating(true)
        })
        .catch((err) => setError(err.message))
    }

    request(`/api/v1/quizzes/${id}`)
      .then((data) => {
        setQuiz(data.quiz)
        setQuestions(data.questions)
      })
      .catch((err) => setError(err.message))
  }, [request, id, attemptId])

  // Poll for evaluation results
  const pollForResults = useCallback((attId) => {
    pollRef.current = setInterval(async () => {
      try {
        const data = await request(`/api/v1/quiz_attempts/${attId}`)
        if (data.attempt.completed_at) {
          clearInterval(pollRef.current)
          setAttempt(data.attempt)
          setAttemptAnswers(data.answers)
          setEvaluating(false)
          refreshProgress()
        }
      } catch { /* keep polling */ }
    }, 3000)
  }, [request, refreshProgress])

  useEffect(() => {
    if (evaluating && attempt) {
      pollForResults(attempt.id)
    }
    return () => { if (pollRef.current) clearInterval(pollRef.current) }
  }, [evaluating, attempt, pollForResults])

  const handleAnswerChange = (questionId, value) => {
    setAnswers((prev) => ({ ...prev, [questionId]: value }))
  }

  const handleSubmit = async (e) => {
    e.preventDefault()
    setSubmitting(true)
    setError(null)

    try {
      // Start attempt
      const startData = await request(`/api/v1/quizzes/${id}/attempts`, {
        method: 'POST',
      })
      const attId = startData.attempt.id

      // Submit answers
      const answersPayload = questions.map((q) => ({
        question_id: q.id,
        answer: answers[q.id] || '',
      }))

      const submitData = await request(`/api/v1/quiz_attempts/${attId}`, {
        method: 'PATCH',
        body: JSON.stringify({ answers: answersPayload }),
      })

      setAttempt(submitData.attempt)
      setEvaluating(true)
      setSubmitting(false)
    } catch (err) {
      setError(err.message)
      setSubmitting(false)
    }
  }

  const handleRetry = () => {
    setAttempt(null)
    setAttemptAnswers([])
    setAnswers({})
    setEvaluating(false)
  }

  if (error && !quiz) {
    return (
      <div className="max-w-3xl mx-auto px-6 py-16 text-center">
        <p className="text-error">{error}</p>
      </div>
    )
  }

  if (!quiz) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="animate-pulse text-text-secondary">Indlæser quiz...</div>
      </div>
    )
  }

  // Evaluating state
  if (evaluating) {
    return (
      <div className="max-w-3xl mx-auto px-6 py-16 text-center">
        <SpinnerIcon className="w-12 h-12 text-accent mx-auto mb-6" />
        <h1 className="font-serif text-3xl font-bold mb-3">AI evaluerer dine svar</h1>
        <p className="text-text-secondary">Dette tager normalt 10-20 sekunder...</p>
      </div>
    )
  }

  // Results state
  if (attempt?.completed_at) {
    return (
      <div className="max-w-3xl mx-auto px-6 py-12">
        <div className="text-center mb-10">
          <div className={`inline-flex items-center justify-center w-20 h-20 rounded-full mb-4 ${attempt.passed ? 'bg-success/20' : 'bg-error/20'}`}>
            {attempt.passed
              ? <CheckCircleIcon className="w-10 h-10 text-success" />
              : <AcademicCapIcon className="w-10 h-10 text-error" />
            }
          </div>
          <h1 className="font-serif text-3xl font-bold mb-2">
            {attempt.passed ? 'Tillykke!' : 'Ikke bestået'}
          </h1>
          <p className="text-4xl font-bold mb-2">
            <span className={attempt.passed ? 'text-success' : 'text-error'}>{attempt.score}%</span>
          </p>
          <p className="text-text-secondary">
            {attempt.passed ? 'Du har bestået quizzen' : `Du skal bruge mindst ${quiz.passing_score}% for at bestå`}
          </p>
        </div>

        <div className="space-y-4 mb-10">
          {attemptAnswers.map((answer) => (
            <AnswerResult key={answer.id} answer={answer} />
          ))}
        </div>

        <div className="flex justify-center gap-4">
          {!attempt.passed && (
            <button
              onClick={handleRetry}
              className="bg-accent hover:bg-accent-hover text-black font-semibold rounded-lg px-8 py-3 transition-colors"
            >
              Prøv igen
            </button>
          )}
          <button
            onClick={() => navigate(-1)}
            className="border border-white/20 text-white rounded-lg px-8 py-3 hover:bg-surface-light transition-colors"
          >
            {attempt.passed ? 'Fortsæt' : 'Tilbage til lektion'}
          </button>
        </div>
      </div>
    )
  }

  // Question form state
  const allAnswered = questions.every((q) => answers[q.id]?.trim())

  return (
    <div className="max-w-3xl mx-auto px-6 py-12">
      <div className="text-center mb-10">
        <AcademicCapIcon className="w-10 h-10 text-accent mx-auto mb-4" />
        <h1 className="font-serif text-3xl font-bold mb-2">{quiz.title}</h1>
        {quiz.description && (
          <p className="text-text-secondary">{quiz.description}</p>
        )}
        <p className="text-sm text-text-muted mt-2">
          {questions.length} spørgsmål · Bestå med {quiz.passing_score}%
        </p>
      </div>

      <form onSubmit={handleSubmit} className="space-y-6">
        {questions.map((question) => (
          <QuestionInput
            key={question.id}
            question={question}
            value={answers[question.id] || ''}
            onChange={handleAnswerChange}
            disabled={submitting}
          />
        ))}

        {error && <p className="text-error text-sm text-center">{error}</p>}

        <div className="flex justify-center pt-4">
          <button
            type="submit"
            disabled={!allAnswered || submitting}
            className="bg-accent hover:bg-accent-hover text-black font-semibold rounded-lg px-10 py-4 text-lg transition-colors disabled:opacity-50 disabled:cursor-not-allowed flex items-center gap-2"
          >
            {submitting ? (
              <>
                <SpinnerIcon className="w-5 h-5" />
                Indsender...
              </>
            ) : (
              'Indsend svar'
            )}
          </button>
        </div>
      </form>
    </div>
  )
}
