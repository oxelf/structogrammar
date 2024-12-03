// components/about_section.tsx
"use client"

export function AboutSection() {
    return (
        <section className="py-12 ">
            <div className="container mx-auto px-6 lg:px-20">
                <h2 className="text-3xl md:text-4xl font-extrabold text-gray-900 dark:text-white text-center">
                    Motivation
                </h2>
                <p className="mt-4 text-lg text-gray-700 dark:text-gray-300">
                    Es gibt viele verschiedene Struktogramm Editoren, jedoch
                    sind die meisten entweder veraltet oder nur auf Windows verfügbar.
                    Das brachte mich dazu, einen Web Editor zu entwickeln
                    der alle Features hat die ich mir von anderen Editoren auch wünschen würde.
                </p>
            </div>
        </section>
    )
}