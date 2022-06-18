#!/usr/bin/env python3

import iterm2
import os
import subprocess
import sys
import AppKit
from time import sleep
bundle = "com.googlecode.iterm2"
if not AppKit.NSRunningApplication.runningApplicationsWithBundleIdentifier_(bundle):
    AppKit.NSWorkspace.sharedWorkspace().launchApplication_("iTerm")

fp = sys.argv[1]


async def main(connection):
    async with iterm2.SessionTerminationMonitor(connection) as mon:
        await iterm2.Window.async_create(
            connection, profile="popup_editor_path",
            command=f"zsh -c \"sleep 0.1; {os.getenv('HOME')}/.config/lvim/scripts/lunarvim_iterm {fp}\""
        )
        subprocess.call(["osascript", "-e", 'activate application "iTerm"'])
        while True:
            await mon.async_get()
            break


iterm2.run_until_complete(main)
