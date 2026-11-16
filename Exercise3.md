# The GPU that was mostly waiting

About 60 minutes · 1 GPU · the slow baseline runs about 2 minutes, fixed runs take seconds

## The situation

A colleague's image classifier trains correctly and reaches good accuracy. It is also painfully slow, and they want to scale it up to a real dataset next month. Their plan is to "optimise the convolutions", because that's where the maths is. There's even a `TODO` in the code saying so.
Before anyone rewrites anything, you want to know where the time actually goes. Your job: use the agent to profile the script, find out what really dominates, fix it one change at a time, and measure each fix.
The script contains several deliberate performance mistakes, and one piece of misleading advice. Part of the exercise is finding out whether the agent follows the evidence or the comments.

## What you're given

Work in `materials/ex3-slow-training/`. If OpenCode is open, quit it (type `/exit`), then start it there:

```bash
cd /scratch/project_462001520/$USER/agent-workshop/materials/ex3-slow-training
module load Local-LAIF lumi-aif-agents
opencode
```

`train_shapes.py` trains a small convolutional network to tell circles, squares and crosses apart in noisy 48×48 images. It generates its own data, so there is nothing to download, and it reports time per step and test accuracy. With `--profile` it profiles ten steady-state steps instead of training, and writes a timeline to `trace.json`. It works as it stands, and the model should not need to change.

`job.sh` runs the script on one GPU; anything you put after `job.sh` on the `sbatch` line is passed on to the script. `setup.sh` prepares the folder: run it once with the workshop project, as `bash setup.sh project_462001520`, and it fills in job.sh, sets up Git and commits the starting point. `RESULTS.md` is the table to fill in.

Submit two jobs. Both run the same script, and each writes its results to its own file:

```bash
sbatch job.sh                                  # normal run   → slow-training_<job ID>.out
sbatch --job-name=profile job.sh --profile     # profile run  → profile_<job ID>.out
```

Both take about 2 minutes. Check whether they're still running with squeue --me: when your jobs no longer appear in the list, they're done.

Now start the agent in the same folder:

```bash
module load Local-LAIF lumi-aif-agents
opencode
```

Keep this terminal for OpenCode. For sbatch and squeue later, open a second terminal (another Login node shell at www.lumi.csc.fi) and cd to the same folder. Slurm doesn't work inside OpenCode.


##  Part 1 — Find the slow part (10 min) 

Ask the agent:

```bash
Read train_shapes.py. Without running anything, which part do you think takes most of the time?
```

Write down its answer. Did it just repeat the TODO?

When the profile job has finished, paste the profile output (from the .out file of the --profile job) into OpenCode and ask:

```bash
Here is the profile. What actually takes most of the time? Show me the profile rows and the lines of code.
```

Was the first guess right?

## Part 2 — Fix it and measure (15 min)

Ask the agent:

```bash
Fix only that one problem. Don't change the model, the data, the batch size or the number of steps. How fast do you expect it to be now?
```

Check the change with git diff, then run it again:

```bash
sbatch job.sh
```

Compare the new time per step and test accuracy with the first run, and write both in RESULTS.md.

## Done when

You have one measured fix and one sentence answering: was the `TODO` right, and which numbers show it?

If the time barely moved, check whether you only moved the cost, for example into the logging or to another `.item()`.

## Going further

- Sweep the batch size. Find where the GPU stops waiting for the CPU and starts being the limit, and compare samples per second rather than time per step.
- Try `bfloat16` with `torch.autocast`. Watch which operations change in the profile and whether the accuracy survives.
- Compile the model with `torch.compile`. Does it help at this size, and what does the first step cost?
- Ask the agent whether switching to `float64` would make this much slower on LUMI's GPUs, and check the answer against the MI250X specifications. The right answer depends on the hardware, and many agents answer from experience with consumer GPUs.


