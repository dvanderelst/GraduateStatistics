# What happens to the 95% when the model leaves out something important?
#
# In this colony, older penguins are taller, and age also adds to weight.
# Height and age are linked.  We fit two models to the same samples:
#
#   with age:     weight ~ height + age   (the right model)
#   without age:  weight ~ height         (age left out)
#
# Without age, part of "older penguins are heavier" shows up as "taller
# penguins are heavier": the height slope takes over some of the age effect.
# That happens in every sample, always in the same direction.
#
# For each sample we compute the 95% confidence interval for the height
# slope and check whether it contains the true value.
#
# The link between height and age, and the effect of age, are made strong on
# purpose so the effect is easy to see.  Real cases are usually milder, but
# the mechanism is the same.

par(las = 1, bty = "l")    # horizontal axis numbers, no box around the plot

N <- 100000         # penguins in the population
n <- 50             # penguins in one sample
repeats <- 100      # how many samples (and intervals) to draw

set.seed(1)

# ----------------------------------------------------------------------
# The population.  Age comes first: older penguins are taller.
# ----------------------------------------------------------------------
age <- runif(N, min = 2, max = 20)
height <- 100 + 1.2 * age + rnorm(N, mean = 0, sd = 4)

beta0 <- -28        # kg
beta1 <- 0.5        # kg per cm of height: the value we want to capture
beta2 <- 0.6        # kg per year of age
sigma <- 3          # kg

weight <- beta0 + beta1 * height + beta2 * age + rnorm(N, mean = 0, sd = sigma)

cat("Correlation between height and age:", round(cor(height, age), 2), "\n\n")

# ----------------------------------------------------------------------
# A look at the data: 300 penguins from the colony.
#
# Left: older penguins are taller.
# Right: weight against height, darker = older.  The black line is what a
# model without age finds.  The two coloured lines show the true effect of
# height at a FIXED age (5 and 17 years): both have slope 0.5.  The black
# line is steeper because, moving to the right, we also move to older
# penguins, and they are heavier for their age as well as for their height.
# ----------------------------------------------------------------------
show <- sample(1:N, size = 300)
palette <- hcl.colors(140, "Blues 3", rev = TRUE)[41:140]   # drop the palest blues, so every age stays visible
age_colours <- palette[cut(age[show], breaks = 100)]
young <- 5
old <- 17
young_colour <- palette[round((young - 2) / 18 * 100)]
old_colour <- palette[round((old - 2) / 18 * 100)]

fit_show <- lm(weight[show] ~ height[show])

par(mfrow = c(1, 2))

plot(age[show], height[show], pch = 19, col = age_colours, xlab = "Age (years)", ylab = "Height (cm)", main = "Older penguins are taller")

plot(height[show], weight[show], pch = 19, col = age_colours, xlab = "Height (cm)", ylab = "Weight (kg)", main = "Weight against height, darker = older")
abline(coef(fit_show), lwd = 3)
abline(beta0 + beta2 * young, beta1, col = young_colour, lwd = 3, lty = 2)
abline(beta0 + beta2 * old, beta1, col = old_colour, lwd = 3, lty = 2)
legend("topleft", legend = c(paste("Without age: slope", round(coef(fit_show)[2], 2)), paste0("True, at age ", young, ": slope ", beta1), paste0("True, at age ", old, ": slope ", beta1)), col = c("black", young_colour, old_colour), lwd = 3, lty = c(1, 2, 2), bty = "n", cex = 0.8)

par(mfrow = c(1, 1))

# ----------------------------------------------------------------------
# Many samples.  For each, the 95% CI for the height slope, from both models.
# ----------------------------------------------------------------------
lower_with <- rep(NA, repeats)
upper_with <- rep(NA, repeats)
lower_without <- rep(NA, repeats)
upper_without <- rep(NA, repeats)

for (i in 1:repeats)
{
  chosen <- sample(1:N, size = n)
  fit_with <- lm(weight[chosen] ~ height[chosen] + age[chosen])
  fit_without <- lm(weight[chosen] ~ height[chosen])
  ci_with <- confint(fit_with)[2, ]
  ci_without <- confint(fit_without)[2, ]
  lower_with[i] <- ci_with[1]
  upper_with[i] <- ci_with[2]
  lower_without[i] <- ci_without[1]
  upper_without[i] <- ci_without[2]
}

# Does each interval contain the true slope?
hit_with <- lower_with < beta1 & beta1 < upper_with
hit_without <- lower_without < beta1 & beta1 < upper_without

cat("Intervals that contain the true slope (", beta1, "):\n", sep = "")
cat("  with age:   ", sum(hit_with), "out of", repeats, "\n")
cat("  without age:", sum(hit_without), "out of", repeats, "\n\n")
cat("Average centre of the intervals:\n")
cat("  with age:   ", round(mean((lower_with + upper_with) / 2), 2), "\n")
cat("  without age:", round(mean((lower_without + upper_without) / 2), 2), "\n\n")

# ----------------------------------------------------------------------
# The figure: one horizontal line per sample, its 95% interval.
# Grey: the interval contains the true slope.  Red: it misses.
# The dashed line is the true slope.
# ----------------------------------------------------------------------
xlim <- range(c(lower_with, upper_with, lower_without, upper_without))

par(mfrow = c(1, 2))

plot(NA, xlim = xlim, ylim = c(1, repeats), xlab = "Height slope (kg per cm)", ylab = "Sample", main = paste0("With age: ", sum(hit_with), " of ", repeats, " contain the truth"))
segments(lower_with, 1:repeats, upper_with, 1:repeats, col = ifelse(hit_with, "grey50", "red"), lwd = 2)
abline(v = beta1, lty = 2, lwd = 2)

plot(NA, xlim = xlim, ylim = c(1, repeats), xlab = "Height slope (kg per cm)", ylab = "Sample", main = paste0("Without age: ", sum(hit_without), " of ", repeats, " contain the truth"))
segments(lower_without, 1:repeats, upper_without, 1:repeats, col = ifelse(hit_without, "grey50", "red"), lwd = 2)
abline(v = beta1, lty = 2, lwd = 2)

par(mfrow = c(1, 1))

cat("Try n <- 200: the intervals without age get narrower, and miss even more.\n")
