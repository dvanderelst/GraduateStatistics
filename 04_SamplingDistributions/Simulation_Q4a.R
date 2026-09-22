repeats <- 100000
sample_size <- 2
mu <- 50
sigma <- 12

standard_deviations <- seq(1:repeats)

for (i in 1:repeats)
  {
  sample <- rnorm(sample_size, mu, sigma)
  sd_sample <- sd(sample)
  standard_deviations[i] <- sd_sample
}

variances <- standard_deviations **2

average_sd <- mean(standard_deviations)
average_var <- mean(variances)
p_sd <- mean(standard_deviations < sigma)
p_var <-mean(variances < (sigma**2))

average_sd
average_var
p_sd
p_var

par(mfrow = c(1,2))
hist(standard_deviations)
hist(variances)