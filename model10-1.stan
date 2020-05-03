// model10-1.stan
// Model: specification (local-level model with known parameters)

data{
  int<lower=1>   t_max;    // Time series length
  vector[t_max]   y;       // Observations

  cov_matrix[1]   W;       // Variance of state noise
  cov_matrix[1]   V;       // Variance of observation noise
  real           m0;       // Mean of prior distribution
  cov_matrix[1]  C0;       // Variance of prior distribution
}

parameters{
  real           x0;       // State [0]
  vector[t_max]   x;       // State [1:t_max]
}

model{
  // Likelihood part
  /* Observation equation; see also equation (5.11) */
  for (t in 1:t_max){
    y[t] ~ normal(x[t], sqrt(V[1, 1]));
  }

  // Prior part
  /* Prior distribution for state */
  x0   ~ normal(m0, sqrt(C0[1, 1]));

  /* State equation; see also equation (5.10) */
  x[1] ~ normal(x0, sqrt(W[1, 1]));
  for (t in 2:t_max){
    x[t] ~ normal(x[t-1], sqrt(W[1, 1]));
  }
}
