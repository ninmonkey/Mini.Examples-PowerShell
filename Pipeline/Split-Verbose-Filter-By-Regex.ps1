<#
from: Justin Grote's gist:
<https://gist.github.com/JustinGrote/c9f2f57fe15b2936c1a41c051309b774>
#>
using namespace System.Management.Automation
using namespace System.Collections.Generic
function Split-Verbose {
  <#
  .SYNOPSIS
  Services a similar purpose to the cmdletbinding WarningVariable parameter but for verbose.
  .NOTES
  In order for this to work your previous command must have 4>&1 at the end of the command prior to piping to this
  #>
  [CmdletBinding()]
  param(
    #Use this to save verbose output to a variable. If not specified then it will continue to be output normal
    [string]$VariableName,
    #Filter via a regex statement. Verbose records that match this will be retained
    [Regex]$Filter,
    [Parameter(ValueFromPipeline)]$InputObject
  )
  begin {
    if ($VariableName) {
      $var = Set-Variable -Name $VariableName -Scope 1 -Value ([List[VerboseRecord]]::new()) -PassThru
    }
  }
  process {
    if ($InputObject -is [VerboseRecord]) {
      if ($Filter -and -not $Filter.IsMatch($InputObject)) {
        return
      }
      if ($VariableName) {
        $var.Value.Add($InputObject)
        return
      }
      Write-Verbose $InputObject
      return
    }

    $InputObject
  }
}

