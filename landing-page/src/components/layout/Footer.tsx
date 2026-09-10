import appIcon from '@/assets/app-icon.png'
import { siteLinks } from '@/data/site'

export function Footer() {
  return (
    <footer id="footer" className="bg-[#082f2b] text-white">
      <div className="section-shell py-10 sm:py-12">
        <div className="flex flex-col gap-8 border-b border-white/10 pb-8 sm:flex-row sm:items-center sm:justify-between">
          <a href="#top" className="flex items-center gap-3 rounded-lg" aria-label="Zurück zum Seitenanfang">
            <img src={appIcon} alt="" className="h-11 w-11 rounded-xl" />
            <div>
              <span className="block font-extrabold">FindMySpot</span>
              <span className="text-sm text-white/55">Vertiefungsarbeit 2026</span>
            </div>
          </a>
          <nav
            className="flex flex-wrap gap-x-6 gap-y-3 text-sm font-semibold text-white/70"
            aria-label="Fussnavigation"
          >
            <a href="#projekt" className="hover:text-white">
              Projekt
            </a>
            <a href="#team" className="hover:text-white">
              Team
            </a>
            <a href={siteLinks.contact} className="hover:text-white">
              Kontakt
            </a>
            <a href={siteLinks.imprint} className="hover:text-white">
              Impressum (folgt)
            </a>
            <a href={siteLinks.privacy} className="hover:text-white">
              Datenschutz (folgt)
            </a>
          </nav>
        </div>
        <div className="flex flex-col gap-2 pt-6 text-sm text-white/50 sm:flex-row sm:justify-between">
          <p>GBS St. Gallen</p>
          <p>Ein Prototyp im Rahmen einer Vertiefungsarbeit.</p>
        </div>
      </div>
    </footer>
  )
}
