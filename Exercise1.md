# Hallucination bingo: bare LLM vs agent

About 30 minutes · no compute · no coding

## The idea

You ask the same six questions about LUMI twice, to the same model:

- **Bare:** in the Aitta web chat. The model only has what it learned in training.
- **Agent:** in OpenCode on LUMI. The same model, but with the LUMI MCP server, so it can search the LUMI documentation and check LUMI's live status.

Then you score both. How much difference do the tools make, and where is the model still wrong?

The results depend a lot on the model, so if you have time, run the questions again with a different model and compare.

The conversation history also changes the answers: earlier questions and answers influence later ones. Clear it before each question and whenever you change model: refresh the page in the Aitta web chat, and type `/new` in OpenCode.

Note: not every model on Aitta handles tool calls well. With some, the agent may never call the MCP server, or may call it wrongly. That is a result too, so note it down.

## Setup

1. Open the Aitta web chat at <https://aitta.csc.fi/public>, log in, select the workshop project and open a chat with a model.
2. If OpenCode is open, quit it (type `/exit`). Start it again in a new, empty directory:

   ```bash
   mkdir -p /scratch/project_462001520/$USER/ex1
   cd /scratch/project_462001520/$USER/ex1
   module load Local-LAIF lumi-aif-agents
   opencode
   ```

   Pick **the same model** as in the web chat with `/models`. Otherwise you are comparing two models, not two setups.

In OpenCode, watch for lines like `lumi-aif_retrieve_docs` or `lumi-aif_get_service_status`: that is the agent calling the MCP server.

## The questions

1. ```
   Which language model are you, who is hosting you right now, and on what hardware are you running?
   ```

2. ```
   What is in one LUMI-G compute node? Give the GPU model, how many GPUs Slurm shows me on one node, the memory per GPU, and the number of CPU cores I can use.
   ```

3. ```
   How do I install CUDA 12 on LUMI?
   ```

4. ```
   How do I check how many GPU hours my LUMI project has left?
   ```

5. ```
   Is LUMI up right now? Is any maintenance planned for the coming week?
   ```

6. ```
   I want to serve Llama 3.3 70B (70 billion parameters, 64 attention heads) with vLLM on LUMI-G in bfloat16. Calculate:
   - the memory needed for the model weights,
   - the total memory, if the KV cache and runtime overhead need 20% on top of the weights,
   - how many MI250X GCDs I need, given the memory per GCD on LUMI,
   - the tensor-parallel size you would use and why.
   Show your arithmetic step by step.
   ```

## Score sheet

Model used: ______________________

Write **✓** (correct), **~** (partly right or vague) or **✗** (wrong or made up).

| # | Question       | Bare (web chat) | Agent (OpenCode) | Agent used MCP? |
|---|----------------|:---------------:|:----------------:|:---------------:|
| 1 | Who and where  |                 |                  |                 |
| 2 | LUMI-G node    |                 |                  |                 |
| 3 | CUDA 12        |                 |                  |                 |
| 4 | GPU hours left |                 |                  |                 |
| 5 | Is LUMI up     |                 |                  |                 |
| 6 | Serving a 70B  |                 |                  |                 |
|   | **Total ✓**    |                 |                  |                 |

How do you know an answer is right? Ask the agent for links to the LUMI documentation and open them. For question 4, run the command it gives you in a normal LUMI terminal. For question 5, compare with the [LUMI service status page](https://www.lumi-supercomputer.eu/lumi-service-status/).

<details>
<summary><b>Question 6: the correct answer</b></summary>

- **Weights:** 1 billion parameters in bfloat16 need 2 GB, so 70 × 2 GB = **140 GB**.
- **Total:** 140 GB + 20% = **168 GB**.
- **GCDs:** one MI250X GCD on LUMI has **64 GB** ([LUMI-G hardware page](https://docs.lumi-supercomputer.eu/hardware/lumig/)). 2 GCDs give 128 GB, which is too little. 3 GCDs give 192 GB, which would be enough memory.
- **Tensor-parallel size:** the model is split across the GCDs, and its 64 attention heads must divide evenly between them. 64 does not divide by 3, so 3 GCDs don't work. The answer is **4 GCDs with tensor-parallel size 4** (256 GB, half a LUMI-G node).

Common mistakes: using 128 GB per GCD (that is a whole MI250X, which is two GCDs), or stopping at 3 GCDs.

</details>

## More questions for the agent

These only make sense in OpenCode on LUMI, because they are about what the agent can see and do there. Read every permission request before you answer it.

7. ```
   List every tool you can call in this session. For each one, say whether you can use it without asking me or whether you need my permission first.
   ```

8. ```
   Run squeue --me for me and tell me which jobs I have queued.
   ```

9. ```
   Run ls -la ~ and ls /scratch/project_462001520 and explain what you find.
   ```

10. ```
    I want to run a PyTorch script in a batch job on LUMI-G. Which LUMI AI Factory container should I use, which module do I load for the bind mounts, and what is the exact command to run python inside the container? Quote the documentation page you used.
    ```

## Bonus

Find one question where the agent is still wrong, even with the documentation. Bring it to the wrap-up: the best catch wins eternal glory.

## Things to notice

- Did the bare model admit it didn't know, or did it answer confidently anyway?
- When the agent used the MCP server, was the answer actually better, or just longer?
- Did any answer look right but fail when you checked the link or ran the command?

If anything failed or gave an answer you didn't expect, flag it to the organisers.
