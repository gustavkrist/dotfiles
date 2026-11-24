#r "nuget: FSharp.Data"
#r "nuget: UnMango.CliWrap.FSharp"
#load "lib/CliHelpers.fsx"

open FSharp.Data
open CliWrap
open UnMango.CliWrap.FSharp

let args =
#if COMPILED
    System.Environment.GetCommandLineArgs() |> Array.tail
#else
    fsi.CommandLineArgs |> Array.tail
#endif

let numLogs =
    match args with
    | [| n |] -> int n
    | _ -> 10

let BASE_URL = "https://blob.superlogical.com/public/changelog/"

type Changelogs =
    JsonProvider<
        """{"schemaVersion": 1, "updatedAt": "2026-11-23T23:02:55.005Z", "releases": [{"platform": "windows", "version": "0.1.1-preview.36", "build": 438, "title": "Rex v0.1.1-preview.36 (Windows)", "releasedAt": "2026-11-23T23:02:53.578Z", "path": "windows/0.1.1-preview.36.json"}]}"""
     >

type Log =
    JsonProvider<
        """{"schemaVersion": 1, "platform": "mac", "version": "0.1.0-preview.33", "build": 2061, "title": "Rex v0.1.0-preview.33 (Mac)", "releasedAt": "2026-11-19T18:32:46.721Z", "previousVersion": "0.1.0-preview.32", "commit": "1a480a41a003ce9c3488c647cae2c747abaf5d23", "baseCommit": "3baad338739d6fce384fb877cd4c9c358b714254", "includes": [{"platform": "server", "version": "0.1.0-preview.21", "commit": "202b1b3fc0219883112258a8d0f9f95e2d47daa9" }], "markdown": "markdown string"}"""
     >

let changelog = Changelogs.Load(BASE_URL + "index.json")

let output =
    Array.take numLogs changelog.Releases
    |> Array.map (fun r -> Log.AsyncLoad(BASE_URL + r.Path))
    |> Async.Parallel
    |> Async.RunSynchronously
    |> Array.map (fun l -> sprintf $"## {l.Platform} - {l.Version}\n\n{l.Markdown}")
    |> String.concat ("\n---\n")

let rich =
    command "rich" {
        args [ "-m"; "--force-terminal"; "-" ]
        stdin (ReadFrom.string output)
        stderr PipeTo.stderr
        buffered
    }

let less =
    command "less" {
        args [ "-R" ]
        stderr PipeTo.stderr
    }


let task =
    task {
        let! richResult = rich
        let pager = PipeSource.FromString(richResult.StandardOutput) |>> less

        let! res =
            pager.ExecuteAsync(fun startInfo -> startInfo.RedirectStandardOutput <- false)

        return res.ExitCode
    }

exit task.Result
