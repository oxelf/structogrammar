import { Card, CardContent, CardFooter, CardHeader, CardTitle } from "@/components/ui/card"
import Image from 'next/image'
import Link from 'next/link'
import { HoverCard, HoverCardContent, HoverCardTrigger } from "@/components/ui/hover-card"
import {
    ContextMenu,
    ContextMenuContent,
    ContextMenuItem,
    ContextMenuTrigger
} from "@/components/ui/context-menu";

interface ProjectCardProps {
    id: number | string
    name: string
    lastEdited: string
    previewImage: string
}

function getTime(date: string) {
    const timeDate = new Date(date)
    const weeksSince = Math.floor((Date.now() - timeDate.getTime()) / (1000 * 60 * 60 * 24 * 7))
    const daysSince = Math.floor((Date.now() - timeDate.getTime()) / (1000 * 60 * 60 * 24))
    const hoursSince = Math.floor((Date.now() - timeDate.getTime()) / (1000 * 60 * 60))
    const minutesSince = Math.ceil((Date.now() - timeDate.getTime()) / (1000 * 60))
    return weeksSince > 0 ? `${weeksSince} week${weeksSince > 1 ? "s" : ""} ago` : daysSince > 0 ? `${daysSince} day${daysSince > 1 ? "s" : ""} ago` : hoursSince > 0 ? `${hoursSince} hour${hoursSince > 1 ? "s" : ""} ago` : `${minutesSince} minute${minutesSince > 1 ? "s" : ""} ago`
}

export function ProjectCard({ id, name, lastEdited, previewImage }: ProjectCardProps) {
    let image;
    if (previewImage != "") {
        image = <Image
            src={previewImage}
            alt={`Preview of ${name}`}
            width={300}
            height={200}
            className="w-full h-40 object-cover"
        />
    } else {
        image = <div className="w-full h-40 bg-gray-200"></div>
    }
    return (
        <ContextMenu>
            <ContextMenuContent className="w-64">
                <ContextMenuItem inset>
                    Umbenennen
                </ContextMenuItem>
                <ContextMenuItem inset>
                    Löschen
                </ContextMenuItem>
                <ContextMenuItem inset>
                    Duplizieren
                </ContextMenuItem>
            </ContextMenuContent>
            <ContextMenuTrigger>
        <HoverCard>
            <HoverCardTrigger asChild>
                <Link href={`/editor/${id}`} className="block">
                    <Card className="overflow-hidden transition-shadow hover:shadow-lg">
                        <CardHeader className="p-0">
                            {image}
                        </CardHeader>
                        <CardContent className="p-4">
                            <CardTitle className="text-lg">{name}</CardTitle>
                        </CardContent>
                        <CardFooter className="text-sm text-muted-foreground">
                            Last edited: {getTime(lastEdited)}
                        </CardFooter>
                    </Card>
                </Link>
            </HoverCardTrigger>
            <HoverCardContent className="w-80">
                <div className="flex justify-between space-x-4">
                    <div className="space-y-1">
                        <h4 className="text-sm font-semibold">{name}</h4>
                        <p className="text-sm">
                            Klicke um das Struktogramm im Editor zu öffnen
                        </p>
                        <div className="flex items-center pt-2">
              <span className="text-xs text-muted-foreground">
                Last edited: {getTime(lastEdited)}
              </span>
                        </div>
                    </div>
                </div>
            </HoverCardContent>
        </HoverCard>
            </ContextMenuTrigger>
        </ContextMenu>
    )
}