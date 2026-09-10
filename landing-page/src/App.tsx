import { Footer } from '@/components/layout/Footer'
import { Header } from '@/components/layout/Header'
import { FeaturesSection } from '@/components/sections/FeaturesSection'
import { HeroSection } from '@/components/sections/HeroSection'
import { HowItWorksSection } from '@/components/sections/HowItWorksSection'
import { PilotSection } from '@/components/sections/PilotSection'
import { ProblemSection } from '@/components/sections/ProblemSection'
import { ProjectSection } from '@/components/sections/ProjectSection'
import { SurveySection } from '@/components/sections/SurveySection'
import { TeamSection } from '@/components/sections/TeamSection'

function App() {
  return (
    <div className="min-h-screen overflow-x-hidden bg-[var(--color-surface)] text-[var(--color-ink)]">
      <Header />
      <main>
        <HeroSection />
        <ProblemSection />
        <HowItWorksSection />
        <FeaturesSection />
        <PilotSection />
        <ProjectSection />
        <TeamSection />
        <SurveySection />
      </main>
      <Footer />
    </div>
  )
}

export default App
