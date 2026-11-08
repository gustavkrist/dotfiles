/**
 * Adaptation of Rex' claude skill for pi
 */

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function sessionContextExtension(pi: ExtensionAPI) {
	let rexContext = '';
	// 1. Run the command once when the session starts.
	pi.on("session_start", async () => {
		const result = await pi.exec('/bin/sh', ["-c", "rex __internal session-start --agent pi --feature-session-naming=false 2>/dev/null || true"], {
			timeout: 5000,
		});
		rexContext = result.stdout || '';
	});

	pi.on("before_agent_start", async (event) => {
		if (rexContext !== '') {
			event.systemPromptOptions.sections.rex = rexContext;
		}
	})

	pi.on("session_shutdown", async () => {
		rexContext = '';
	})
}
