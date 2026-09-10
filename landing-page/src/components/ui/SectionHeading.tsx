type SectionHeadingProps = {
  eyebrow: string
  title: string
  description?: string
  align?: 'left' | 'center'
  inverse?: boolean
}

export function SectionHeading({
  eyebrow,
  title,
  description,
  align = 'left',
  inverse = false,
}: SectionHeadingProps) {
  const centered = align === 'center'

  return (
    <div className={centered ? 'mx-auto max-w-2xl text-center' : 'max-w-2xl'}>
      <span className={`eyebrow ${inverse ? '!text-[var(--color-lime)]' : ''}`}>{eyebrow}</span>
      <h2
        className={`mt-4 text-3xl font-bold tracking-[-0.035em] sm:text-4xl lg:text-[2.75rem] lg:leading-[1.08] ${inverse ? 'text-white' : ''}`}
      >
        {title}
      </h2>
      {description && (
        <p
          className={`mt-5 text-base leading-7 sm:text-lg ${inverse ? 'text-white/70' : 'text-[var(--color-muted)]'}`}
        >
          {description}
        </p>
      )}
    </div>
  )
}
