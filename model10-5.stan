// model10-5.stan
// Model: specification (local-level model + seasonal model (time-domain approach), utilizing Kalman filter)

data{
  int<lower=1>    t_max;           // Time series length
  matrix[1, t_max]    y;           // Observations

  matrix[12, 12]      G;           // State transition matrix
  matrix[12,  1]      F;           // Observation matrix
  vector[12]         m0;           // Mean vector of prior distribution
  cov_matrix[12]     C0;           // Covariance matrix of prior distribution
}

parameters{
  real<lower=0>       W_mu;        // Variance of state noise (level component)
  real<lower=0>       W_gamma;     // Variance of state noise (seasonal component)
  cov_matrix[1]       V;           // Covariance matrix of observation noise
}

transformed parameters{
    matrix[12, 12]    W;           // Covariance matrix of state noise

    for (k in 1:12){               // In Stan's matrices, the column-major access is effective
      for (j in 1:12){
             if (j == 1 && k == 1){ W[j, k] = W_mu;     }
        else if (j == 2 && k == 2){ W[j, k] = W_gamma;  }
        else{                       W[j, k] = 0;        }
      }
    }
}

model{
  // Likelihood part
  /* Function calculating likelihood of the linear Gaussian state space model */
  y ~ gaussian_dlm_obs(F, G, V, W, m0, C0);

  // Prior part
  /* Prior distribution for W and V: noninformative prior distribution (utilizing the default setting) */
}
