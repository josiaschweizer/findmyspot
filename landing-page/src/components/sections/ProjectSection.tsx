import { ClipboardList, MessagesSquare, MousePointerClick } from 'lucide-react'
import { SectionHeading } from '@/components/ui/SectionHeading'

const methods = [
  { label: 'Umfrage', icon: ClipboardList },
  { label: 'Interviews', icon: MessagesSquare },
  { label: 'Usability-Tests', icon: MousePointerClick },
] as const

export function ProjectSection() {
  return (
    <section id="projekt" className="section-padding scroll-mt-18 bg-[var(--color-surface-alt)]">
      <div className="section-shell">
        <SectionHeading
          eyebrow="Das Projekt"
          title="FindMySpot als Vertiefungsarbeit"
          description="FindMySpot entsteht im vierten Lehrjahr der Ausbildung zum Informatiker Applikationsentwicklung an der GBS St. Gallen. Der aktuelle Stand ist ein Prototyp – keine bereits veröffentlichte App."
        />

        <div className="mt-12 grid border-y border-[var(--color-line)] bg-white lg:grid-cols-[0.8fr_1.2fr]">
          <div className="p-6 sm:p-8 lg:border-r lg:border-[var(--color-line)] lg:p-10">
            <p className="text-xs font-extrabold uppercase tracking-[0.1em] text-[var(--color-brand-800)]">
              Unsere Projektfrage
            </p>
            <p className="mt-3 text-3xl font-extrabold tracking-[-0.035em] text-[var(--color-brand-950)] sm:text-4xl">
              Wo ist ein Ort?
            </p>
          </div>

          <div className="border-t border-[var(--color-line)] p-6 sm:p-8 lg:border-t-0 lg:p-10">
            <p className="max-w-2xl font-medium leading-7 text-[#3f5b54]">
              Mit einer Umfrage, Interviews und Usability-Tests untersuchen wir, welche Informationen über öffentliche Aufenthaltsorte tatsächlich benötigt werden und wie sie verständlich zugänglich gemacht werden können.
            </p>
            <ul className="mt-7 flex flex-wrap gap-x-7 gap-y-4" aria-label="Untersuchungsmethoden">
              {methods.map(({ label, icon: Icon }) => (
                <li key={label} className="flex items-center gap-2.5 text-sm font-bold text-[var(--color-brand-950)]">
                  <Icon aria-hidden="true" size={18} className="text-[var(--color-leaf)]" />
                  {label}
                </li>
              ))}
            </ul>
          </div>
        </div>
      </div>
    </section>
  )
}
