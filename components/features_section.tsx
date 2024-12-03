"use client"

import {ArchiveRestoreIcon, CodeIcon, GaugeIcon, ImportIcon, LayoutTemplateIcon, ShareIcon} from "lucide-react";


export function Features() {
    return (
        <section id="features" className="py-12 ">
            <div className="container mx-auto px-6 lg:px-20">
                <h2 className="text-3xl md:text-4xl font-extrabold text-gray-900 dark:text-white text-center">
                    Features
                </h2>
                <div className="mt-8 grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
                    <div className="p-6 bg-white dark:bg-zinc-800 rounded-lg shadow-lg">
                        <div className="flex gap-4 row-start-1 justify-items-center">
                            <LayoutTemplateIcon></LayoutTemplateIcon>
                            <h3 className="text-xl font-bold text-gray-900 dark:text-white">Alle Blöcke</h3>
                        </div>
                        <p className="mt-2 text-gray-700 dark:text-gray-300">Alle Blöcke sind verfügbar die man von
                            anderen Editoren kennt</p>
                    </div>
                    <div className="p-6 bg-white dark:bg-zinc-800 rounded-lg shadow-lg">
                        <div className="flex gap-4 row-start-1 justify-items-center">
                            <ImportIcon></ImportIcon>
                            <h3 className="text-xl font-bold text-gray-900 dark:text-white">Importiere
                                Struktogramme</h3>
                        </div>
                        <p className="mt-2 text-gray-700 dark:text-gray-300">Importiere aus anderen Programmen wie
                            Strukted32 oder Structorizer</p>
                    </div>
                    <div className="p-6 bg-white dark:bg-zinc-800 rounded-lg shadow-lg">
                        <div className="flex gap-4 row-start-1 justify-items-center">
                            <CodeIcon></CodeIcon>
                            <h3 className="text-xl font-bold text-gray-900 dark:text-white">Code zu Struktogramm</h3>
                        </div>
                        <p className="mt-2 text-gray-700 dark:text-gray-300">Wandle C++, C, Go und JS Code in
                            Struktogramme um</p>
                    </div>
                    <div className="p-6 bg-white dark:bg-zinc-800 rounded-lg shadow-lg">
                        <div className="flex gap-4 row-start-1 justify-items-center">
                            <GaugeIcon></GaugeIcon>
                            <h3 className="text-xl font-bold text-gray-900 dark:text-white">Blitzschnell</h3>
                        </div>
                        <p className="mt-2 text-gray-700 dark:text-gray-300">Structogrammar ist in Next.js gebaut und
                            läuft performant in jedem Browser</p>
                    </div>
                    <div className="p-6 bg-white dark:bg-zinc-800 rounded-lg shadow-lg">
                        <div className="flex gap-4 row-start-1 justify-items-center">
                            <ShareIcon></ShareIcon>
                            <h3 className="text-xl font-bold text-gray-900 dark:text-white">Teile deine
                                Struktogramme</h3>
                        </div>
                        <p className="mt-2 text-gray-700 dark:text-gray-300">Teile dein Struktogramm mit einem Link oder
                            als Bild</p>
                    </div>
                    <div className="p-6 bg-white dark:bg-zinc-800 rounded-lg shadow-lg">
                        <div className="flex gap-4 row-start-1 justify-items-center">
                            <ArchiveRestoreIcon></ArchiveRestoreIcon>
                            <h3 className="text-xl font-bold text-gray-900 dark:text-white">Sichere deine Struktogramme</h3>
                        </div>
                        <p className="mt-2 text-gray-700 dark:text-gray-300">Wir speichern deine Struktogramme für dich. Greife von jedem Gerät darauf zu</p>
                    </div>
                </div>
            </div>
        </section>
    )
}