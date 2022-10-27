data {
  int<lower=1> N;  // observations
  int<lower=1> J;  // counties
  array[N] int<lower=1, upper=J> county;
  vector[N] y;     // radon
  vector[N] x;     // floor
  vector[J] uranium;     // uranium
}
transformed data {
  vector[N] u = uranium[county];
  print(u);
  matrix[N, 2] xs = [x', u']';
}
parameters {
  vector[J] alpha;
  vector[2] beta;
  real<lower=0> sigma;
}
transformed parameters {
  vector[N] alphas = alpha[county];
}
model {
  y ~ normal_id_glm(xs, alphas, beta, sigma);  
  alpha ~ normal(0, 2.5);
  beta ~ normal(0, 2.5);
  sigma ~ normal(0, 5);
}
generated quantities {
  array[N] real y_rep = normal_rng(alpha[county] + beta[1] * x + beta[2] * u, sigma);
}
