// model10-4.stan
// Model: specification (local-level model + seasonal model (time-domain approach))

data{
  int<lower=1>    t_max;            // Time series length
  vector[t_max]       y;            // Observations

  vector[12]         m0;            // Mean vector of prior distribution
  cov_matrix[12]     C0;            // Covariance matrix of prior distribution
}

parameters{
  real              x0_mu;          // State (level component) [0]
  vector[11]        x0_gamma;       // State (seasonal component) [0]
  vector[t_max]      x_mu;          // State (level component) [1:t_max]
  vector[t_max]      x_gamma;       // State (seasonal component) [1:t_max]

  real<lower=0>      W_mu;          // Variance of state noise (level component)
  real<lower=0>      W_gamma;       // Variance of state noise (seasonal component)
  cov_matrix[1]      V;             // Covariance matrix of observation noise
}

model{
  // Likelihood part
  /* Observation equation */
  for (t in 1:t_max){
    y[t] ~ normal(x_mu[t] + x_gamma[t], sqrt(V[1, 1]));
  }

  // Prior part
  /* Prior distribution for state (level component) */
  x0_mu ~ normal(m0[1], sqrt(C0[1, 1]));

  /* State equation (level component) */
    x_mu[1] ~ normal(x0_mu     , sqrt(W_mu));
  for(t in 2:t_max){
    x_mu[t] ~ normal( x_mu[t-1], sqrt(W_mu));
  }

  /* Prior distribution for state (seasonal component) */
  for (p in 1:11){
    x0_gamma[p] ~ normal(m0[p+1], sqrt(C0[(p+1), (p+1)]));
  }

  /* State equation (seasonal component) */
    x_gamma[1] ~ normal(-sum(x0_gamma[1:11])                           ,
                                                                     sqrt(W_gamma));
  for(t in 2:11){
    x_gamma[t] ~ normal(-sum(x0_gamma[t:11])-sum(x_gamma[     1:(t-1)]),
                                                                     sqrt(W_gamma));
  }
  for(t in 12:t_max){
    x_gamma[t] ~ normal(                    -sum(x_gamma[(t-11):(t-1)]),
                                                                     sqrt(W_gamma));
  }

  /* Prior distribution for W and V: noninformative prior distribution (utilizing the default setting) */
}
