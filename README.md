# Run AI agents with LUMI

The LUMI AI Factory agent environment is a [containerized environment](https://docs.lumi-supercomputer.eu/software/containers/singularity/) for running AI coding agents on LUMI in a more secure manner. Currently, we provide a container for using the open-source, terminal-based OpenCode AI coding agent. For more information on OpenCode, see the LUMI AI Factory blog post on connecting [OpenCode to a vLLM instance running on LUMI](https://lumi-supercomputer.eu/connecting-opencode-to-lumi/). The source code of the agent environment is available in a public [GitHub repository](https://github.com/lumi-ai-factory/laifs-agent-env).

## What you need

A LUMI account, access to the workshop project `project_462001520`, and an [Aitta API Token](https://aitta-auth.csc.fi/myToken) (choose the workshop project).

> Before you start:
> every command the agent runs is executed under your user account, and you are responsible for it. Read the [LUMI AI agent guide](https://docs.lumi-supercomputer.eu/development/ai-tools/ai-agent-guide/) before your first session. Never give the agent sensitive or confidential data.

## Setup

In this part you start the OpenCode harness in the LUMI AI Factory container, connect it to an LLM on Aitta, and watch how an agent reads files and asks for permission.

### 1. Open a terminal on LUMI

Go to [www.lumi.csc.fi](https://www.lumi.csc.fi), log in, and open **Login node shell**.

### 2. Prepare a safe working directory

Give the agent its own directory, under version control, so you can see and undo every change it makes.
```bash
export PROJECT=project_462001520     # the workshop project
mkdir -p /scratch/$PROJECT/$USER/first-steps     # your own directory in the project
cd /scratch/$PROJECT/$USER
git clone https://github.com/mahnoormahnoorr/Run-AI-agents-with-LUMI-Workshop.git agent-workshop
```

### 3. Start OpenCode in the container

Run the harness in the ready-made LUMI container. For this first try, start it in the empty `first-steps` directory, so the agent has nothing to read yet.

```bash
cd first-steps
module load Local-LAIF lumi-aif-agents
opencode
```

### 4. Connect to Aitta and pick an LLM

Inside OpenCode:
1. Type `/connect` and search for aitta.
2. Paste your Aitta API token.
3. Pick an LLM from the list, or type `/models` and filter by `aitta`. Use the model your instructor names, for example Qwen3.6-27B.

Good to know:
- OpenCode saves the token in your home directory, so you only run `/connect` again when the token expires, after 90 days.
- Always check the status line at the bottom of the OpenCode window before your first prompt. It shows which LLM your prompts and files are sent to, and where it is hosted.

### 5. Watch the agent loop

Ask: 

```
Look in this directory and tell me what's here. If it's empty, also check whether there are any hidden files or folders.
```

Choose Allow once.

> [!warning]
> Choose "Allow once" unless you are sure. "Allow always" lets the agent do that kind of action freely for the rest of the session, and the agent can also reach the folder where OpenCode keeps your API token.

## AI Agents on LUMI — Exercises

Four exercises to test what a coding agent can and cannot do for you on LUMI. You work with OpenCode in the LUMI AI Factory container, using an LLM on Aitta and the LUMI MCP server for documentation (see [Setup](#setup)).

All exercises are small: at most one GPU, and jobs run for seconds or minutes, not hours.

## Ground rules
1. You are in charge. Every command the agent runs is executed as you. Read every permission request; choose Allow once unless you are sure.
2. The agent writes, you submit. Slurm is not available inside the container. When a job script is ready, check it and run sbatch yourself from a second terminal: open another **Login node shell** at www.lumi.csc.fi, `cd` to the same directory and run `sbatch job.sh`.
3. Verify, don't trust. Ask the agent for links to the LUMI documentation it used, and open them.
4. Synthetic data only. Never give the agent sensitive data or credentials.

## The exercises

Each exercise has its own instructions file. Pick the ones that interest you, or bring your own code. Exercises 0 and 1 need no coding: just follow their instructions. The other exercises come with code, in the directories listed below.

If OpenCode is still open from the setup, quit it first (type `/exit`): each exercise tells you which directory to start it in.

| # | Instructions | Files | What it's about | Time |
|---|---|---|---|---|
| 0 | [Exercise0.md](Exercise0.md) | `materials/ex0-coffee-tracker/` | What happens when an agent reads someone else's project? | 10 min |
| 1 | [Exercise1.md](Exercise1.md) | — | Same questions, bare LLM vs agent with the LUMI MCP server. No code. | 30 min |
| 2 | [Exercise2.md](Exercise2.md) | `materials/ex2-laptop-to-lumi/` | A training script written for an NVIDIA laptop has to run on LUMI. | 30 min |
| 3 | [Exercise3.md](Exercise3.md) | `materials/ex3-slow-training/` | A slow training script: find out where the time really goes. | 60 min |

## Bring your own code

Once you have tried an exercise, you are welcome to work on your own code instead of the remaining exercises, for example your own research or a project you are curious about. 

## When something fails

Note it down. "The agent got this wrong" is a result, not a failure: one goal today is to learn where agents help and where they don't. Bring your examples to the wrap-up discussion.

## Optional: share your session

If you are happy to help us improve the setup, quit OpenCode and export a session from your working directory:

```bash
module load Local-LAIF lumi-aif-agents     # if this is a new terminal
opencode export > ~/agent-workshop-session.json
```

Select your session when asked, and send the file to the organisers. Check it first: it contains everything you typed and everything the agent read. Email it to mahnoor.mahnoor@csc.fi.

## After the workshop

### OpenCode on your own machine

On macOS or Linux, the quickest way to install OpenCode is the official install script:

```bash
curl -fsSL https://opencode.ai/install | bash
```

For Windows and other options, such as npm, Homebrew and Docker, see the [OpenCode installation guide](https://opencode.ai/docs/).

Out of the box, OpenCode uses OpenCode Zen, a model service run by the company that maintains OpenCode, so everything you type and every file the agent reads is sent to that company. To add Aitta and the LUMI MCP server instead, download this configuration and save it as `~/.config/opencode/opencode.json`, or open the section below to copy it:

[opencode.json](https://raw.githubusercontent.com/lumi-ai-factory/agent-ecosystem/main/public/assets/opencode.json)

<details>
<summary>Show the contents of opencode.json</summary>

```json title="~/.config/opencode/opencode.json"
{
  "$schema": "https://opencode.ai/config.json",
  "model": "aitta/Qwen/Qwen3.6-27B",
  "permission": {
    "bash": "ask",
    "edit": "ask",
    "webfetch": "ask",
    "websearch": "ask"
  },
  "mcp": {
    "lumi-aif": {
      "type": "remote",
      "url": "https://lumi-aif-agents.2.rahtiapp.fi/mcp",
      "enabled": true
    }
  },
  "provider": {
    "aitta": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "Aitta",
      "options": {
        "baseURL": "https://aitta-api.csc.fi/openai/v1"
      },
      "models": {
        "openai/gpt-oss-120b": { "name": "openai/gpt-oss-120b" },
        "Qwen/Qwen3-Coder-Next": { "name": "Qwen/Qwen3-Coder-Next" },
        "Qwen/Qwen3.6-35B-A3B": { "name": "Qwen/Qwen3.6-35B-A3B" },
        "Qwen/Qwen3.6-27B": { "name": "Qwen/Qwen3.6-27B" },
        "Qwen/Qwen3-VL-30B-A3B-Thinking": { "name": "Qwen/Qwen3-VL-30B-A3B-Thinking" },
        "MiniMaxAI/MiniMax-M2.7": { "name": "MiniMaxAI/MiniMax-M2.7" },
        "google/gemma-4-31b-it": { "name": "google/gemma-4-31b-it" },
        "google/gemma-4-26B-A4B-it": { "name": "google/gemma-4-26B-A4B-it" },
        "mistralai/Ministral-3-14B-Reasoning-2512": { "name": "mistralai/Ministral-3-14B-Reasoning-2512" },
        "meta-llama/Llama-3.3-70B-Instruct": { "name": "meta-llama/Llama-3.3-70B-Instruct" },
        "LumiOpen/Llama-Poro-2-70B-Instruct": { "name": "LumiOpen/Llama-Poro-2-70B-Instruct" },
        "swiss-ai/Apertus-70B-Instruct-2509": { "name": "swiss-ai/Apertus-70B-Instruct-2509" },
        "swiss-ai/Apertus-8B-Instruct-2509": { "name": "swiss-ai/Apertus-8B-Instruct-2509" }
      }
    }
  }
}
```

</details>

### Want to learn more about MCP servers on LUMI?

An LLM on its own knows little about LUMI, and what it knows may be out of date. The LUMI AI Factory runs a public MCP server that lets your agent look things up in the LUMI documentation and check LUMI's current status, so it can answer questions about LUMI more accurately and write code suited to the system. It works with any harness or app that supports MCP, such as OpenCode, Claude Code, Codex or VS Code, whichever LLM it uses. You do not need an account or an API token to use it.

### What it can do

The LUMI MCP server gives your agent two tools:

| Tool | What it does | Helps with questions like |
|:-----|:-------------|:--------------------------|
| `retrieve_docs` | Searches a regularly updated knowledge base of the [LUMI documentation](https://docs.lumi-supercomputer.eu/) and the [LUMI AI Guide](https://github.com/Lumi-supercomputer/LUMI-AI-Guide), and returns the most relevant passages with links to their sources | "How do I run PyTorch on LUMI?" |
| `get_service_status` | Reports LUMI's current status, planned maintenance and ongoing incidents | "Why is my job not starting? Is something down?" |

### Add the LUMI MCP server to your harness

#### OpenCode

On LUMI, the OpenCode container is already connected to the MCP server, so there is nothing to do. On your own machine, the `opencode.json` from [OpenCode on your own machine](#opencode-on-your-own-machine) already includes it.

#### Claude Code

Run this once to make the server available in all your projects:

```bash
claude mcp add --transport http --scope user lumi-aif https://lumi-aif-agents.2.rahtiapp.fi/mcp
```

See the [Claude Code MCP documentation](https://code.claude.com/docs/en/mcp) for other options.

#### Claude on the web

Settings → Connectors → Add custom connector, and paste the URL (https://lumi-aif-agents.2.rahtiapp.fi/mcp) 

#### Codex

Add these lines to `~/.codex/config.toml`:

```toml title="~/.codex/config.toml"
[mcp_servers.lumi-aif]
url = "https://lumi-aif-agents.2.rahtiapp.fi/mcp"
```

See the [Codex MCP documentation](https://learn.chatgpt.com/docs/extend/mcp?surface=cli) for other options.

#### Other harnesses

Most other harnesses and apps, such as VS Code, can connect to a remote MCP server too. Look in their documentation for how to add one, and give it the address `https://lumi-aif-agents.2.rahtiapp.fi/mcp`.

### 1. Find the MCP tools in OpenCode

On LUMI, the OpenCode container is already connected to the MCP server, so there is nothing to set up. Start OpenCode as in [Setup](#setup).

Check that an Aitta LLM is selected ([see here](#4-connect-to-aitta-and-pick-an-llm)), then ask:  

```txt
Which tools do you have from the LUMI MCP server, and what does each one do?
How's LUMI doing right now?
```
### 2. See exactly what the agent receives

Call `retrieve_docs` yourself, without any agent or LLM involved.
Run this in a terminal on LUMI or on your laptop. No login or token is needed:

```bash
curl -s https://lumi-aif-agents.2.rahtiapp.fi/mcp \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json, text/event-stream' \
  -d '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"retrieve_docs","arguments":{"query":"agent infrastructure","k":1}}}'
```

## Credits

- Source code of the LUMI AI Factory agent environment: https://github.com/lumi-ai-factory/laifs-agent-env
- Guide to Aitta, OpenCode and MCP servers on LUMI: https://lumi-ai-factory.github.io/agent-ecosystem/
