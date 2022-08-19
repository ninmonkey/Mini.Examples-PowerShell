- [WinPS 5.1](#winps-51)
  - [`[ValidateSet]`](#validateset)
- [PS 6+](#ps-6)
  - [`[ArgumentCompletions]` Suggestable Completer](#argumentcompletions-suggestable-completer)

## WinPS 5.1

### `[ValidateSet]`

The simplest version is to use `[ValidateSet()]` like:

```ps1
[Parameter()]
[ValidateSet('csv', 'json')]$ExportFormat
```

###

## PS 6+

### `[ArgumentCompletions]` Suggestable Completer

PS 6 Adds a method of *optional* completions, allowing the user to override with new values.

[ArgumentCompletions.ps1](./New-In-PS6/ArgumentCompletions-Completer.ps1)