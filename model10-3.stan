// model10-3.stan
// Model: specification (local-level model with unknown parameters, utilizing Kalman filter)

data{
  int<lower=1>    t_max;   // Time series length
  matrix[1, t_max]    y;   // Observations

  matrix[1, 1]    G;       // State transition matrix
  matrix[1, 1]    F;       // Observation matrix
  vector[1]      m0;       // Mean of prior distribution
  cov_matrix[1]  C0;       // Variance of prior distribution
}

parameters{
  cov_matrix[1]   W;       // Variance of state noise
  cov_matrix[1]   V;       // Variance of observation noise
}

model{
  // Likelihood part
  /* Function calculating likelihood of the linear Gaussian state space model */
  y ~ gaussian_dlm_obs(F, G, V, W, m0, C0);

  // Prior part
  /* Prior distribution for W and V: noninformative prior distribution (utilizing the default setting) */
}
