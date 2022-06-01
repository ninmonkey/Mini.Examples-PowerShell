
[PowerShell].Assembly.GetType('System.Management.Automation.SpecialVariables').GetFields('Static,NonPublic')
| Where-Object FieldType -EQ ([string]) | ForEach-Object GetValue($null) | Join-String -sep ', '

<#
[PowerShell].Assembly.GetType('System.Management.Automation.SpecialVariables').GetFields('Static,NonPublic') | ? FieldType -eq ([string]) | % GetValue($null) | Join-String -sep ', '
MaximumHistoryCount, MyInvocation, OFS, PSStyle, OutputEncoding, VerboseHelpErrors, LogEngineHealthEvent, LogEngineLifecycleEvent, LogCommandHealthEvent, LogCommandLifecycleEvent, LogProviderHealthEvent, LogProviderLifecycleEvent, LogSettingsEvent, PSLogUserData, NestedPromptLevel, CurrentlyExecutingCommand, PSBoundParameters, Matches, LASTEXITCODE, PSDebugContext, StackTrace, ^, $, PSItem, _, ?, args, this, input, PSCmdlet, error, error, env:PATHEXT, PSEmailServer, PSDefaultParameterValues, PSScriptRoot, PSCommandPath, PSSenderInfo, foreach, switch, PWD, null, true, false, PSModuleAutoLoadingPreference, IsLinux, IsMacOS, IsWindows, IsCoreCLR, DebugPreference, ErrorActionPreference, ProgressPreference, VerbosePreference, WarningPreference, WhatIfPreference, ConfirmPreference, InformationPreference, PSNativeCommandArgumentPassing, ErrorView, PSSessionConfigurationName, PSSessionApplicationName, ExecutionContext, HOME, Host, PID, PSCulture, PSHOME, PSUICulture, PSVersionTable, PSEdition, ShellId, EnabledExperimentalFeatures

#>

[PowerShell].Assembly.GetType('System.Management.Automation.SpecialVariables').GetFields('Static,NonPublic')
| Where-Object FieldType -EQ ([string])

<#

ReflectedType: SpecialVariables

Name                  MemberType   Definition
----                  ----------   ----------
HistorySize           Field        internal const string HistorySize = "MaximumHistoryCount";
MyInvocation          Field        internal const string MyInvocation = "MyInvocation";
OFS                   Field        internal const string OFS = "OFS";
PSStyle               Field        internal const string PSStyle = "PSStyle";
OutputEncoding        Field        internal const string OutputEncoding = "OutputEncoding";
VerboseHelpErrors     Field        internal const string VerboseHelpErrors = "VerboseHelpErro
LogEngineHealthEvent  Field        internal const string LogEngineHealthEvent = "LogEngineHea
LogEngineLifecycleEv… Field        internal const string LogEngineLifecycleEvent = "LogEngine
LogCommandHealthEvent Field        internal const string LogCommandHealthEvent = "LogCommandH
LogCommandLifecycleE… Field        internal const string LogCommandLifecycleEvent = "LogComma
LogProviderHealthEve… Field        internal const string LogProviderHealthEvent = "LogProvide
LogProviderLifecycle… Field        internal const string LogProviderLifecycleEvent = "LogProv
LogSettingsEvent      Field        internal const string LogSettingsEvent = "LogSettingsEvent

#>
