---
description: Add a new MCP server to this project by answering a few questions. Creates or updates .vscode/mcp.json.
arguments: Optional server name or URL to pre-fill answers.
output: .vscode/mcp.json updated with the new server entry
usage: Paste this prompt into Copilot Chat
---

## Prompt

I want to add an MCP server to this project. Ask me the following questions one by one, then generate the configuration.

**Step 1 — Server type**
Ask: "Is this MCP server remote (HTTP URL) or local (runs as a process via npm/npx/command)?"

**Step 2 — Based on the answer:**

If **remote (HTTP)**:
- Ask: "What is the server URL?"
- Ask: "Does it require authentication? (none / API key / Bearer token)"
- If auth needed: "What environment variable name should hold the key? (e.g. MY_SERVER_API_KEY)"
- Ask: "What name do you want to give this server? (used as the key in mcp.json)"

If **local (process)**:
- Ask: "How is it launched? (npx package / node script / other command)"
- Ask: "What is the package name or command? (e.g. @modelcontextprotocol/server-github)"
- Ask: "Does it need any environment variables? List them (or 'none')"
- Ask: "What name do you want to give this server?"

**Step 3 — Generate and apply**

Once you have the answers:
1. Read `.vscode/mcp.json` if it exists, otherwise start from `{ "servers": {} }`.
2. Add the new server entry using the correct format:

   For remote:
   ```json
   "<name>": {
     "type": "http",
     "url": "<url>",
     "headers": {
       "Authorization": "Bearer ${env:<ENV_VAR>}"
     }
   }
   ```
   (omit `headers` if no auth needed)

   For local:
   ```json
   "<name>": {
     "command": "npx",
     "args": ["-y", "<package>"],
     "env": {
       "<ENV_VAR>": "${env:<ENV_VAR>}"
     }
   }
   ```
   (omit `env` if no env vars needed)

3. Write the updated `.vscode/mcp.json`.
4. If any environment variables are needed, remind the user to add them locally (never commit secrets).
5. Return a summary: server name, type, and next step to verify it works (`MCP: List Servers` in VS Code command palette).

## Rules

- Never hardcode API keys or secrets — always use `${env:VAR_NAME}` references.
- If `.vscode/mcp.json` already exists, merge — do not overwrite the whole file.
- If `.vscode` directory doesn't exist, create it.
- Suggest adding any required env vars to `.env.example` (without values) so teammates know what to set.
