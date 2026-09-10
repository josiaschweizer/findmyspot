import { steps } from '@/data/site'
import { SectionHeading } from '@/components/ui/SectionHeading'

export function HowItWorksSection() {
  return (
    <section className="section-padding">
      <div className="section-shell">
        <SectionHeading eyebrow="So funktioniert’s" title="In drei Schritten zum passenden Spot" align="center" />
        <ol className="mt-14 grid gap-5 md:grid-cols-3">
          {steps.map(({ title, description, icon: Icon }, index) => (
            <li key={title} className="relative border-t-2 border-[var(--color-brand-900)] bg-white py-7 pr-5">
              <span className="absolute right-6 top-5 text-5xl font-black text-[#dce8df]">0{index + 1}</span>
              <div className="grid h-12 w-12 place-items-center rounded-2xl bg-[var(--color-lime-soft)] text-[var(--color-brand-900)]">
                <Icon aria-hidden="true" size={23} />
              </div>
              <h3 className="mt-7 text-xl font-extrabold tracking-tight">{title}</h3>
              <p className="mt-3 font-medium leading-7 text-[#3f5b54]">{description}</p>
            </li>
          ))}
        </ol>
      </div>
    </section>
  )
}
