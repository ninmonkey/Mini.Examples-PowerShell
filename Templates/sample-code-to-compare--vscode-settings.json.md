# Suggestions for normal config

```jsonc
{
    // normal config
    "errorLens.followCursor": "closestProblem",
    "errorLens.followCursorMore": 2,
    "errorLens.gutterIconsFollowCursorOverride": false, // show just selected errors
    "errorLens.enabledDiagnosticLevels": [
        "error",
        // "hint",
        // "warning",
        "info"
    ],
    "errorLens.followCursor": "closestProblem",
    "errorLens.exclude": [], //# regex
    "errorLens.excludeBySource": [], // ["eslint"]
    "errorLens.fontSize": "12px",
}
```

# Super verbose - noise in your face

```jsonc
{
    // normal config

    "errorLens.followCursorMore": 2,
    "errorLens.enabledDiagnosticLevels": [
        "error", "hint", "warning", "info"
    ],
    "errorLens.followCursor": "allLines",
    "errorLens.gutterIconsFollowCursorOverride": true, // show just selected errors
}

# dump of some settings to get started

```jsonc
 [
     //normal config
     {
         "errorLens.followCursor": "closestProblem",
         "errorLens.exclude": [], //# regex
         "errorLens.excludeBySource": [], // ["eslint"]
         "errorLens.followCursorMore": 2,
         "errorLens.statusBarIconsEnabled": true,
         "terminal.integrated.fontFamily": "'cascadia code pl', 'consolas', monospace",
         "errorLens.fontSize": "12px",
         // "editor.fontWeight": "350", // fo
     },
     // 'semantic'
     // obnoxious config for testing semantic
     "editor.tokenColorCustomizations": {
         "textMateRules": [
             // {
             //     "name": "test1",
             //     "scope": "",
             //     "settings": {
             //         "foreground": "#be85c500",
             //         "foreground": "#be85c59f",
             //         "foreground": "#c6d63a",
             //         "fontStyle": "underline"
             //     }
             // },
             /*
                 head:
                 punctuation.section.group.end.powershell
                 meta.group.array-expression.powershell
                     inside of grouping:
                         meta.group.array-expression.powershell
                 foot:
                 punctuation.section.group.end.powershell
                 meta.group.array-expression.powershell
             */
             {
                 "scope": "storage.modifier.scope.powershell",
                 "settings": {
                     "foreground": "#8fc1d8"
                 }
             },
             {
                 "scope": "support.variable.drive.powershell",
                 "settings": {
                     "fontStyle": "italic underline",
                     // "foreground": "#b7b4b8d2",
                     // "foreground": "#8fc1d8"
                 }
             },
             {
                 "name": "dim: const inst",
                 "scope": "constant.numeric.integer.powershell",
                 "settings": {
                     // "foreground": "#be85c59f", // this is kidn fo nice
                     // "foreground": "#B5CEA8",
                     // "foreground": "#c6d63a",
                     // "fontStyle": "underline"
                 }
             },
             {
                 "name": "yellow-ize most Operators",
                 "scope": "keyword.operator.assignment.powershell",
                 "settings": {
                     "foreground": "#be85c500",
                     "foreground": "#be85c59f", // this is kind of nice
                     // "foreground": "#c6d63a",
                     // "fontStyle": "underline"
                 }
             },
             {
                 "name": "dim variables all",
                 // "scope": "punctuation.section.group.end.powershell",
                 "scope": "variable.other.readwrite.powershell",
                 "settings": {
                     "foreground": "#be85c500",
                     "foreground": "#d63a3a",
                     "foreground": "#be85c59f",
                     "foreground": "#9CDCFE", // orig: 	#9CDCFE
                     "foreground": "#9cdcfe94", // orig: 	#9CDCFE
                     "foreground": "#9cb6fe", // orig: 	#9cb6fe
                     "foreground": "#9cb6fec7", // orig: 	#9CDCFE
                     "foreground": "#6381d3c7", // orig: 	#9CDCFE
                     // "fontStyle": "underline"
                 }
             },
             // {
             //     "name": "dim variables",
             //     // "scope": "punctuation.section.group.end.powershell",
             //     "scope": "meta.group.array-expression.powershell",
             //     "settings": {
             //         // "background": "#ff00ff",
             //         "foreground": "#be85c500",
             //         "foreground": "#d63a3a",
             //         "foreground": "#be85c5ce",
             //         "foreground": "#be85c59f",
             //         // "fontStyle": "italic bold underline strikethrough",
             //         // "fontStyle": "underline"
             //     }
             // },
             // {
             //     "name": "dim variables",
             //     // "scope": "punctuation.section.group.begin.powershell | punctuation.section.group.end.powershell",
             //     // "scope": "(punctuation.section.group.begin.powershell | punctuation.section.group.end.powershell)",
             //     "scope": "punctuation.section.group.begin.powershell", // works
             //     "settings": {
             //         // "background": "#ff00ff",
             //         "foreground": "#be85c500",
             //         "foreground": "#be85c5ce",
             //         "foreground": "#be85c59f",
             //         "foreground": "#d63a3a",
             //         "fontStyle": "",
             //         // "fontStyle": "underline"
             //     }
             // },
             // {
             //     "name": "test1",
             //     "scope": "punctuation.terminator.",
             //     "settings": {
             //         "foreground": "#c6d63a",
             //         "foreground": "#be85c500",
             //         "foreground": "#00ff00",
             //         "fontStyle": "underline"
             //     }
             // },
             // {
             //     "name": "test1",
             //     "scope": "keyword.*",
             //     "settings": {
             //         "foreground": "#c6d63a",
             //         "foreground": "#be85c500",
             //         "foreground": "#be85c59f",
             //         "fontStyle": "underline"
             //     }
             // },
         ],
         "[Visual Studio 2019 Dark]": {
             // example test
             // "textMateRules": [
             //     {
             //         "name": "mabyesingle",
             //         // "scope": "variable",
             //         "scope": "meta.hashtable.powershell",
             //         "settings": {
             //             "foreground": "#4278b4f3",
             //             // "fontStyle": "bold underline strikethrough"
             //         }
             //     }
             // ],
             // "strings": {
             //     "foreground": "magenta",
             //     // "fontStyle": "bold strikethrough",
             // },
             /*
                 {
                     "name": "dev test",
                     "scope": "keyword.operator",
                     "settings": {
                         "foreground": "#aa53bbcc",
                         // "fontStyle": "bold underline",
                         "fontStyle": "underline",
                     }
                 }
             #>
             */
             // "keywords": {
             //     "foreground": "#1e4a7cf3",
             //     "foreground": "#4278b4f3",
             //     // "fontStyle": "",
             // }
         }
     },
     "oneDarkPro.bold": true,
     "editor.semanticTokenColorCustomizations": {
         "enabled": false,
         // "enabled": true,
         "rules": {
             "support.variable.drive.powershell": {
                 "foreground": "#FF0000",
                 "fontStyle": "bold"
             },
             // "variable": {
             //     "foreground": "#FF0000",
             //     "fontStyle": "bold",
             //     // "underline": true
             // },
             "stringEscapeCharacter": {
                 "foreground": "#ff00dd",
                 "strikethrough": true,
                 "fontStyle": "bold",
                 "underline": true
             },
             "storage.modifier.scope.powershell": {
                 "foreground": "#ff00dd",
                 "strikethrough": true,
                 "fontStyle": "bold"
             },
             // "typeAlias": "#ff0000",
             // "attribute": "#ff00ff",
             // "number": "#ff0000"
             // "Other": {
             //     "foreground": "#FF0000",
             //     "fontStyle": "bold"
             // }
         }
     },
     "csharp.semanticHighlightidng.enabled": true,
     "editor.semanticHighlighting.enabled": true,
 ]