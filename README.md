# Run AI agents with LUMI – Nordic AI Factory Summit 2026 workshop

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
git clone https://github.com/lumi-ai-factory/Run-AI-agents-with-LUMI-Workshop.git agent-workshop
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
3. Pick an LLM from the list, or type `/models` and filter by `aitta`. A model that is already running ([check in Aitta](https://aitta.csc.fi/public)) saves you a wait.

Good to know:
- OpenCode saves the token in your home directory, so you only run `/connect` again when the token expires.
- Always check the status line at the bottom of the OpenCode window before your first prompt. It shows which LLM your prompts and files are sent to, and where it is hosted.

### 5. Watch the agent loop

Ask: 

```
Look in this directory and tell me what's here. If it's empty, also check whether there are any hidden files or folders.
```

Choose Allow once.

> [!warning]
> Choose "Allow once" unless you are sure. "Allow always" lets the agent do that kind of action freely for the rest of the session, and the agent can also reach the folder where OpenCode keeps your API token.

### 6. Let the agent write a job, submit it yourself

Use the agent for what it is good at, while you stay in charge of the shared system.

Ask:

```
First, create a Python script hello.py that prints "hello from LUMI", the hostname of the node it runs on, and the current date and time.

Then write a Slurm batch script job.sh for LUMI that runs hello.py on one CPU core for at most 5 minutes, using account project_462001520. Check the LUMI documentation for the right partition, and write the job's output to a file named slurm-<job ID>.out.

Save both files in the current directory. Do not try to submit the job.
```

Approve the file write with Allow once. Then check the script yourself against [the LUMI Slurm documentation](https://docs.lumi-supercomputer.eu/runjobs/scheduled-jobs/batch-job/): account, partition, time limit and resources.

Submit it from a second terminal (another **Login node shell**), outside OpenCode:

```
cd /scratch/project_462001520/$USER/first-steps
sbatch job.sh
squeue --me
cat slurm-*.out        # after the job finishes
```

The output file contains `hello from LUMI`.

If it fails: paste the `sbatch` error into OpenCode and ask the agent to fix the script. Inside the container, `sbatch: command not found` is expected.

## AI Agents on LUMI — Exercises

Four exercises to test what a coding agent can and cannot do for you on LUMI, hopefully teaching you something useful in a fun way :)

You will work with OpenCode in the LUMI AI Factory container, using an LLM on Aitta and the LUMI MCP server for documentation (see [Setup](#setup)).

All exercises are small: at most one GPU, and jobs run for seconds or minutes, not hours.

## Ground rules
1. You are in charge. Every command the agent runs is executed as you. The container keeps the agent away from Slurm, but it can still change or delete your files, so read every permission request before approving it.
2. The agent writes, you submit. Slurm is not available inside the container. When a job script is ready, check it and run sbatch yourself from a second terminal: open another **Login node shell** at www.lumi.csc.fi, `cd` to the same directory and run `sbatch job.sh`.
3. Verify, don't trust. Ask the agent for links to the LUMI documentation it used, and open them.
4. Synthetic data only. Never give the agent sensitive data or credentials.

## The exercises

Each exercise has its own instructions file. Pick the ones that interest you, or bring your own code. Exercises 0 and 1 need no coding: just follow their instructions. The other exercises come with code, in the directories listed below.

If OpenCode is still open from the setup, quit it first (type `/exit`): each exercise tells you which directory to start it in.

| # | Exercise | What you do | You need | Time |
|---|---|---|---|---|
| 0 | [Coffee tracker](Exercise0.md) | Ask the agent whether a colleague's script is safe to run, and see what it does with instructions hidden in the files. | Nothing, no coding. | 10 min |
| 1 | [Hallucination bingo](Exercise1.md) | Ask the same LUMI questions to a bare model in the web chat and to the agent with the LUMI docs, then score the answers. | Nothing, no coding. | 30 min |
| 2 | [Laptop to LUMI](Exercise2.md) | Get a PyTorch script written for an NVIDIA laptop running on a LUMI GPU, in a container, as a batch job. | Some Python and Slurm. Good if you want to move your own code to LUMI. | 30 min, 1 GPU |
| 3 | [Slow training](Exercise3.md) | Profile a slow PyTorch training script, find where the time goes, and fix it one change at a time. | Comfortable with PyTorch training loops. Best if you do ML yourself. | 60 min, 1 GPU |

## Bring your own code

You are also welcome to work on your own code instead of the remaining exercises, for example your own research or something you are curious about.

## When something fails

Note it down. "The agent got this wrong" is a result: one goal today is to learn where agents help and where they don't. We're also testing whether the open models on Aitta are good enough to drive an agent at all, so failures that look like the model's fault are useful too. Bring your examples to the wrap-up discussion.

And the conversation doesn't have to end there. Mahnoor and Artur, who put this workshop together, are staying for the evening mingling event. Come find us! We genuinely want to hear how it went for you: we'd be super happy to discuss your findings and what you thought of the workshop!

## Optional: share your session

Your sessions help us improve the setup, and they also show us where agents actually go wrong on LUMI. We're still learning that ourselves. If you're happy to share, quit OpenCode and export a session from your working directory:

```bash
module load Local-LAIF lumi-aif-agents     # if this is a new terminal
opencode export > ~/agent-workshop-session.json
```

Select your session when asked, and send the file to the organisers. Check it first: it contains everything you typed and everything the agent read. Email it to mahnoor.mahnoor@csc.fi

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

### Want to learn more?

How to keep OpenCode contained, and what it can do without asking you? See the [OpenCode page](https://lumi-ai-factory.github.io/agent-ecosystem/02_opencode/) of the LUMI agent ecosystem guide.

What the LUMI MCP server's tools do, how to add it to Claude Code, Codex or other harnesses, and how to call it yourself with curl? See the [MCP server page](https://lumi-ai-factory.github.io/agent-ecosystem/03_mcp_server/).

## Credits

- Source code of the LUMI AI Factory agent environment: https://github.com/lumi-ai-factory/laifs-agent-env
- Guide to Aitta, OpenCode and MCP servers on LUMI: https://lumi-ai-factory.github.io/agent-ecosystem/
