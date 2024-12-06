"use client"
import Link from 'next/link'
import {
    ArrowLeftIcon,
    Bold,
    Code2Icon,
    CodeIcon,
    FolderTreeIcon,
    Home,
    Italic, ListTreeIcon,
    Settings, ShareIcon,
    TreesIcon,
    Underline
} from 'lucide-react'
import { Button } from "@/components/ui/button"
import {ModeToggle} from "@/components/theme_toggle";
import {ToggleGroup, ToggleGroupItem} from "@/components/ui/toggle-group";
import {useAppDispatch, useAppSelector} from "@/app/editor/store";
import {setWindows} from "@/app/editor/windows-slice";
import {SaveButton} from "@/app/editor/[id]/save-button";

interface HeaderProps {
    projectName: string
    user: string
}

export function EditorToolbar({ projectName, user }: HeaderProps) {
    const dispatcher = useAppDispatch();
    const windows = useAppSelector((state) => state.windows.value);
    return (
        <header className="flex items-center justify-between p-1 border-b">
            <div className="flex flex-row">
            <Link href="/editor">
                <Button variant="ghost" size="icon">
                    <ArrowLeftIcon className="h-5 w-5" />
                    <span className="sr-only">Home</span>
                </Button>
            </Link>
            <ToggleGroup onValueChange={(value) => {
                console.log(value);
                dispatcher(setWindows(value))
            }} size={"sm"} type="multiple" value={windows}>
                <ToggleGroupItem value="tree" aria-label="Toggle Tree View">
                    <ListTreeIcon></ListTreeIcon>
                </ToggleGroupItem>
                <ToggleGroupItem value="code" aria-label="Toggle Code Editor">
                    <Code2Icon></Code2Icon>
                </ToggleGroupItem>
            </ToggleGroup>
            </div>
            <h1 className="text-xl font-semibold">{projectName}</h1>
            <div className="flex items-center space-x-2">
                <SaveButton />
                <ModeToggle />
                <Button variant="outline" size="icon">
                    <Settings className="h-5 w-5" />
                    <span className="sr-only">Settings</span>
                </Button>
            </div>
        </header>
    )
}

