import { Armchair, Coffee, MapPin, Navigation, Search, Trees } from 'lucide-react'

const markers = [
  { top: '35%', left: '22%', active: false },
  { top: '24%', left: '69%', active: false },
  { top: '53%', left: '56%', active: true },
  { top: '66%', left: '30%', active: false },
] as const

export function MapPreview() {
  return (
    <div
      className="relative mx-auto w-full max-w-[28rem]"
      role="img"
      aria-label="Konzeptionelle Vorschau der FindMySpot App mit Karte, Filtern und Ortsinformationen"
    >
      <div className="relative mx-auto w-[min(84vw,22rem)] rounded-[2.7rem] border-[7px] border-[#103b36] bg-[#103b36] p-1.5 shadow-[0_20px_50px_rgba(0,63,56,0.18)]">
        <div className="overflow-hidden rounded-[2.35rem] bg-[#eef5ef]">
          <div className="flex h-7 items-center justify-center bg-white/90">
            <span className="h-1.5 w-16 rounded-full bg-[#123d38]" />
          </div>
          <div className="relative h-[31rem] overflow-hidden">
            <div className="map-grid absolute inset-0" />
            <div className="absolute -left-16 top-26 h-20 w-80 rotate-12 rounded-full border-[13px] border-white/85" />
            <div className="absolute -right-20 top-61 h-20 w-80 -rotate-12 rounded-full border-[13px] border-white/90" />
            <div className="route-line" />

            <div className="absolute inset-x-4 top-4 z-20 flex h-11 items-center gap-3 rounded-2xl bg-white px-4 shadow-lg shadow-emerald-950/10">
              <Search aria-hidden="true" size={17} className="text-[var(--color-brand-800)]" />
              <span className="text-xs font-semibold text-[var(--color-muted)]">Ort oder Bedürfnis suchen</span>
            </div>

            <div className="absolute inset-x-4 top-18 z-20 flex gap-2 overflow-hidden">
              {['Ruhig', 'WLAN', 'Steckdosen'].map((filter, index) => (
                <span key={filter} className={`shrink-0 rounded-full px-3 py-1.5 text-[11px] font-bold shadow-sm ${index === 0 ? 'bg-[var(--color-brand-900)] text-white' : 'bg-white text-[var(--color-ink)]'}`}>
                  {filter}
                </span>
              ))}
            </div>

            {markers.map((marker, index) => (
              <div key={index} className="absolute z-10 -translate-x-1/2 -translate-y-full" style={{ top: marker.top, left: marker.left }}>
                <div className={`grid h-10 w-10 place-items-center rounded-full rounded-bl-md shadow-lg ${marker.active ? 'rotate-[-45deg] bg-[var(--color-lime)] text-[var(--color-brand-950)]' : 'rotate-[-45deg] bg-[var(--color-brand-900)] text-white'}`}>
                  <MapPin aria-hidden="true" size={18} className="rotate-45" />
                </div>
              </div>
            ))}

            <div className="absolute bottom-4 left-4 right-4 z-20 rounded-2xl bg-white p-3 shadow-xl shadow-emerald-950/15">
              <div className="flex items-start gap-3">
                <div className="grid h-14 w-14 shrink-0 place-items-center rounded-xl bg-[var(--color-lime-soft)] text-[var(--color-brand-900)]">
                  <Trees aria-hidden="true" size={24} />
                </div>
                <div className="min-w-0 flex-1">
                  <div className="flex items-center justify-between gap-2">
                    <p className="truncate text-sm font-extrabold">Stadtpark Lernspot</p>
                    <span className="rounded-full bg-[var(--color-surface-alt)] px-2 py-1 text-[9px] font-bold text-[var(--color-brand-800)]">Vorschau</span>
                  </div>
                  <p className="mt-1 text-[11px] text-[var(--color-muted)]">Ruhig · 6 Min. entfernt</p>
                  <div className="mt-2 flex gap-3 text-[var(--color-brand-800)]">
                    <Coffee aria-hidden="true" size={14} />
                    <Armchair aria-hidden="true" size={14} />
                    <Navigation aria-hidden="true" size={14} />
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}
