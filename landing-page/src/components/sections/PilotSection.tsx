import { MapPin, Navigation, Trees } from 'lucide-react'

import { SectionHeading } from '@/components/ui/SectionHeading'

export function PilotSection() {
  return (
    <section className="section-padding">
      <div className="section-shell grid items-center gap-12 lg:grid-cols-2 lg:gap-20">
        <div className="map-grid relative min-h-[25rem] overflow-hidden rounded-[2rem] bg-[var(--color-surface-alt)] shadow-[inset_0_0_0_1px_var(--color-line)]">
          <div className="absolute top-[20%] left-[-5%] h-24 w-[75%] rotate-[18deg] rounded-full border-[18px] border-white" />
          <div className="absolute right-[-12%] bottom-[18%] h-24 w-[85%] -rotate-[15deg] rounded-full border-[18px] border-white" />
          <div className="absolute top-[13%] left-[15%] h-32 w-32 rounded-full bg-[var(--color-lime-soft)]/80" />
          <div className="absolute right-[8%] bottom-[8%] h-40 w-40 rounded-full bg-[var(--color-leaf)]/12" />
          <div className="absolute top-[49%] left-[51%] -translate-x-1/2 -translate-y-1/2">
            <div className="grid h-20 w-20 rotate-[-45deg] place-items-center rounded-full rounded-bl-2xl bg-[var(--color-brand-900)] text-white shadow-2xl">
              <MapPin aria-hidden="true" size={34} className="rotate-45" />
            </div>
          </div>
          <div className="absolute right-5 bottom-5 left-5 flex items-center gap-3 rounded-2xl bg-white/92 p-4 shadow-xl backdrop-blur">
            <div className="grid h-11 w-11 place-items-center rounded-xl bg-[var(--color-lime-soft)] text-[var(--color-brand-900)]">
              <Trees aria-hidden="true" size={21} />
            </div>
            <div className="min-w-0 flex-1">
              <p className="font-extrabold">St. Gallen</p>
              <p className="text-sm text-[var(--color-muted)]">Abgegrenztes Pilotgebiet</p>
            </div>
            <Navigation aria-hidden="true" size={19} className="text-[var(--color-leaf)]" />
          </div>
        </div>
        <SectionHeading
          eyebrow="Pilotgebiet"
          title="Unser Pilotgebiet: St. Gallen"
          description="Im Rahmen unserer Vertiefungsarbeit testen wir FindMySpot zunächst in einem abgegrenzten Gebiet der Stadt St. Gallen. So können wir Erkenntnisse gezielt sammeln und das Konzept unter realistischen Bedingungen erproben."
        />
      </div>
    </section>
  )
}
