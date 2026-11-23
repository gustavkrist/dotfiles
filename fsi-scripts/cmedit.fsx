#r "nuget: CliWrap"
#r "nuget: UnMango.CliWrap.FSharp"
#load "lib/CliHelpers.fsx"

open System.IO
open CliWrap
open UnMango.CliWrap.FSharp
open CliHelpers


let cmManaged =
    command "chezmoi" {
        args [ "managed"; "--path-style"; "absolute"; "--exclude"; "dirs" ]
        buffered
    }

let fzf =
    command "fzf" {
        args
            [
                "-m"
                "--height"
                "90%"
                "--preview"
                "bat --theme Nord --style=numbers --color=always --line-range :500 '{}'"
                "--preview-window"
                "~4,+{2}+4/3,<80(down)"
            ]

        validation CommandResultValidation.None
    }

let cmEdit fileArgs =
    command "chezmoi" {
        args ([ "edit"; "--apply"; "--watch" ] @ fileArgs)
        validation CommandResultValidation.None
        stderr PipeTo.stderr
        execNoRedirect
    }

let task =
    task {
        let! managedResult = cmManaged

        let files =
            managedResult.StandardOutput.Split "\n"
            |> String.concat "\n"

        let! fzfResult = PipeSource.FromString(files) |>> fzf |> Cli.execBuffered

        let fileArgs =
            fzfResult.StandardOutput.Trim().Split "\n"
            |> Array.toList
            |> List.filter ((<>) "")

        if fileArgs.IsEmpty |> not then
            let! cmResult = cmEdit fileArgs
            return cmResult.ExitCode
        else
            return 0
    }

exit task.Result
