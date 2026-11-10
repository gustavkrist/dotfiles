"""mitmproxy addon: keep real API keys off the sandbox container.

The container is started with dummy credentials (and points HTTP(S)_PROXY at
this proxy). For allow-listed hosts we replace whatever the client sent with
the real secret, which lives only in the proxy's environment.

Run on the *host*:

    mitmdump --listen-host 0.0.0.0 --listen-port 8899 \
             -s sbx-proxy/inject_auth.py

Rules are matched on request host; per-path rules are supported too. Add a
host here, then set the matching env var on the host (see `sbx`).
"""

from __future__ import annotations

import logging
import os
import re
import sys

from mitmproxy import http

log = logging.getLogger("sbx-proxy")

# Everything the client sends as a credential and that we consider a
# placeholder. Anything else is a real secret leaking out of the sandbox and
# gets logged loudly.
PLACEHOLDER_PREFIXES = ("sbx-dummy", "sk-sbx-dummy", "dummy", "-")

# host -> {header name: value template}. Templates are rendered with host env
# vars; a missing var fails the request instead of silently 401-ing.
RULES: dict[str, dict[str, str]] = {
    "api.neuralwatt.com": {"Authorization": "Bearer {NEURALWATT_API_KEY}"},
    # "api.anthropic.com": {"x-api-key": "{ANTHROPIC_API_KEY}"},
    # "api.openai.com": {"Authorization": "Bearer {OPENAI_API_KEY}"},
}

# Optional path-scoped overrides, checked before the host rules.
# (host, path regex) -> {header: template}
PATH_RULES: list[tuple[str, re.Pattern[str], dict[str, str]]] = [
    # ("api.example.com", re.compile(r"^/v1/(completions|responses)$"),
    #  {"Authorization": "Bearer {EXAMPLE_API_KEY}"}),
]

# Hosts the sandbox may talk to *through* the proxy without injection.
# Used when DENY_OTHERS is enabled.
PASS_THROUGH: set[str] = set()

# Flip to True for a deny-by-default egress policy (only RULES + PASS_THROUGH
# reach the network). This will break apt/npm/git unless you list those hosts.
DENY_OTHERS = False

_TEMPLATE = re.compile(r"\{([A-Za-z_][A-Za-z0-9_]*)\}")


def _render(template: str) -> str | None:
    missing = [name for name in _TEMPLATE.findall(template) if not os.environ.get(name)]

    def sub(match: re.Match[str]) -> str:
        return os.environ[match.group(1)]

    if missing:
        log.error("missing env var(s) on proxy host: %s", ", ".join(missing))
        return None
    return _TEMPLATE.sub(sub, template)


def _rules_for(host: str, path: str) -> dict[str, str] | None:
    for rule_host, pattern, headers in PATH_RULES:
        if host == rule_host and pattern.match(path):
            return headers
    return RULES.get(host)


def _is_placeholder(value: str) -> bool:
    value = value.strip()
    return not value or value.lower().startswith(PLACEHOLDER_PREFIXES)


class InjectAuth:
    def request(self, flow: http.HTTPFlow) -> None:
        host = flow.request.pretty_host
        headers = _rules_for(host, flow.request.path)

        if headers is None:
            if DENY_OTHERS and host not in PASS_THROUGH:
                log.warning("egress blocked: %s%s", host, flow.request.path)
                flow.response = http.Response.make(403, b"blocked by sbx-proxy\n")
            return

        for name, template in headers.items():
            existing = flow.request.headers.get(name, "")
            if not _is_placeholder(existing):
                log.warning(
                    "sandbox sent a real-looking %s to %s - dropping it", name, host
                )
            rendered = _render(template)
            if rendered is None:
                flow.response = http.Response.make(
                    500,
                    f"sbx-proxy: proxy host is missing credentials for {host}\n".encode(),
                )
                return
            flow.request.headers[name] = rendered

        # Never let a client-supplied credential tag along to an injected host.
        for name in ("X-Api-Key", "Api-Key", "x-goog-api-key"):
            if name in flow.request.headers and name not in headers:
                del flow.request.headers[name]

        log.info("%s %s%s (auth injected)", flow.request.method, host, flow.request.path)


addons = [InjectAuth()]


if __name__ == "__main__":
    sys.exit("run this with: mitmdump -s sbx-proxy/inject_auth.py")
