import Link from 'next/link'
import { Home, Settings } from 'lucide-react'
import { Avatar, AvatarFallback, AvatarImage } from "@/components/ui/avatar"
import { Button } from "@/components/ui/button"

interface HeaderProps {
    projectName: string
    user: string
}

export function EditorHeader({ projectName, user }: HeaderProps) {
    return (
        <header className="flex items-center justify-between p-4 border-b">
            <Link href="/">
                <Button variant="ghost" size="icon">
                    <Home className="h-5 w-5" />
                    <span className="sr-only">Home</span>
                </Button>
            </Link>
            <h1 className="text-xl font-semibold">{projectName}</h1>
            <div className="flex items-center space-x-4">
                <span className="text-sm text-muted-foreground">Hello, {user}</span>
                <Button variant="ghost" size="icon">
                    <Settings className="h-5 w-5" />
                    <span className="sr-only">Settings</span>
                </Button>
                <Avatar>
                    <AvatarImage src="https://github.com/shadcn.png" alt="@shadcn" />
                    <AvatarFallback>CN</AvatarFallback>
                </Avatar>
            </div>
        </header>
    )
}

