import {StructogramNode} from "@/types/structogram";

export function getInstructionTemplate() {
    return new StructogramNode(
        "instruction",
         new Map([["value", ""]]),
         [],
)
}

export function getForTemplate() {
    return new StructogramNode(
        "for",
        new Map([["condition", "int i = 0; i < 10; i++"]]),
        [
            getInstructionTemplate(),
        ],
    );
}

export function getWhileTemplate() {
    return new StructogramNode(
        "while",
        new Map([["condition", ""]]),
        [
            getInstructionTemplate(),
        ],
    );
}

export function getIfTemplate() {
    let trueNode = getInstructionTemplate();
    let falseNode = getInstructionTemplate();
    trueNode.data.set("condition", "true");
    falseNode.data.set("condition", "false");
    return new StructogramNode(
        "if",
        new Map([["condition", ""]]),
        [
            trueNode, falseNode,
        ],
    );
}
