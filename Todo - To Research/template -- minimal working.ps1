[CompletionResult]::new( '/all', '/All', [CompletionResultType]::ParameterName, 'all' )
| Tee-Object -var ACResult
Register-ArgumentCompleter -Native -CommandName 'ipconfig' -ScriptBlock { $ACResult }