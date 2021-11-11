# The Implicit Genome Simulator

The goal of this app is to do a population simulator based roughly on ideas from the book "The Implicit Genome".
Essentially, genomes have an implicit range and high parameterization.  Therefore, mutations aren't "random"
in the sense of the modern synthesis, but only "randomized".  The goal is to look at population dynamics
under this condition.

## Running

The easiest way to run this is:

```
rails console
s = Simulator.new.reset.run_until!(5)
s.organisms.size
```

This will tell you how many organisms remain after 5 iterations.


