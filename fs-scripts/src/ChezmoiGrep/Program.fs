#nowarn 25
open System.Text.RegularExpressions

open CliWrap
open UnMango.CliWrap.FSharp

open Shared

let fzf initialInput cmPath cmAbbrev =
    let reloadCmd =
        $"reload:rg --column --color=always --smart-case {{q}} {cmPath} | sed 's:{cmPath}:{cmAbbrev}:g; s:/private_dot_config/:/.config/:g'|| :"

    command "fzf" {
        args
            [
                "-q"
                initialInput
                "--height"
                "90%"
                "--disabled"
                "--ansi"
                "--bind"
                $"start:{reloadCmd}"
                "--bind"
                $"change:{reloadCmd}"
                "--delimiter"
                ":"
                "--accept-nth"
                "{1}|{2}"
                "--freeze-right"
                "1"
                "--hscroll-off"
                "50"
                "--preview"
                $"""bat --style=full --color=always --highlight-line {{2}} $(echo {{1}} | sed "s:{cmAbbrev}:{cmPath}:; s:/.config/:/private_dot_config/:")"""
                "--preview-window"
                "~4,+{2}+4/3,<80(down)"
            ]

        validation CommandResultValidation.None
        buffered
    }

let getTask initialInput =
    task {
        let! cmPathRes =
            command "chezmoi" {
                args "source-path"
                buffered
            }

        let cmPath = cmPathRes.StandardOutput.Trim()

        let cmAbbrev =
            Regex.Matches(cmPath, @"/\.?\w")
            |> Seq.map (fun m -> m.Value)
            |> String.concat ""

        let! fzfResult = fzf initialInput cmPath cmAbbrev

        if fzfResult.StandardOutput.Trim() <> "" then
            let [| file; line |] = fzfResult.StandardOutput.Trim().Split "|"

            let file' =
                file.Replace(cmAbbrev, cmPath).Replace("/.config/", "/private_dot_config/")

            do System.Environment.SetEnvironmentVariable("EDITOR", $"nvim +{line}")

            let! fileToEdit =
                command "chezmoi" {
                    args [ "target-path"; file' ]
                    buffered
                }

            let! res =
                command "chezmoi" {
                    args [ "edit"; "--apply"; "--watch"; fileToEdit.StandardOutput.Trim() ]
                    validation CommandResultValidation.None
                    stderr PipeTo.stderr
                    execNoRedirect
                }

            return res.ExitCode
        else
            return 0
    }

[<EntryPoint>]
let main argv =
    let task = getTask ""
    task.Result |> ignore
    0
