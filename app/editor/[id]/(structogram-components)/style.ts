export function getBorderStyle(borders: boolean[]) {
    let borderStyle = " ";
    if (borders.at(0)) {
        borderStyle += "border-l border-l-black dark:border-l-white ";
    }
    if (borders.at(1)) {
        borderStyle += "border-r border-r-black dark:border-r-white ";
    }
    if (borders.at(2)) {
        borderStyle += "border-t border-t-black dark:border-t-white ";
    }
    if (borders.at(3)) {
        borderStyle += "border-b border-b-black dark:border-b-white ";
    }
    return borderStyle;
}

export const inputStyle = "flex justify-center bg-blue-200 dark:bg-blue-800 ml-4 mr-4 w-full !outline-none";
export const titleStyleNormal =
    "w-full h-full flex flex-row justify-center justify-items-center justify-self-center ";
export const titleStyleSelected =
    "w-full h-full flex flex-row justify-center justify-items-center justify-self-center  bg-blue-200 dark:bg-blue-800";
export const childrenStyle = " flex flex-col flex-grow";
export const blockStyleNormal = "flex flex-col  w-8 ";
export const blockStyleSelected = "flex flex-col  w-8  bg-blue-200 dark:bg-blue-800";
