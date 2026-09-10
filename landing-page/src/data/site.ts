import {
  Accessibility,
  Armchair,
  CloudRain,
  Compass,
  Map,
  MapPinPlus,
  MessageSquareHeart,
  PlugZap,
  SearchCheck,
  SlidersHorizontal,
  Sparkles,
  Toilet,
  Wifi,
} from 'lucide-react'

export const siteLinks = {
  survey: 'https://example.com/findmyspot-umfrage',
  contact: 'mailto:findmyspot@example.com',
  imprint: '#footer',
  privacy: '#footer',
} as const

export const navigation = [
  { label: 'Idee', href: '#idee' },
  { label: 'Funktionen', href: '#funktionen' },
  { label: 'Projekt', href: '#projekt' },
  { label: 'Team', href: '#team' },
] as const

export const questions = [
  { text: 'Wo kann ich in Ruhe lernen?', icon: Sparkles },
  { text: 'Wo finde ich WLAN oder eine Steckdose?', icon: Wifi },
  { text: 'Wo kann ich wettergeschützt warten?', icon: CloudRain },
  { text: 'Welcher Ort ist barrierefrei?', icon: Accessibility },
] as const

export const steps = [
  {
    title: 'Bedürfnis auswählen',
    description: 'Wähle aus, was dir gerade wichtig ist – etwa Ruhe, WLAN oder Wetterschutz.',
    icon: SlidersHorizontal,
  },
  {
    title: 'Passende Orte entdecken',
    description: 'Sieh auf der Karte, welche öffentlichen Orte zu deinen Filtern passen.',
    icon: Compass,
  },
  {
    title: 'Informieren und losgehen',
    description: 'Prüfe die wichtigsten Details und entscheide, welcher Spot für dich stimmt.',
    icon: SearchCheck,
  },
] as const

export const features = [
  { title: 'Interaktive Karte', description: 'Spots übersichtlich in der Umgebung entdecken.', icon: Map },
  { title: 'Filter nach Bedürfnissen', description: 'Nur Orte sehen, die zur Situation passen.', icon: SlidersHorizontal },
  { title: 'Ruhe & Sitzgelegenheiten', description: 'Geeignete Plätze zum Lernen oder Verweilen finden.', icon: Armchair },
  { title: 'WLAN & Steckdosen', description: 'Digitale Infrastruktur auf einen Blick erkennen.', icon: PlugZap },
  { title: 'WC & Wetterschutz', description: 'Praktische Ausstattungsmerkmale gezielt berücksichtigen.', icon: Toilet },
  { title: 'Barrierefreiheit', description: 'Zugängliche Orte einfacher identifizieren.', icon: Accessibility },
  { title: 'Orte melden', description: 'Neue öffentliche Spots für die Karte vorschlagen.', icon: MapPinPlus },
  { title: 'Orte bewerten', description: 'Erfahrungen teilen und Informationen verbessern.', icon: MessageSquareHeart },
] as const

export const team = [
  { name: 'Josia Schweizer', photo: '/josiaschweizer.jpg' },
  { name: 'Janik Janesch', photo: '/janikjanesch.png' },
  { name: 'Ben Lämmlin', photo: '/benlaemmlin.jpeg' },
] as const
