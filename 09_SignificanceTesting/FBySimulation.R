# How large is F when the predictors are useless?
#
# For the body data, weight ~ height + age gives F = 295.6.  Is that large?
# To answer, we need to know what F looks like in a world where height and
# age have NOTHING to do with weight: all slopes are 0.
#
# We cannot visit that world, but we can simulate it.  It is the
# intercept-only model, run forward:
#
#   weight_i = beta0 + epsilon_i,    epsilon_i ~ N(0, sigma^2)
#
# with beta0 and sigma taken from the intercept-only fit to the real data.
# Height and age stay exactly as measured; only the weights are made up,
# and they ignore height and age by construction.
#
# For each simulated data set we fit both models, compute F, and repeat.
# The histogram of those F values is the sampling distribution of F in the
# hypothesized world.  The F distribution is its closed-form shortcut.

par(las = 1, bty = "o")    # horizontal axis numbers, full box around the plot

body <- read.csv("data/body.csv")

repeats <- 10000    # how many simulated data sets

# ----------------------------------------------------------------------
# The real data: the observed F.
# ----------------------------------------------------------------------
fit0 <- lm(Weight ~ 1, data = body)               # intercept only
fit1 <- lm(Weight ~ Height + Age, data = body)    # full model

SSE0 <- sum(residuals(fit0)^2)
SSE1 <- sum(residuals(fit1)^2)
n <- nrow(body)
p <- length(coef(fit1))

F_obs <- ((SSE0 - SSE1) / (p - 1)) / (SSE1 / (n - p))
cat("Observed F:", round(F_obs, 1), "\n\n")

# ----------------------------------------------------------------------
# The hypothesized world: all slopes are 0.
# Its parameters come from the intercept-only fit: beta0 is the mean
# weight, sigma is the spread of the weights around it.
# ----------------------------------------------------------------------
beta0 <- coef(fit0)[1]
sigma <- summary(fit0)$sigma

cat("Hypothesized world: weight =", round(beta0, 1), "+ noise with sigma =", round(sigma, 1), "\n\n")

# ----------------------------------------------------------------------
# One simulated data set.  Height and age are the real ones; the weights
# are generated without them.  Even so, adding height and age lowers the
# SSE a little: they soak up some of the noise by chance.
# ----------------------------------------------------------------------
fake_weight <- beta0 + rnorm(n, mean = 0, sd = sigma)

fake0 <- lm(fake_weight ~ 1)
fake1 <- lm(fake_weight ~ body$Height + body$Age)
fake_SSE0 <- sum(residuals(fake0)^2)
fake_SSE1 <- sum(residuals(fake1)^2)

cat("One simulated data set:\n")
cat("  SSE0 =", round(fake_SSE0), "\n")
cat("  SSE1 =", round(fake_SSE1), "  (smaller, although height and age are useless)\n")
cat("  F    =", round(((fake_SSE0 - fake_SSE1) / (p - 1)) / (fake_SSE1 / (n - p)), 2), "\n\n")

# ----------------------------------------------------------------------
# So do it again.  Each pass through the loop is one data set from the
# world where height and age do not matter.
# ----------------------------------------------------------------------
F_sim <- rep(NA, repeats)

for (i in 1:repeats)
{
  fake_weight <- beta0 + rnorm(n, mean = 0, sd = sigma)
  fake0 <- lm(fake_weight ~ 1)
  fake1 <- lm(fake_weight ~ body$Height + body$Age)
  fake_SSE0 <- sum(residuals(fake0)^2)
  fake_SSE1 <- sum(residuals(fake1)^2)
  F_sim[i] <- ((fake_SSE0 - fake_SSE1) / (p - 1)) / (fake_SSE1 / (n - p))
}

cat("Over", repeats, "simulated data sets:\n")
cat("  average F:", round(mean(F_sim), 2), "  (close to 1)\n")
cat("  F below 1:", round(100 * mean(F_sim < 1)), "%\n")
cat("  largest F:", round(max(F_sim), 1), "\n")
cat("  F at least as large as the observed", round(F_obs, 1), ":", sum(F_sim >= F_obs), "times\n\n")

# ----------------------------------------------------------------------
# The histogram, with the F distribution (df = p - 1 and n - p) on top.
# The shortcut matches the simulation, so R does not need to simulate:
# it looks up the area under this curve.
#
# The observed F is far off the right edge of this plot.
# ----------------------------------------------------------------------
hist(F_sim, breaks = 60, freq = FALSE, col = "grey85", border = "white", xlab = "F in each simulated data set", main = "F when all slopes are 0")
curve(df(x, df1 = p - 1, df2 = n - p), from = 0, to = max(F_sim), add = TRUE, col = "orange", lwd = 3)
legend("topright", legend = c("Simulation", paste0("F distribution (", p - 1, ", ", n - p, ")")), col = c("grey70", "orange"), lwd = c(10, 3), bty = "n")

# ----------------------------------------------------------------------
# The p-value, two ways.
# ----------------------------------------------------------------------
cat("p-value, simulation: ", mean(F_sim >= F_obs), "  (no simulated F came close)\n")
cat("p-value, F shortcut: ", signif(pf(F_obs, df1 = p - 1, df2 = n - p, lower.tail = FALSE), 3), "\n\n")

# ----------------------------------------------------------------------
# A world with nothing to find still produces "significant" results.
# The 5% cutoff: the F that only 5% of null data sets exceed.
# ----------------------------------------------------------------------
F_cut <- qf(0.95, df1 = p - 1, df2 = n - p)

hist(F_sim, breaks = 60, freq = FALSE, col = "grey85", border = "white", xlab = "F in each simulated data set", main = "Significant by chance: F above the 5% cutoff")
curve(df(x, df1 = p - 1, df2 = n - p), from = 0, to = max(F_sim), add = TRUE, col = "orange", lwd = 3)
abline(v = F_cut, col = "red", lwd = 3, lty = 2)
text(F_cut, par("usr")[4] * 0.9, paste("5% cutoff:", round(F_cut, 2)), col = "red", pos = 4)

cat("5% cutoff for F:", round(F_cut, 2), "\n")
cat("Simulated data sets above it:", sum(F_sim > F_cut), "of", repeats, "(", round(100 * mean(F_sim > F_cut), 1), "%)\n")
cat("Each of these would be reported as 'height and age predict weight, p < .05'.\n\n")

cat("Try sigma <- 1 or sigma <- 50: the histogram does not move.  F is a ratio of two\n")
cat("things measured in the same units, so the scale of the noise cancels out.\n")
