#!/usr/bin/env python3

import iterm2
import os
import subprocess
import sys
import AppKit
bundle = "com.googlecode.iterm2"
if not AppKit.NSRunningApplication.runningApplicationsWithBundleIdentifier_(bundle):
    AppKit.NSWorkspace.sharedWorkspace().launchApplication_("iTerm")

ft = sys.argv[1]

if len(sys.argv) > 2:
    subprocess.call(["osascript", "-e", 'tell application "System Events" to keystroke "x" using command down'])
    os.system(f"pbpaste > /tmp/popup/{ft}.tmp")
else:
    with open(f"/tmp/popup/{ft}.tmp", "w"):
        pass


async def main(connection):
    async with iterm2.SessionTerminationMonitor(connection) as mon:
        await iterm2.Window.async_create(
            connection, profile="popup_editor",
            command=f"/Users/gustavkristensen/scripts/nvim_popup {ft}"
        )
        subprocess.call(["osascript", "-e", 'activate application "iTerm"'])
        while True:
            await mon.async_get()
            subprocess.call(["osascript", "-e", 'tell application "System Events" to keystroke "v" using command down'])
            break


iterm2.run_until_complete(main)
