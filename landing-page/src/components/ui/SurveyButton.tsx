import { ArrowUpRight } from 'lucide-react'

import { siteLinks } from '@/data/site'

type SurveyButtonProps = {
  className?: string
  compact?: boolean
  variant?: 'primary' | 'secondary' | 'light'
}

const variants = {
  primary: 'bg-[var(--color-brand-900)] text-white',
  secondary: 'border border-[var(--color-line)] bg-white text-[var(--color-ink)]',
  light: 'bg-[var(--color-lime)] text-[var(--color-brand-950)]',
} as const

export function SurveyButton({ className = '', compact = false, variant = 'primary' }: SurveyButtonProps) {
  return (
    <a
      href={siteLinks.survey}
      target="_blank"
      rel="noreferrer"
      className={`inline-flex items-center justify-center gap-2 rounded-xl font-bold transition hover:-translate-y-0.5 ${variants[variant]} ${compact ? 'min-h-10 px-4 py-2 text-xs' : 'min-h-12 px-6 py-3 text-sm'} ${className}`}
    >
      {compact ? 'Umfrage' : 'An Umfrage teilnehmen'}
      <ArrowUpRight aria-hidden="true" size={compact ? 14 : 16} />
    </a>
  )
}
