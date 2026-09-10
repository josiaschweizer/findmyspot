import { Button } from '@/components/ui/Button'
import { SurveyButton } from '@/components/ui/SurveyButton'

import { MapPreview } from './MapPreview'

export function HeroSection() {
  return (
    <section
      id="top"
      className="relative overflow-hidden border-b border-[var(--color-line)] pt-14 pb-20 sm:pt-20 lg:pt-22 lg:pb-24"
    >
      <div className="section-shell relative grid items-center gap-16 lg:grid-cols-[1.05fr_0.95fr] lg:gap-10">
        <div>
          <p className="flex items-center gap-2 text-sm font-semibold text-[var(--color-brand-800)]">
            <span className="h-2 w-2 rounded-full bg-[var(--color-lime)]" aria-hidden="true" />
            Vertiefungsarbeit 2026 · GBS St. Gallen
          </p>
          <h1 className="mt-6 max-w-3xl text-[clamp(2.7rem,6vw,4.8rem)] leading-[1.02] font-extrabold tracking-[-0.045em] text-[var(--color-brand-950)]">
            Finde den Ort, der gerade zu dir passt.
          </h1>
          <p className="mt-7 max-w-2xl text-lg leading-8 text-[var(--color-muted)] sm:text-xl sm:leading-relaxed">
            FindMySpot hilft dir, öffentliche und kostenlos zugängliche Orte anhand deiner aktuellen
            Bedürfnisse zu entdecken – zum Lernen, Warten, Treffen oder Entspannen.
          </p>
          <div className="mt-9 flex flex-col gap-3 sm:flex-row sm:items-center">
            <Button href="#idee">Projekt entdecken</Button>
            <SurveyButton variant="secondary" showHint />
          </div>
        </div>
        <MapPreview />
      </div>
    </section>
  )
}
