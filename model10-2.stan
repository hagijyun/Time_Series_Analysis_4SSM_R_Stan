// model10-2.stan
// Model: specification (local-level model with unknown parameters)

data{
  int<lower=1>   t_max;    // Time series length
  vector[t_max]   y;       // Observations

  real           m0;       // Mean of prior distribution
  cov_matrix[1]  C0;       // Variance of prior distribution
}

parameters{
  real           x0;       // State [0]
  vector[t_max]   x;       // State [1:t_max]

  cov_matrix[1]   W;       // Variance of state noise
  cov_matrix[1]   V;       // Variance of observation noise
}

model{
  // Likelihood part
  /* Observation equation */
  for (t in 1:t_max){
    y[t] ~ normal(x[t], sqrt(V[1, 1]));
  }

  // Prior part
  /* Prior distribution for state */
  x0   ~ normal(m0, sqrt(C0[1, 1]));

  /* State equation */
  x[1] ~ normal(x0, sqrt(W[1, 1]));
  for (t in 2:t_max){
    x[t] ~ normal(x[t-1], sqrt(W[1, 1]));
  }

  /* Prior distribution for W and V: noninformative prior distribution (utilizing the default setting) */
}
