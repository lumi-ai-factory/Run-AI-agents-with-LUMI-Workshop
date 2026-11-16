# Text classification with BERT

About 30 minutes · 1 GPU · two steps

## The situation

The 20 newsgroups dataset contains about 20,000 Usenet messages in 20 topics. The script `pytorch_20ng_bert.py` takes a pre-trained BERT model and fine-tunes it to guess the topic of each message. Your job: get it running on LUMI, then use the agent to improve it, one change at a time.

## What you're given

Quit OpenCode if it's open (`/exit`). Then go to the exercise folder and submit the job right away, so it runs while you work:

```bash
cd /scratch/project_462001520/$USER/agent-workshop/materials/ex3-slow-training
sbatch job.sh pytorch_20ng_bert.py      # output → bert_<job ID>.out
```

Check whether it's still running with `squeue --me`: when your job no longer appears in the list, it's done.

Now start the agent in the same folder:

```bash
module load Local-LAIF lumi-aif-agents
opencode
```

Keep this terminal for OpenCode. For `sbatch` and `squeue` later, open a second terminal (another Login node shell at www.lumi.csc.fi) and cd to the same folder. Slurm doesn't work inside OpenCode.


##  Part 1 — Understand and run (10 min) 

While the job runs, ask the agent:

```bash
Read pytorch_20ng_bert.py and explain in a few sentences what it does: the data, the model and the training. What test accuracy and total training time do you expect on one LUMI GPU?
```

The agent asks permission to read the file: choose Allow once. Write down its predictions in `RESULTS.md`.

When the job has finished, open `bert_*.out` and note the total training time and the test accuracy. How close was the agent?

## Part 2 — Improve it (15 min)

Ask the agent:

```bash
Suggest one change that would make this model more accurate or faster to train, for example the batch size, number of epochs, learning rate, or a smaller model such as DistilBERT. Make only that one change, and predict the new accuracy and training time. Give me links to the documentation you used.
```

Open at least one of the links, and check the change, then run it again from your second terminal:

```bash
git diff
sbatch job.sh pytorch_20ng_bert.py
```

When it finishes, compare the new training time and test accuracy with the first run, and write both in `RESULTS.md`.

## Done when

You can answer in one sentence: did the change help, and was the agent's prediction right?

## Going further

- Try a second change, or a different Transformers model. Does the agent check the HuggingFace documentation, or answer from memory?
- Ask the agent to review the script for bugs. Hint: look closely at how the special token at the end of each sentence is added, and at what the test loss is.
- The training uses only one of the GPU's two halves (GCDs) on LUMI. Ask the agent what an MI250X GCD is, and check its answer against the LUMI documentation.


