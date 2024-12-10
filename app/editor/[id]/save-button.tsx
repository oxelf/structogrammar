import { Button } from "@/components/ui/button";
import { ShareIcon } from "lucide-react";
import { DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuTrigger } from "@/components/ui/dropdown-menu";
import { getNodesBounds, getViewportForBounds, useReactFlow } from "@xyflow/react";
import { toBlob } from "html-to-image";
import {useAppDispatch} from "@/app/editor/store";
import {setSelectedNode} from "@/app/editor/selected-node-slice";

export function SaveButton() {
    const { getNodes, fitView } = useReactFlow();
    const dispatch = useAppDispatch();

    async function onExport() {
        dispatch(setSelectedNode(null))
        const nodesBounds = getNodesBounds(getNodes());
        const contentWidth = nodesBounds.width;
        const contentHeight = nodesBounds.height;

        await fitView({ padding: 0 });
        await new Promise((resolve) => setTimeout(resolve, 500));

        const transform = getViewportForBounds(
            nodesBounds,
            contentWidth,
            contentHeight,
            0,
            2,
            0,
        );

        const reactFlowContainer = document.querySelector('.react-flow__viewport') as HTMLElement;
        const backgroundColor = window.getComputedStyle(reactFlowContainer).backgroundColor;

        try {
            const blob = await toBlob(reactFlowContainer, {
                filter: node =>
                    !(
                        node?.classList?.contains('react-flow__minimap') ||
                        node?.classList?.contains('react-flow__controls')
                    ),
                backgroundColor: backgroundColor,
                width: contentWidth,
                height: contentHeight,
                style: {
                    width: `${contentWidth}px`,
                    height: `${contentHeight}px`,
                    transform: `translate(${transform.x}px, ${transform.y}px) scale(${transform.zoom})`,
                },
            });

            if (blob) {
                const url = URL.createObjectURL(blob);
                const a = document.createElement('a');
                a.setAttribute('download', 'struktogramm.png');
                a.setAttribute('href', url);
                a.click();
                URL.revokeObjectURL(url);
            }
        } catch (error) {
            console.error('Error exporting image:', error);
        }
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