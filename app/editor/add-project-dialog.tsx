'use client'

import { useState } from 'react'
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle, DialogTrigger } from "@/components/ui/dialog"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Label } from "@/components/ui/label"
import { createBrowserClient } from "@supabase/ssr";
import { Database } from "@/types/database";
import { useRouter } from "next/navigation";

export function AddProjectDialog() {
    const [open, setOpen] = useState(false)
    const [projectName, setProjectName] = useState('')
    const router = useRouter()

    const handleSubmit = async (e: React.FormEvent) => {
        e.preventDefault()
        console.log('Creating project:', projectName)
        const supabase = createBrowserClient<Database>(process.env.NEXT_PUBLIC_SUPABASE_URL || "", process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || "")
        const { data, error } = await supabase.from('structograms').insert({ name: projectName }).select().single()

        if (error) {
            console.error('Error creating project:', error)
            return
        }

        console.log('Project created:', data)
        setOpen(false)
        setProjectName('')
        router.push(`/editor/${data.id}`)
    }

    return (
        <Dialog open={open} onOpenChange={setOpen}>
            <DialogTrigger asChild>
                <Button variant="default">Struktogramm erstellen</Button>
            </DialogTrigger>
            <DialogContent className="sm:max-w-[425px]">
                <DialogHeader>
                    <DialogTitle>Neues Struktogramm erstellen</DialogTitle>
                    <DialogDescription>
                        Wähle einen Namen für das Struktogramm
                    </DialogDescription>
                </DialogHeader>
                <form onSubmit={handleSubmit}>
                    <div className="grid gap-4 py-4">
                        <div className="grid grid-cols-4 items-center gap-4">
                            <Label htmlFor="project-name" className="text-right">
                                Name
                            </Label>
                            <Input
                                id="project-name"
                                value={projectName}
                                onChange={(e) => setProjectName(e.target.value)}
                                className="col-span-3"
                            />
                        </div>
                    </div>
                    <DialogFooter>
                        <Button type="submit">Erstellen</Button>
                    </DialogFooter>
                </form>
            </DialogContent>
        </Dialog>
    )
}