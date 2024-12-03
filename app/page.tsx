import Image from "next/image";
import {Header} from "@/components/header";
import {Features} from "@/components/features_section";
import {Button} from "@/components/ui/button";
import {ArrowRightIcon, CodeIcon} from "lucide-react";
import Link from "next/link";
import {AboutSection} from "@/components/about_section";
import {GetServerSideProps} from "next";


export default function Home() {
    return (
        <div className="relative inset-0 h-full w-full  bg-[linear-gradient(to_right,#80808012_1px,transparent_1px),linear-gradient(to_bottom,#80808012_1px,transparent_1px)] bg-[size:24px_24px]">
            <Header></Header>
            <main>
                <div className="container mx-auto px-6 lg:px-20">
                    <div className="grid grid-cols-1 lg:grid-cols-2 gap-8 items-center">
                        <div className="text-center lg:text-left">
                            <h1 className="text-3xl md:text-5xl font-extrabold text-gray-900 dark:text-white mr-4">
                                Structogrammar
                            </h1>
                            <p className="mt-4 text-lg text-gray-700 dark:text-gray-300">
                                Der beste Weg Struktogramme zu erstellen
                            </p>
                            <Link href="/editor" prefetch={true}>
                                <Button className="h-9 my-4">
                                    <ArrowRightIcon />
                                    zum Editor
                                </Button>
                            </Link>
                        </div>
                        <div className="relative w-full h-64 lg:h-96">
                            <Image
                                src="/images/preview.png"
                                alt="Structogram Example"
                                layout="fill"
                                objectFit="contain"
                                priority
                                className="rounded-lg px-8"
                            />
                        </div>
                    </div>
                </div>
            </main>
            <Features/>
            <AboutSection/>
            <footer className="row-start-3 flex gap-6 flex-wrap items-center justify-center sticky align-bottom">
                <a
                    className="flex items-center gap-2 hover:underline hover:underline-offset-4"
                    href="https://nextjs.org/learn?utm_source=create-next-app&utm_medium=appdir-template-tw&utm_campaign=create-next-app"
                    target="_blank"
                    rel="noopener noreferrer"
                >
                    <CodeIcon></CodeIcon>
                    Github Source Code
                </a>
            </footer>
        </div>
    );
}
