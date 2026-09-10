import { team } from '@/data/site'
import { SectionHeading } from '@/components/ui/SectionHeading'

export function TeamSection() {
  return (
    <section id="team" className="section-padding scroll-mt-18">
      <div className="section-shell">
        <SectionHeading
          eyebrow="Projektteam"
          title="Wir entwickeln FindMySpot"
          description="Drei Informatiklernende im vierten Lehrjahr an der GBS St. Gallen."
        />
        <div className="mt-12 grid gap-x-5 gap-y-10 sm:grid-cols-3">
          {team.map((member) => (
            <article key={member.name}>
              <img
                src={member.photo}
                alt={`Porträt von ${member.name}`}
                className="aspect-[4/5] w-full rounded-2xl bg-[#e8ece9] object-cover object-top"
              />
              <h3 className="mt-4 text-lg font-extrabold">{member.name}</h3>
            </article>
          ))}
        </div>
      </div>
    </section>
  )
}
