# Powershell notes: Terminating Errors

- [Powershell notes: Terminating Errors](#powershell-notes-terminating-errors)
    - [Replacement Error Messages](#replacement-error-messages)
      - [Signatures](#signatures)
  - [misc](#misc)
  - [`Cmdlet.Throwterminatingerror*` and Pipeline `Pipelinestoppedexception` ?](#cmdletthrowterminatingerror-and-pipeline-pipelinestoppedexception-)
    - [Error Identifiers](#error-identifiers)
  - [Links](#links)
    - [`[ErrorCategory]`](#errorcategory)
    - [Types and functions](#types-and-functions)


### Replacement Error Messages

- [Replacement Error Messages](https://docs.microsoft.com/en-us/powershell/scripting/developer/cmdlet/windows-powershell-error-records?view=powershell-7#replacement-error-message)
- you can use `[ErrorDetails]::new( Cmdlet, String, String, Object)`

#### Signatures

```ps1
Void .ctor(String)
Void .ctor(Management.Automation.Cmdlet, String, String, Object[])
Void .ctor(Management.Automation.IResourceSupplier, String, String, Object[])
Void .ctor(Reflection.Assembly, String, String, Object[])
```

## misc

- [Interpreting_ErrorRecord_Objects](https://docs.microsoft.com/en-us/powershell/scripting/developer/cmdlet/interpreting-errorrecord-objects?view=powershell-7)

## `Cmdlet.Throwterminatingerror*` and Pipeline `Pipelinestoppedexception` ?

> When a terminating error occurs, the cmdlet should report the error by calling the 

- `[Cmdlet].ThrowTerminatingError*`, then
- (at least in `Windows PowerShell`),  runtime **permanently stops** the execution of the **pipeline** and throws a [Management.Automation.Pipelinestoppedexception] exception
<!--
This topic discusses the method used to report terminating errors. It also discusses how to call the method from within the cmdlet, and it discusses the exceptions that can be returned by the Windows PowerShell runtime when the method is called.

When a terminating error occurs, the cmdlet should report the error by calling the System.Management.Automation.Cmdlet.Throwterminatingerror* method. This method allows the cmdlet to send an error record that describes the condition that caused the terminating error. For more information about error records, see Windows PowerShell Error Records.

When the System.Management.Automation.Cmdlet.Throwterminatingerror* method is called, the Windows PowerShell runtime permanently stops the execution of the pipeline and throws a System.Management.Automation.Pipelinestoppedexception exception. Any subsequent attempts to call System.Management.Automation.Cmdlet.WriteObject, System.Management.Automation.Cmdlet.WriteError, or several other APIs causes those calls to throw a System.Management.Automation.Pipelinestoppedexception exception.

The System.Management.Automation.Pipelinestoppedexception exception can also occur if another cmdlet in the pipeline reports a terminating error, if the user has asked to stop the pipeline, or if the pipeline has been halted before completion for any reason. The cmdlet does not need to catch the System.Management.Automation.Pipelinestoppedexception exception unless it must clean up open resources or its internal state.

Cmdlets can write any number of output objects or non-terminating errors before reporting a terminating error. However, the terminating error permanently stops the pipeline, and no further output, terminating errors, or non-terminating errors can be reported.

Cmdlets can call System.Management.Automation.Cmdlet.Throwterminatingerror* only from the thread that called the System.Management.Automation.Cmdlet.BeginProcessing, System.Management.Automation.Cmdlet.ProcessRecord, or System.Management.Automation.Cmdlet.EndProcessing input processing method. Do not attempt to call System.Management.Automation.Cmdlet.Throwterminatingerror* or System.Management.Automation.Cmdlet.WriteError from another thread. Instead, errors must be communicated back to the main thread.

It is possible for a cmdlet to throw an exception in its implementation of the System.Management.Automation.Cmdlet.BeginProcessing, System.Management.Automation.Cmdlet.ProcessRecord, or System.Management.Automation.Cmdlet.EndProcessing method. Any exception thrown from these methods (except for a few severe error conditions that stop the Windows PowerShell host) is interpreted as a terminating error which stops the pipeline, but not Windows PowerShell as a whole. (This applies only to the main cmdlet thread. Uncaught exceptions in threads spawned by the cmdlet, in general, halt the Windows PowerShell host.) We recommend that you use System.Management.Automation.Cmdlet.Throwterminatingerror* rather than throwing an exception because the error record provides additional information about the error condition, which is useful to the end-user. Cmdlets should honor the managed code guideline against catching and handling all exceptions (catch (Exception e)). Convert only exceptions of known and expected types into error records.
-->

### Error Identifiers

- [https://docs.microsoft.com/en-us/powershell/scripting/developer/cmdlet/windows-powershell-error-records?view=powershell-7#error-identifier](https://docs.microsoft.com/en-us/powershell/scripting/developer/cmdlet/windows-powershell-error-records?view=powershell-7#error-identifier)
- exists as property `[ErrorRecord].FullyQualifiedErrorId`

`[System.Management.Automation.Cmdlet].WriteError()`

- [https://docs.microsoft.com/../non-terminating-errors?view=powershell-7](https://docs.microsoft.com/en-us/powershell/scripting/developer/cmdlet/non-terminating-errors?view=powershell-7)
- When non-terminating errors occur, it should `.WriteError()`
- cmdlet **can continu**e to operate on this input object and on further incoming pipeline objects.
- cmdlet can write an error record that describes the condition that caused the non-terminating error
- see more: [WinPs Error Records](https://docs.microsoft.com/en-us/powershell/scripting/developer/cmdlet/windows-powershell-error-records?view=powershell-7)


## Links

- [https://docs.microsoft.com/en-us/powershell/scripting/developer/cmdlet/non-terminating-errors?view=powershell-7](https://docs.microsoft.com/en-us/powershell/scripting/developer/cmdlet/non-terminating-errors?view=powershell-7)

### `[ErrorCategory]`

- [https://docs.microsoft.com/en-us/powershell/scripting/developer/cmdlet/windows-powershell-error-records?view=powershell-7#error-category](https://docs.microsoft.com/en-us/powershell/scripting/developer/cmdlet/windows-powershell-error-records?view=powershell-7#error-category)

log outputs:
```sh
{Category}: ({TargetName}:{TargetType}):[{Activity}], {Reason}
```

### Types and functions

- `[System.Management.Automation.ErrorRecord]`
  - [https://docs.microsoft.com/en-us/dotnet/api/System.Management.Automation.ErrorCategoryInfo?view=powershellsdk-7.0.0](https://docs.microsoft.com/en-us/dotnet/api/System.Management.Automation.ErrorCategoryInfo?view=powershellsdk-7.0.0)
- `[System.Management.Automation.Cmdlet]`
  - `[Cmdlet].WriteError(..)`
  - `[Cmdlet].Throwterminatingerror(..)` => [https://docs.microsoft.com/en-us/dotnet/api/System.Management.Automation.Cmdlet.ThrowTerminatingError?view=powershellsdk-7.0.0](https://docs.microsoft.com/en-us/dotnet/api/System.Management.Automation.Cmdlet.ThrowTerminatingError?view=powershellsdk-7.0.0)

<!-- old format?
- [System.Management.Automation.ErrorRecord]
- [System.Management.Automation.Cmdlet]
- [System.Management.Automation.Cmdlet].WriteError(..)
- [System.Management.Automation.Cmdlet].Throwterminatingerror(..)
-->