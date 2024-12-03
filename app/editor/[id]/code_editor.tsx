"use client";
import dynamic from "next/dynamic";
import React, {useEffect, useRef, useState} from "react";
import { monaco } from "react-monaco-editor";
import {useTheme} from "next-themes";
import {Button} from "@/components/ui/button";
import {CodeIcon} from "lucide-react";
import {useAppDispatch, useAppSelector} from "@/app/editor/store";

const MonacoEditor = dynamic(() => import("react-monaco-editor"), { ssr: false, loading: () => <p>Loading Editor...</p>, });

interface MonacoEditorComponentProps {
}

const MonacoEditorComponent: React.FC<MonacoEditorComponentProps> = ({   }) => {
    const editorRef = useRef<monaco.editor.IStandaloneCodeEditor | null>(null);
    const containerRef = useRef<HTMLDivElement>(null);
    const { theme } = useTheme();
    const [editorTheme, setEditorTheme] = useState("vs-light"); // Default to light theme
    const language = useAppSelector((state) => state.codeLanguage.value);
    const code = useAppSelector((state) => state.code.value);
    const dispatch = useAppDispatch();

    useEffect(() => {
        // If the theme is "system", detect system preference
        if (theme === "system") {
            const mediaQuery = window.matchMedia("(prefers-color-scheme: dark)");
            setEditorTheme(mediaQuery.matches ? "vs-dark" : "vs-light");

            // Listen for changes in the system theme
            const listener = (e: any) => {
                setEditorTheme(e.matches ? "vs-dark" : "vs-light");
            };
            mediaQuery.addEventListener("change", listener);

            return () => {
                mediaQuery.removeEventListener("change", listener);
            };
        } else {
            // Set Monaco theme based on Next.js theme (light or dark)
            const colorMode = theme === "light" ? "vs-light" : "vs-dark";
            setEditorTheme(colorMode);
        }
    }, [theme]);
    /*
        if (typeof window !== 'undefined') {
            self.MonacoEnvironment = {
                getWorkerUrl: function (moduleId, label) {
                    if (label === 'typescript' || label === 'javascript') {
                        return '/_next/static/ts.worker.js';
                    }
                    if (label === 'css') {
                        return '/_next/static/css.worker.js';
                    }
                    if (label === 'go') {
                        return '/_next/static/go.worker.js';
                    }
                    if (label === 'cpp') {
                        return '/_next/static/cpp.worker.js';
                    }
                    if (label === 'html') {
                        return '/_next/static/html.worker.js';
                    }
                    return '/_next/static/editor.worker.js';
                },
            };
        }
    */



const editorDidMount = (
        editor: monaco.editor.IStandaloneCodeEditor,
        monacoInstance: typeof monaco
    ) => {
        console.log("Editor mounted");
        editorRef.current = editor;
        editor.focus();
    };

    const handleResize = () => {
        if (editorRef.current) {
            editorRef.current.layout();
        }
    };

    useEffect(() => {
        const resizeObserver = new ResizeObserver(() => handleResize());
        if (containerRef.current) {
            resizeObserver.observe(containerRef.current);
        }

        return () => {
            resizeObserver.disconnect();
        };
    }, []);

    const handleChange = (
        newValue: string,
        e: monaco.editor.IModelContentChangedEvent
    ) => {
        console.log("Editor content changed");
    };

    return (
        <div ref={containerRef} className="w-full h-full">
            <MonacoEditor
                width="100%"
                height="100%"
                language={language}
                theme={editorTheme}
                value={code}
                options={{
                    selectOnLineNumbers: true,
                }}
                onChange={handleChange}
                editorDidMount={editorDidMount}
                editorWillUnmount={() => console.log("Editor unmounted")}
                editorWillMount={(monaco) => {}}
            />
            <div className="w-full absolute z-10 bottom-2 p-2">
                <Button>
                    <CodeIcon className="mr-2"/>
                    Convert
                </Button>
            </div>
        </div>
    );
};

export default MonacoEditorComponent;