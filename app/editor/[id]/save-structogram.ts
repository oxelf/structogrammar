"use server"
import { createServerClient } from "@supabase/ssr";
import { cookies } from "next/headers";
import { Structogram } from "@/types/structogram";

async function saveStructogram(structogram: Structogram) {
    const cookieObject = await cookies();
    const supabase = createServerClient(
        process.env.NEXT_PUBLIC_SUPABASE_URL!,
        process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
        {
            cookies: {
                async getAll() {
                    return cookieObject.getAll();
                },
                setAll(cookiesToSet) {
                    cookiesToSet.forEach(({ name, value }) =>
                        cookieObject.set(name, value),
                    );
                },
            },
        },
    );

    const { data, error } = await supabase
        .from('structograms')
        .update(structogram, {});

    if (error) {
        throw new Error(`Error saving structogram: ${error.message}`);
    }

    return data;
}

export default saveStructogram;