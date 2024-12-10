"use server";

import { createServerClient } from "@supabase/ssr";
import { cookies } from "next/headers";
import { EditorProvider } from "@/app/editor/[id]/editor-provider";
import EditorView from "@/app/editor/[id]/editor-view";

async function fetchProjectData(id: string) {
    const cookieObject = await cookies(); // Synchronous function in Next.js 13+
    const supabase = createServerClient(
        process.env.NEXT_PUBLIC_SUPABASE_URL!,
        process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
        {
            cookies: {
                getAll() {
                    return cookieObject.getAll();
                },
                setAll(cookiesToSet) {
                    cookiesToSet.forEach(({ name, value }) =>
                        cookieObject.set(name, value)
                    );
                },
            },
        }
    );

    const { data, error } = await supabase
        .from("structograms")
        .select("*")
        .eq("id", id)
        .single();

    if (error) {
        throw new Error(`Error fetching project data: ${error.message}`);
    }

    return data;
}


export default async function EditorPage(params: {
    params: Promise<{ id: string }>;}) {
    let id = (await (params).params).id;

    const projectData = await fetchProjectData(id);

    return (
        <EditorProvider>
            <EditorView projectData={projectData} />
        </EditorProvider>
    );
}