# What we would like to do, and what we can do.
#
# What we would like: take many samples from the population and fit the
# model to each.  The spread of the estimates tells us how far one estimate
# can land from the truth.  (This is what PopulationSamples.R did.)
#
# What we can do: we only ever have ONE sample.  So we fit the model to it,
# and use that fitted model as a stand-in for the population: simulate many
# new data sets from it, fit the model to each, and look at the spread of
# those estimates.  This is called the (parametric) bootstrap.
#
# The bootstrap estimates are centred on OUR estimate, not on the truth.
# The question is whether their SPREAD is about right.

par(las = 1, bty = "o")    # horizontal axis numbers, full box around the plot

N <- 100000         # penguins in the population
n <- 50             # penguins in one sample
repeats <- 1000     # how many samples / simulated data sets

# This seed gives a typical sample: its slope lands about 0.6 sd above the
# true value, so you can see the shift without the sample being unusual.
# Try other seeds to see how the picture shifts.
set.seed(7)

# ----------------------------------------------------------------------
# The population, the same as in PopulationSamples.R.
# ----------------------------------------------------------------------
height <- rnorm(N, mean = 115, sd = 6)

beta0 <- -28        # kg
beta1 <- 0.5        # kg per cm of height
sigma <- 3          # kg

weight <- beta0 + beta1 * height + rnorm(N, mean = 0, sd = sigma)


# ======================================================================
# WHAT WE WOULD LIKE: many samples from the population
# ======================================================================
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


# ======================================================================
# WHAT WE CAN DO: one sample, then simulate from its fitted model
# ======================================================================

# Our one sample.  This is all a real study ever gets to see.
chosen <- sample(1:N, size = n)
our_height <- height[chosen]
our_weight <- weight[chosen]

our_fit <- lm(our_weight ~ our_height)
b0_hat <- coef(our_fit)[1]
b1_hat <- coef(our_fit)[2]
s_hat <- summary(our_fit)$sigma

cat("Our one sample of", n, "penguins:\n")
cat("  intercept =", round(b0_hat, 2), "  (true:", beta0, ")\n")
cat("  slope     =", round(b1_hat, 3), "  (true:", beta1, ")\n")
cat("  sigma     =", round(s_hat, 2), "  (true:", sigma, ")\n\n")

# The fitted model now plays the role of the population.  Each pass through
# the loop keeps our penguins' heights, gives them new weights from the
# fitted line plus normal noise with sd s_hat, and fits the model again.
b0_star <- rep(NA, repeats)
b1_star <- rep(NA, repeats)
s_star <- rep(NA, repeats)

for (i in 1:repeats)
{
  sim_weight <- b0_hat + b1_hat * our_height + rnorm(n, mean = 0, sd = s_hat)
  fit <- lm(sim_weight ~ our_height)
  b0_star[i] <- coef(fit)[1]
  b1_star[i] <- coef(fit)[2]
  s_star[i] <- summary(fit)$sigma
}

# ----------------------------------------------------------------------
# Compare the spreads.  The centres differ (truth vs our estimate); the
# spreads should be close, but not identical.  The bootstrap is itself
# an estimate from one sample.  It keeps OUR penguins' heights, so if
# they happen to be more spread out than usual, the slope looks better
# pinned down than it is on average (and less so if they are bunched up).
# ----------------------------------------------------------------------
cat("Spread of our penguins' heights:", round(sd(our_height), 2), "cm  (population: 6 cm)\n\n")

cat("Spread (sd) of the estimates:\n")
cat("                 repeated sampling from the population   bootstrap\n")
cat("  intercept     ", format(round(sd(b0), 2), width = 37), format(round(sd(b0_star), 2), width = 11), "\n")
cat("  slope         ", format(round(sd(b1), 4), width = 37), format(round(sd(b1_star), 4), width = 11), "\n")
cat("  sigma         ", format(round(sd(s), 3), width = 37), format(round(sd(s_star), 3), width = 11), "\n\n")

# ----------------------------------------------------------------------
# The figure, for the slope.  Both sets of estimates in one panel.
#
# Grey: the slopes from many samples of the population (what we would like).
# Blue: the slopes from data simulated from our fitted model (what we can do).
#
# Left: as they come.  Grey gathers around the true slope (red line), blue
# around our estimate (blue line).
# Right: each shifted so that its own centre is at zero.  Grey now shows how
# far a sample's slope lands from the truth; blue how far a simulated data
# set's slope lands from our estimate.  The bootstrap works if these two
# spreads are about the same.
# ----------------------------------------------------------------------
grey <- adjustcolor("grey40", alpha.f = 0.4)
blue <- adjustcolor("blue", alpha.f = 0.35)

breaks <- seq(min(c(b1, b1_star)), max(c(b1, b1_star)), length.out = 50)
from_truth <- b1 - beta1          # how far each sample lands from the truth
from_ours <- b1_star - b1_hat     # how far each simulated set lands from our estimate
breaks_centred <- seq(min(c(from_truth, from_ours)), max(c(from_truth, from_ours)), length.out = 50)

par(mfrow = c(1, 2))

hist(b1, breaks = breaks, col = grey, border = "white", ylim = c(0, 120), xlab = "Slope estimate (kg per cm)", main = "As they come")
hist(b1_star, breaks = breaks, col = blue, border = "white", add = TRUE)
segments(beta1, 0, beta1, 90, col = "red", lwd = 3)
segments(b1_hat, 0, b1_hat, 90, col = "blue", lwd = 3)
legend("topleft", legend = c(expression("Repeated sampling from the population: " * hat(beta)[1]), expression("Simulated from our fit: " * hat(beta)[1] * "*"), expression("True slope: " * beta[1]), expression("Our estimate: " * hat(beta)[1])), fill = c(grey, blue, NA, NA), border = NA, col = c(NA, NA, "red", "blue"), lwd = c(NA, NA, 3, 3), bty = "n", cex = 0.8)

hist(from_truth, breaks = breaks_centred, col = grey, border = "white", ylim = c(0, 90), xlab = "Distance from the centre (kg per cm)", main = "Centred: compare the spreads")
hist(from_ours, breaks = breaks_centred, col = blue, border = "white", add = TRUE)
abline(v = 0, lty = 2)
legend("topleft", legend = c(bquote(hat(beta)[1] - beta[1] * ",  sd =" ~ .(round(sd(b1), 3))), bquote(hat(beta)[1] * "*" - hat(beta)[1] * ",  sd =" ~ .(round(sd(b1_star), 3)))), fill = c(grey, blue), border = NA, bty = "n", cex = 0.8)

par(mfrow = c(1, 1))

cat("Try another seed: the blue histogram moves with our estimate,\n")
cat("but its spread stays close to the spread of the grey one.\n")
