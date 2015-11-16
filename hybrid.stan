data {
int<lower=0> N; // number of data points
real obs[N]; // response
int pop;
int i0;
real epi;
}
parameters {
// need to put upper/lower bounds on parameters
//  ... otherwise chain wanders off to outer space
real <lower=0.01,upper=0.2> beta;
real <lower=0.1,upper=0.99> reporting;
real <lower=0.1,upper=1> effprop;
real <lower=0.1> I[N];
}
model {
vector[N] pSI;
vector[N] S;
vector[N] shap;
S[1] <- effprop*pop;
pSI[1]<- 1 - (1-beta)^i0;
shap[1] <- pSI[1]*S[1]/(1-pSI[1]+epi);
print("S=",S[1],"; pSI=",pSI[1],"; shap=",shap[1],"; I=",I[1]);
I[1] ~ gamma(5.0,1.0);
print("S=",S[1],"; pSI=",pSI[1],"; shap=",shap[1],"; I=",I[1]);
for (t in 2:N) {
shap[t] <- pSI[t-1]*S[t-1]/(1-pSI[t-1]+epi);
I[t] ~ gamma(exp(shap[t]),1/(1-pSI[t-1]+epi));
S[t] <- S[t-1] - I[t];
pSI[t] <- 1.0 - (1.0-beta)^I[t];
obs[t] ~ gamma(reporting*I[t]/(1.0-reporting+epi),1.0/(1.0-reporting+epi));
}
}