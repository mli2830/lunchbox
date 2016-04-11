- process error: chain beta-binomial
- observation error: chain beta-binomial
i.e.
```
foi[t]  <- (1-(1-p)^I) # susceptible prob/generation of infection
I[t]    ~  dbetabinom(S[t-1],foi[t],phi1)
S[t]    <- S[t-1]-I[t]
Iobs[t] ~  dbetabinom(I[t],phi2)
```

- fitting model: (**chain X**, **hybrid chain X [moment-matching/chain-gamma]**, decorrelated hybrid chain X (JD's trick for decorrelating observation and process uncertainty)

x

generalized distribution of cases (X): **binomial**, **beta-binomial**, Poisson, neg bin

x

platform: PyMC, Stan, **JAGS** (NIMBLE)? pomp? Dexter's code?

x

sampling type: HMC, slice (block MH, conjugate) ? SMC (e.g. iterating filtering 2)? ABC? filtering (latent variables) + HMC (top level)

--
left out (for now) from Ebola models:
  - generation interval (multi-generation) 
  - saturation/behaviour effects


## To do

### Now(ish)

- CP: write a pipeline skeleton; runs factorial combinations, to be specified as input/config files; generate (non)supercomputer script; run different commands (R vs Python) based on config script
- ML: clean up repo; make sure all cases on all platforms work (JAGS-via-NIMBLE, binomial or beta-binomial (process or observation error)
- JD: support Mike and Carl
- BB: ???

### Lower priority

  - get PyMC running (ML)
  - write up hybridization/decorrelation definitions (JD)
  - decide on fake data
      - range of parameters?
      - LHC
      - objective/loss function: parameter estimates? forecasts?
  - write out generalized distribution definition (JD? BMB?)
  - talking points for introduction and discussion
      - Lekone & Finkenstadt, Gavin Gibson (Steftaris and Gibson, Gibson and Renshaw)
      - Aaron King comment about IF2 > MCMC for epidemics?
  - pomp chain binomial?
  

##  Miscellaneous junk

- [JAGS macros](http://stats.stackexchange.com/questions/85690/how-to-conditionally-run-element-of-jags-script-based-on-user-supplied-variable)
