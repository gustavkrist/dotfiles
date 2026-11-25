#!/usr/bin/env bash
set -euxo pipefail

dirname="$1"
binname="$2"
dotnet new console -lang "F#" -o "src/$dirname"
dotnet sln add "src/$dirname"
dotnet add "src/$dirname" reference src/Shared

line=$(grep -m 1 -n 'TargetFramework' "src/$dirname/$dirname.fsproj" | cut -d: -f1)
gsed -i "${line}a \    <AssemblyName>$binname</AssemblyName>" "src/$dirname/$dirname.fsproj"
