import { questions } from '@/data/site'
import { SectionHeading } from '@/components/ui/SectionHeading'

export function ProblemSection() {
  return (
    <section id="idee" className="section-padding bg-[var(--color-surface-alt)] scroll-mt-18">
      <div className="section-shell grid gap-12 lg:grid-cols-[0.9fr_1.1fr] lg:items-end">
        <SectionHeading
          eyebrow="Die Idee"
          title="Mehr als nur ein Punkt auf der Karte"
          description="Öffentliche Orte sind zwar vorhanden, doch bestehende Kartendienste zeigen hauptsächlich, wo sie liegen – nicht, wofür sie geeignet sind."
        />
        <div className="grid overflow-hidden rounded-2xl border border-[var(--color-line)] bg-white sm:grid-cols-2">
          {questions.map(({ text, icon: Icon }) => (
            <article
              key={text}
              className="border-b border-[var(--color-line)] p-5 last:border-b-0 sm:[&:nth-child(odd)]:border-r sm:[&:nth-last-child(-n+2)]:border-b-0"
            >
              <div className="grid h-10 w-10 place-items-center rounded-xl bg-[var(--color-lime-soft)] text-[var(--color-brand-950)]">
                <Icon aria-hidden="true" size={20} strokeWidth={2.25} />
              </div>
              <p className="mt-4 font-bold leading-6 text-[var(--color-brand-950)]">{text}</p>
            </article>
          ))}
        </div>
      </div>
    </section>
  )
}
