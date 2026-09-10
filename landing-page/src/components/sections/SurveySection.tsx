import { SurveyButton } from '@/components/ui/SurveyButton'

export function SurveySection() {
  return (
    <section className="px-4 pb-4 sm:pb-6">
      <div className="mx-auto max-w-6xl overflow-hidden rounded-[2rem] bg-[var(--color-brand-900)] px-6 py-14 text-center text-white sm:px-12 sm:py-18">
        <div className="mx-auto max-w-2xl">
          <span className="text-xs font-extrabold tracking-[0.14em] text-[var(--color-lime)] uppercase">
            Deine Meinung zählt
          </span>
          <h2 className="mt-4 text-3xl font-extrabold tracking-[-0.04em] sm:text-5xl">
            Hilf uns, FindMySpot besser zu machen.
          </h2>
          <p className="mx-auto mt-5 max-w-xl leading-7 text-white/70 sm:text-lg">
            Mit deiner Teilnahme an unserer Umfrage hilfst du uns herauszufinden, welche Anforderungen an
            öffentliche Aufenthaltsorte besonders wichtig sind.
          </p>
          <SurveyButton variant="light" className="mt-8" />
        </div>
      </div>
    </section>
  )
}
