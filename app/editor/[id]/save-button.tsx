import { Button } from "@/components/ui/button";
import { ShareIcon } from "lucide-react";
import { DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuTrigger } from "@/components/ui/dropdown-menu";
import { getNodesBounds, getViewportForBounds, useReactFlow } from "@xyflow/react";
import { toPng } from "html-to-image";

export function SaveButton() {
    const { getNodes } = useReactFlow();

    function onExport() {
        const nodesBounds = getNodesBounds(getNodes());
        const imageWidth = 1024;
        const imageHeight = 768;

        const transform = getViewportForBounds(
            nodesBounds,
            imageWidth,
            imageHeight,
            0,
            2,
            0,
        );

        const reactFlowContainer = document.querySelector('.react-flow__viewport') as HTMLElement;
        const backgroundColor = "rgba(0,0,0,0)";

        toPng(reactFlowContainer, {
            filter: node =>
                !(
                    node?.classList?.contains('react-flow__minimap') ||
                    node?.classList?.contains('react-flow__controls')
                ),
            backgroundColor: backgroundColor,
            width: imageWidth,
            height: imageHeight,
            style: {
                transform: `translate(${transform.x}px, ${transform.y}px) scale(${transform.zoom})`,
            },
        }).then(dataUrl => {
            const a = document.createElement('a');
            a.setAttribute('download', 'struktogramm.png');
            a.setAttribute('href', dataUrl);
            a.click();
        });
    }

    return (
        <DropdownMenu>
            <DropdownMenuTrigger asChild>
                <Button variant="outline" size="icon">
                    <ShareIcon className="h-5 w-5" />
                    <span className="sr-only">Share</span>
                </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent className="w-48">
                <DropdownMenuItem onSelect={onExport}>Exportieren</DropdownMenuItem>
                <DropdownMenuItem>Teilen als Link</DropdownMenuItem>
                {/* Add more options here */}
            </DropdownMenuContent>
        </DropdownMenu>
    );
}