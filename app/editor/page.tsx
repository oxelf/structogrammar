import { cookies } from "next/headers";
import { EditorHeader } from "./header";
import { ProjectCard } from "@/app/editor/project-card";
import { AddProjectDialog } from "@/app/editor/add-project-dialog";
import { createClient } from "@/utils/supabase/server";

type Repo = {
    name: string;
    stargazers_count: number;
};

type Props = {
    user: any;
    structograms: any[];
    error: any;
};

type Params = {
    id: string;
};

const fetchData = async () => {
    const supabase = await createClient();
    const { data: structograms, error } = await supabase.from("structograms").select("*");
    const { data: user } = await supabase.auth.getUser();
    return { user, structograms, error };
};

const EditorPage = async ({ params }: { params: Params }) => {
    const { user, structograms, error } = await fetchData();

    if (error) {
        console.error(error);
        return <div>Error</div>;
    }

    return (
        <>
            <EditorHeader projectName="Übersicht" user={user?.user?.email || ""} />
            <main className="container mx-auto p-4">
                <div className="flex justify-between items-center mb-6">
                    <h2 className="text-2xl font-bold">Deine Struktogramme</h2>
                    <AddProjectDialog />
                </div>
                <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
                    {structograms!.map((project) => (
                        <ProjectCard
                            key={project.id}
                            id={project.id}
                            name={project.name || ""}
                            lastEdited={project.created_at}
                            previewImage={project.preview_image || ""}
                        />
                    ))}
                </div>
            </main>
        </>
    );
};

export default EditorPage;