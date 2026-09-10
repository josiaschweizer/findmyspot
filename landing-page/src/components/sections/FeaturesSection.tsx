import { FlaskConical } from 'lucide-react'

import { SectionHeading } from '@/components/ui/SectionHeading'
import { features } from '@/data/site'

export function FeaturesSection() {
  return (
    <section id="funktionen" className="section-padding scroll-mt-18 bg-[var(--color-brand-950)] text-white">
      <div className="section-shell">
        <div className="flex flex-col gap-7 lg:flex-row lg:items-end lg:justify-between">
          <SectionHeading
            eyebrow="Geplanter Prototyp"
            title="Geplante Funktionen des Prototyps"
            description="Diese Bestandteile werden für den Prototyp untersucht und schrittweise erprobt."
            inverse
          />
          <div className="flex w-fit items-center gap-2 rounded-full border border-white/15 bg-white/8 px-4 py-2 text-xs font-bold text-white/80">
            <FlaskConical aria-hidden="true" size={16} className="text-[var(--color-lime)]" />
            In Planung & Erprobung
          </div>
        </div>
        <div className="mt-14 grid gap-3 sm:grid-cols-2 lg:grid-cols-4">
          {features.map(({ title, description, icon: Icon }) => (
            <article
              key={title}
              className="border-t border-white/15 py-6 transition hover:border-[var(--color-lime)]/50"
            >
              <div className="grid h-11 w-11 place-items-center rounded-xl bg-[var(--color-lime)]/12 text-[var(--color-lime)]">
                <Icon aria-hidden="true" size={21} />
              </div>
              <h3 className="mt-6 font-extrabold">{title}</h3>
              <p className="mt-2 text-sm leading-6 text-white/60">{description}</p>
            </article>
          ))}
        </div>
      </div>
    </section>
  )
}
