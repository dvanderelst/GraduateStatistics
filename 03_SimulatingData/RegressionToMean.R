# Simulate sum of two distributions for n people
# 
# For each of n people:
#   1. Draw a value from Normal(mean1, sd1)
#   2. Draw a value from Normal(mean2, sd2)
#   3. Store the sum of the two values

# Parameters - edit these values

# Underlying variation
n <- 100
mean_property <- 0
sd_property <- 10

mean_noise <- 0
sd_noise <- 20

# Number of repeated noisy observations per person
n_replicates <- 20
# Selected extremes
n_extremes <- 5
# Study inclusion criterion
inclusion_criterion <- 20

# Join each person's two measurements with a line.
#   1 = everyone, faintly, with the selected extremes drawn over the top
#   0 = only the selected extremes
connect_all <- 1

# Draw n underlying true values
real_values <- rnorm(n, mean = mean_property, sd = sd_property)

# For each person, draw n_replicates noise values
noise_matrix1 <- matrix(rnorm(n * n_replicates, mean = mean_noise, sd = sd_noise), nrow = n, ncol = n_replicates)
# For each person and each replicate, compute the noisy observed value
observed_matrix1 <- real_values + noise_matrix1

# For each person, draw n_replicates noise values
noise_matrix2 <- matrix(rnorm(n * n_replicates, mean = mean_noise, sd = sd_noise), nrow = n, ncol = n_replicates)
# For each person and each replicate, compute the noisy observed value
observed_matrix2 <- real_values + noise_matrix2

# Average across columns (replicates) for each person
mean_observed1 <- rowMeans(observed_matrix1)
mean_observed2 <- rowMeans(observed_matrix2)

rg <- ceiling(max(abs(c(mean_observed1, mean_observed2))) * 1.1)

# Get indices of extremes
lowest_indices <- order(mean_observed1)[1:n_extremes]
highest_indices <- tail(order(mean_observed1), n_extremes)

par(mfrow=c(1,2))

# Plot mean_observed1 at x=1 and mean_observed2 at x=2 with jitter
# All dots gray, lowest in green, highest in red
plot(c(1, 2), range(c(mean_observed1, mean_observed2)), type = "n",
     xlab = "Measurement", ylab = "Value", xaxt = "n", xlim = c(0.5, 2.5), ylim = c(-rg, rg))

# Fix each person's jittered x position once. The highlights are drawn on top
# of the gray dots, so they have to reuse the same x -- jittering again would
# put the coloured dot beside the person it is meant to be marking, and leave
# the gray one showing next to it.
x1 <- jitter(rep(1, n), amount = 0.1)
x2 <- jitter(rep(2, n), amount = 0.1)

# Join each person's two measurements. Drawn before the points so the dots sit
# on top of the lines rather than being crossed out by them. The faint grey
# shows the general churn; the coloured ones are the story -- the people picked
# for being extreme the first time are the ones visibly walking back towards
# the middle the second time.
if (connect_all)
{
  segments(x1, mean_observed1, x2, mean_observed2, col = rgb(0, 0, 0, 0.12))
}

segments(x1[lowest_indices], mean_observed1[lowest_indices],
         x2[lowest_indices], mean_observed2[lowest_indices],
         col = "green", lwd = 1.5)
segments(x1[highest_indices], mean_observed1[highest_indices],
         x2[highest_indices], mean_observed2[highest_indices],
         col = "red", lwd = 1.5)

# All points in gray
points(x1, mean_observed1, pch = 19, col = "gray")
points(x2, mean_observed2, pch = 19, col = "gray")

# Highlight lowest and highest indices
points(x1[lowest_indices], mean_observed1[lowest_indices], pch = 19, col = "green", cex = 1.5)
points(x2[lowest_indices], mean_observed2[lowest_indices], pch = 19, col = "green", cex = 1.5)
points(x1[highest_indices], mean_observed1[highest_indices], pch = 19, col = "red", cex = 1.5)
points(x2[highest_indices], mean_observed2[highest_indices], pch = 19, col = "red", cex = 1.5)

axis(1, at = 1:2, labels = c("First", "Second"))

abline(h = -inclusion_criterion, col = "black", lty = 2)
abline(h = inclusion_criterion, col = "black", lty = 2)

# Histogram of the two sets of 100 measurements, overlaid
# Use the same breaks for both histograms
all_values <- c(mean_observed1, mean_observed2)
common_breaks <- seq(min(all_values), max(all_values), length.out = 21)

hist(mean_observed1, breaks = common_breaks, col = rgb(1, 0, 0, 0.5),
     xlab = "Mean Observed Value", main = "Overlaid Histograms")
hist(mean_observed2, breaks = common_breaks, col = rgb(0, 0, 1, 0.5), add = TRUE)
legend("topright", legend = c("First Measurement", "Second Measurement"),
       col = c(rgb(1, 0, 0, 0.5), rgb(0, 0, 1, 0.5)), pch = 15)




