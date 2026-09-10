import { Menu, X } from 'lucide-react'
import { useEffect, useState } from 'react'

import appIcon from '@/assets/app-icon.png'
import { SurveyButton } from '@/components/ui/SurveyButton'
import { navigation } from '@/data/site'

export function Header() {
  const [isOpen, setIsOpen] = useState(false)

  useEffect(() => {
    const closeOnEscape = (event: KeyboardEvent) => {
      if (event.key === 'Escape') setIsOpen(false)
    }
    window.addEventListener('keydown', closeOnEscape)
    return () => window.removeEventListener('keydown', closeOnEscape)
  }, [])

  return (
    <header className="sticky top-0 z-50 border-b border-white/50 bg-[rgba(251,253,249,0.88)] backdrop-blur-xl">
      <nav className="section-shell flex h-18 items-center justify-between" aria-label="Hauptnavigation">
        <a href="#top" className="flex items-center gap-2.5 rounded-lg" aria-label="FindMySpot – Startseite">
          <img src={appIcon} alt="" className="h-10 w-10 rounded-[11px] shadow-sm" />
          <span className="text-lg font-extrabold tracking-[-0.03em]">FindMySpot</span>
        </a>

        <div className="hidden items-center gap-7 md:flex">
          {navigation.map((item) => (
            <a
              key={item.href}
              href={item.href}
              className="text-sm font-semibold text-[var(--color-muted)] transition hover:text-[var(--color-brand-900)]"
            >
              {item.label}
            </a>
          ))}
          <SurveyButton compact />
        </div>

        <button
          type="button"
          className="grid h-11 w-11 place-items-center rounded-full border border-[var(--color-line)] bg-white md:hidden"
          aria-label={isOpen ? 'Menü schliessen' : 'Menü öffnen'}
          aria-expanded={isOpen}
          aria-controls="mobile-navigation"
          onClick={() => setIsOpen((open) => !open)}
        >
          {isOpen ? <X aria-hidden="true" size={20} /> : <Menu aria-hidden="true" size={20} />}
        </button>
      </nav>

      {isOpen && (
        <div
          id="mobile-navigation"
          className="border-t border-[var(--color-line)] bg-[var(--color-surface)] px-4 pt-3 pb-5 md:hidden"
        >
          <div className="mx-auto flex max-w-2xl flex-col gap-1">
            {navigation.map((item) => (
              <a
                key={item.href}
                href={item.href}
                onClick={() => setIsOpen(false)}
                className="rounded-xl px-4 py-3 text-base font-semibold hover:bg-[var(--color-surface-alt)]"
              >
                {item.label}
              </a>
            ))}
            <SurveyButton className="mt-2 w-full" />
          </div>
        </div>
      )}
    </header>
  )
}
