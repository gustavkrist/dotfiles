open CliWrap
open UnMango.CliWrap.FSharp
open Shared

let cmManaged =
    command "chezmoi" {
        args [ "managed"; "--path-style"; "absolute"; "--exclude"; "dirs" ]
        buffered
    }

let fzf initialInput =
    command "fzf" {
        args
            [
                "-q"
                initialInput
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

let getTask initialInput =
    task {
        let! managedResult = cmManaged

        let files = managedResult.StandardOutput.Split "\n" |> String.concat "\n"

        let! fzfResult = PipeSource.FromString(files) |>> fzf initialInput |> Cli.execBuffered

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


[<EntryPoint>]
let main argv =
    let initialInput =
        match argv with
        | [| s |] -> s
        | _ -> ""

    let task = getTask initialInput
    task.Result
