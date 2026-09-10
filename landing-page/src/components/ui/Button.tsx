import { ArrowUpRight } from 'lucide-react'
import type { AnchorHTMLAttributes, ReactNode } from 'react'

type ButtonVariant = 'primary' | 'secondary' | 'light'

type ButtonProps = AnchorHTMLAttributes<HTMLAnchorElement> & {
  children: ReactNode
  variant?: ButtonVariant
  showArrow?: boolean
}

const variants: Record<ButtonVariant, string> = {
  primary: 'bg-[var(--color-brand-900)] text-white hover:bg-[var(--color-brand-950)]',
  secondary:
    'border border-[var(--color-line)] bg-white text-[var(--color-ink)] hover:border-[var(--color-brand-800)]',
  light: 'bg-[var(--color-lime)] text-[var(--color-brand-950)] hover:bg-[#d5f43d]',
}

export function Button({
  children,
  className = '',
  variant = 'primary',
  showArrow = false,
  ...props
}: ButtonProps) {
  return (
    <a
      className={`inline-flex min-h-12 items-center justify-center gap-2 rounded-xl px-6 py-3 text-sm font-bold transition duration-200 ${variants[variant]} ${className}`}
      {...props}
    >
      {children}
      {showArrow && <ArrowUpRight aria-hidden="true" size={17} strokeWidth={2.4} />}
    </a>
  )
}
