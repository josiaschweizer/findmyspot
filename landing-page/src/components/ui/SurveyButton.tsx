import { Clock3 } from 'lucide-react'

type SurveyButtonProps = {
  className?: string
  compact?: boolean
  showHint?: boolean
  variant?: 'primary' | 'secondary' | 'light'
}

const variants = {
  primary: 'bg-[var(--color-brand-900)] text-white',
  secondary: 'border border-[var(--color-line)] bg-white text-[var(--color-ink)]',
  light: 'bg-[var(--color-lime)] text-[var(--color-brand-950)]',
} as const

export function SurveyButton({
  className = '',
  compact = false,
  showHint = false,
  variant = 'primary',
}: SurveyButtonProps) {
  return (
    <span className={`inline-flex flex-col items-start ${className}`}>
      <button
        type="button"
        disabled
        title="Die Umfrage wird bald verfügbar sein"
        aria-label="Umfrage – bald verfügbar"
        className={`inline-flex cursor-not-allowed items-center justify-center gap-2 rounded-xl font-bold opacity-70 ${variants[variant]} ${compact ? 'min-h-10 px-4 py-2 text-xs' : 'min-h-12 px-6 py-3 text-sm'}`}
      >
        <Clock3 aria-hidden="true" size={compact ? 14 : 16} />
        {compact ? 'Umfrage · bald' : 'An Umfrage teilnehmen'}
      </button>
      {showHint && (
        <span
          className={`mt-2 px-1 text-xs font-medium ${variant === 'light' ? 'text-white/70' : 'text-[var(--color-muted)]'}`}
        >
          Die Umfrage wird bald verfügbar sein.
        </span>
      )}
    </span>
  )
}
