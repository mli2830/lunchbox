model: (chain binomial, hybrid chain binomial [also called chain-gamma by ML], decorrelated CB (JD's trick for decorrelating observation and process uncertainty) + observation error

x

generalized distribution of cases: binomial, beta-binomial, Poisson, neg bin

x

platform: PyMC, Stan, JAGS (NIMBLE)? pomp? Dexter's code?

x

sampling type: HMC, slice (block MH, conjugate) ? SMC (e.g. iterating filtering 2)? ABC? filtering (latent variables) + HMC (top level)

--
left out (for now) from Ebola models:
  - generation interval (multi-generation) 
  - saturation/behaviour effects

--
To do:
  - get PyMC running (ML)
  - write up hybridization/decorrelation definitions (JD)
  - decide on fake data
      - range of parameters?
      - LHC
      - objective/loss function: parameter estimates? forecasts?
  - write out generalized distribution definition (JD? BMB?)
  - talking points for introduction and discussion
      - Lekone & Finkenstadt, Scottish guy who does continuous-time stochastic SIR estimation    
      - Aaron King comment about IF2 > MCMC for epidemics?
  - pomp CB? 
