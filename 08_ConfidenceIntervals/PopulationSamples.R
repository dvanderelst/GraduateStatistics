# A population of 100,000 emperor penguins whose weight follows a linear
# model with KNOWN parameters.  We catch 50 of them, fit the model, and get
# estimates of those parameters.  Then we do it again, and again.
#
# Every sample gives different estimates.  The question of this section is
# how much they move around: that spread is what a confidence interval is
# built from.
#
# Part 1: one predictor (height).  Each sample gives a line, so we can SEE
#         beta0 and beta1 vary by drawing the lines.
# Part 2: two predictors (height and age).  There is no single line to draw,
#         so we look at histograms of every estimate, sigma included.

par(las = 1, bty = "l")    # horizontal axis numbers, no box around the plot

N <- 100000         # penguins in the population
n <- 50             # penguins in one sample
repeats <- 1000     # how many samples we take

# ----------------------------------------------------------------------
# The predictors.  Emperor penguins stand about 115 cm tall; we give the
# colony ages spread evenly between 2 and 20 years.
# ----------------------------------------------------------------------
height <- rnorm(N, mean = 115, sd = 6)
age <- runif(N, min = 2, max = 20)


# ======================================================================
# PART 1: ONE PREDICTOR
# ======================================================================

# The true parameters.  In real life we never know these; here we chose
# them, so we can check every estimate against the truth.
beta0 <- -28        # kg
beta1 <- 0.5        # kg per cm of height
sigma <- 3          # kg

weight <- beta0 + beta1 * height + rnorm(N, mean = 0, sd = sigma)

# Fitting the model to the WHOLE population gives (almost exactly) the true
# values: these are "the values we would find if we sampled every penguin".
population_fit <- lm(weight ~ height)
cat("Fitted to all", format(N, big.mark = ",", scientific = FALSE), "penguins:\n")
print(round(coef(population_fit), 3))
cat("  sigma =", round(summary(population_fit)$sigma, 3), "\n\n")

# ----------------------------------------------------------------------
# One sample.  This is all a real study ever gets to see.
# ----------------------------------------------------------------------
chosen <- sample(1:N, size = n)
one_fit <- lm(weight[chosen] ~ height[chosen])
cat("Fitted to one sample of", n, "penguins:\n")
print(round(coef(one_fit), 3))
cat("  sigma =", round(summary(one_fit)$sigma, 3), "\n")
cat("  Would another 50 penguins give the same numbers?\n\n")

# ----------------------------------------------------------------------
# So do it again.  Each pass through the loop is one imaginary research
# group catching 50 penguins and fitting the model.
# ----------------------------------------------------------------------
b0 <- rep(NA, repeats)
b1 <- rep(NA, repeats)
s <- rep(NA, repeats)

for (i in 1:repeats)
{
  chosen <- sample(1:N, size = n)
  fit <- lm(weight[chosen] ~ height[chosen])
  b0[i] <- coef(fit)[1]
  b1[i] <- coef(fit)[2]
  s[i] <- summary(fit)$sigma
}

cat("Over", repeats, "samples of", n, "penguins:\n")
cat("  beta0: true =", beta0, "  estimates from", round(min(b0), 1), "to", round(max(b0), 1), "\n")
cat("  beta1: true =", beta1, "  estimates from", round(min(b1), 2), "to", round(max(b1), 2), "\n")
cat("  sigma: true =", sigma, "  estimates from", round(min(s), 1), "to", round(max(s), 1), "\n\n")

# ----------------------------------------------------------------------
# The lines.  Red: the population line.  Grey: the first 20 samples.
#
# Left: the range of heights we measure.  The lines are close to the red
# one, and cross it near the middle of the heights.
# Right: the same lines, followed back to height 0.  Because the lines
# pivot around the middle of the data, a small change in slope swings the
# intercept a lot.  That is why the intercept varies so much more than the
# slope.
# ----------------------------------------------------------------------
show <- 20

par(mfrow = c(1, 2))

plot(height[chosen], weight[chosen], type = "n", xlim = c(100, 130), ylim = c(15, 45), xlab = "Height (cm)", ylab = "Weight (kg)", main = paste(show, "samples of", n, "penguins"))
for (i in 1:show)
{
  abline(b0[i], b1[i], col = "grey60")
}
abline(beta0, beta1, col = "red", lwd = 3)
legend("topleft", legend = c("Population", "One sample"), col = c("red", "grey60"), lwd = c(3, 1), bty = "n")

