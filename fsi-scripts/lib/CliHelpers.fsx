#r "nuget: CliWrap"
#r "nuget: UnMango.CliWrap.FSharp"

open CliWrap
open UnMango.CliWrap.FSharp

module Cli =
    let execNoRedirect (command: Command) =
        command.ExecuteAsync(fun startInfo ->
            startInfo.RedirectStandardInput <- false
            startInfo.RedirectStandardOutput <- false
            startInfo.RedirectStandardError <- false)
        |> CommandTask.op_Implicit
        |> Async.AwaitTask

type CommandBuilder with
    [<CustomOperation("execNoRedirect")>]
    member _.ExecNoRedirect(command: Command) =
        command.ExecuteAsync(fun startInfo ->
            startInfo.RedirectStandardInput <- false
            startInfo.RedirectStandardOutput <- false
            startInfo.RedirectStandardError <- false)
