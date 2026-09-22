repeats <- 100000

population_size <- 15000
sample_size <- 5
mu <- 50
sigma <- 12

population <- rnorm(population_size, mu, sigma)



sampled_penguins <- sample(population, sample_size, replace = TRUE)
result<-t.test(sampled_penguins)
low<-result$conf.int[1]
high<-result$conf.int[2]

contained<-seq(1:repeats) * 0
resampled_means <-seq(1:repeats) * 0
for(i in 1:repeats)
{
  new_sample <- sample(population, sample_size, replace = TRUE)
  mean_new_sample <- mean(new_sample)
  inside <- mean_new_sample > low & mean_new_sample < high
  resampled_means[i] <- mean_new_sample
  contained[i] <- inside
}

par(mfrow = c(2,2))
hist(population)
hist(resampled_means)
vli