plot(height[chosen], weight[chosen], type = "n", xlim = c(0, 130), ylim = c(-60, 45), xlab = "Height (cm)", ylab = "Weight (kg)", main = "The same lines, back to height 0")
rect(100, -1000, 130, 1000, col = adjustcolor("grey", 0.3), border = NA)
for (i in 1:show)
{
  abline(b0[i], b1[i], col = "grey60")
}
abline(beta0, beta1, col = "red", lwd = 3)
abline(v = 0, lty = 3)

par(mfrow = c(1, 1))

# ----------------------------------------------------------------------
# The same estimates, all 1000 samples this time, as histograms.  The red
# line is the true value.
#
# These are sampling distributions, just like the sampling distribution of
# the mean: what a statistic does when you repeat the study.
# ----------------------------------------------------------------------
par(mfrow = c(1, 3))

hist(b0, breaks = 40, col = "grey85", border = "white", xlab = expression(hat(beta)[0] * " in each sample"), main = paste("Intercept, sd =", round(sd(b0), 1)))
abline(v = beta0, col = "red", lwd = 3)
text(beta0, par("usr")[4], expression(beta[0] * " (true)"), col = "red", pos = 3, xpd = TRUE)

hist(b1, breaks = 40, col = "grey85", border = "white", xlab = expression(hat(beta)[1] * " in each sample"), main = paste("Height, sd =", round(sd(b1), 3)))
abline(v = beta1, col = "red", lwd = 3)
text(beta1, par("usr")[4], expression(beta[1] * " (true)"), col = "red", pos = 3, xpd = TRUE)

hist(s, breaks = 40, col = "grey85", border = "white", xlab = expression(hat(sigma) * " in each sample"), main = paste("Sigma, sd =", round(sd(s), 2)))
abline(v = sigma, col = "red", lwd = 3)
text(sigma, par("usr")[4], expression(sigma * " (true)"), col = "red", pos = 3, xpd = TRUE)

par(mfrow = c(1, 1))


# ======================================================================
# PART 2: TWO PREDICTORS
# ======================================================================

# Same penguins, but now age also adds to weight.
beta0 <- -28        # kg
beta1 <- 0.5        # kg per cm of height
beta2 <- 0.15       # kg per year of age
sigma <- 3          # kg

weight <- beta0 + beta1 * height + beta2 * age + rnorm(N, mean = 0, sd = sigma)

b0 <- rep(NA, repeats)
b1 <- rep(NA, repeats)
b2 <- rep(NA, repeats)
s <- rep(NA, repeats)

for (i in 1:repeats)
{
  chosen <- sample(1:N, size = n)
  fit <- lm(weight[chosen] ~ height[chosen] + age[chosen])
  b0[i] <- coef(fit)[1]
  b1[i] <- coef(fit)[2]
  b2[i] <- coef(fit)[3]
  s[i] <- summary(fit)$sigma
}

# ----------------------------------------------------------------------
# One histogram per estimate.  The red line is the true value.
#
# These are sampling distributions, just like the sampling distribution of
# the mean: what a statistic does when you repeat the study.  Their
# standard deviations are the "Std. Error" column in summary().
#
# Look at sigma: it is a little lopsided, and it tends to come out slightly
# low.  The coefficients do not.
# ----------------------------------------------------------------------
par(mfrow = c(2, 2))

hist(b0, breaks = 40, col = "grey85", border = "white", xlab = expression(hat(beta)[0] * " in each sample"), main = paste("Intercept, sd =", round(sd(b0), 1)))
abline(v = beta0, col = "red", lwd = 3)
text(beta0, par("usr")[4], expression(beta[0] * " (true)"), col = "red", pos = 3, xpd = TRUE)

hist(b1, breaks = 40, col = "grey85", border = "white", xlab = expression(hat(beta)[1] * " in each sample"), main = paste("Height, sd =", round(sd(b1), 3)))
abline(v = beta1, col = "red", lwd = 3)
text(beta1, par("usr")[4], expression(beta[1] * " (true)"), col = "red", pos = 3, xpd = TRUE)

hist(b2, breaks = 40, col = "grey85", border = "white", xlab = expression(hat(beta)[2] * " in each sample"), main = paste("Age, sd =", round(sd(b2), 3)))
abline(v = beta2, col = "red", lwd = 3)
text(beta2, par("usr")[4], expression(beta[2] * " (true)"), col = "red", pos = 3, xpd = TRUE)

hist(s, breaks = 40, col = "grey85", border = "white", xlab = expression(hat(sigma) * " in each sample"), main = paste("Sigma, sd =", round(sd(s), 2)))
abline(v = sigma, col = "red", lwd = 3)
text(sigma, par("usr")[4], expression(sigma * " (true)"), col = "red", pos = 3, xpd = TRUE)

par(mfrow = c(1, 1))

cat("Try n <- 200 and watch every histogram tighten.\n")
cat("Try n <- 10 and watch them spread out.\n")
