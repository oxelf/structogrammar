import {EditorHeader} from "@/app/editor/header";
import {Skeleton} from "@/components/ui/skeleton";

export default function Loading() {
    return (
        <>

            <EditorHeader projectName="Übersicht" user={""} />
            <main className="container mx-auto p-4">
                <div className="flex justify-between items-center mb-6">
                    <h2 className="text-2xl font-bold">Deine Struktogramme</h2>
                </div>
                <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
                    {
                        Array.from({length: 10}).map((_, index) => (
                            <Skeleton key={index} className="w-56 h-64" />
                        ))
                    }
                </div>
            </main>
        </>
    );
}