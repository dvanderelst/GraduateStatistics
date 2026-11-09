# Does the equation on the slides work?
#
#   sd of an estimate = sigma x sqrt( [ (X'X)^-1 ]_jj )
#
# We take ONE sample of 50 penguins from the population, fit the model, and
# compute the two parts of the equation ourselves:
#
#   1. sigma: the spread of the noise.
#   2. sqrt([(X'X)^-1]_jj): a number for each coefficient that depends only
#      on the predictor values (here: the heights and ages we measured).
#
# Multiplying the two gives the spread of each estimate.  With the true sigma,
# that is the width of the sampling distribution.  With sigma-hat, it is the
# "Std. Error" column that R prints.

N <- 100000         # penguins in the population
n <- 50             # penguins in one sample

# This seed gives a typical sample.  Try others: the numbers change, but the
# equation and R always agree.
set.seed(3)

# ----------------------------------------------------------------------
# The population, the same as in PopulationSamples.R (part 2).
# ----------------------------------------------------------------------
height <- rnorm(N, mean = 115, sd = 6)
age <- runif(N, min = 2, max = 20)

beta0 <- -28        # kg
beta1 <- 0.5        # kg per cm of height
beta2 <- 0.15       # kg per year of age
sigma <- 3          # kg

weight <- beta0 + beta1 * height + beta2 * age + rnorm(N, mean = 0, sd = sigma)

# ----------------------------------------------------------------------
# One sample, one fit.  This is all a real study ever gets to see.
# ----------------------------------------------------------------------
chosen <- sample(1:N, size = n)
penguins <- data.frame(weight = weight[chosen], height = height[chosen], age = age[chosen])

fit <- lm(weight ~ height + age, data = penguins)
print(summary(fit))

# ----------------------------------------------------------------------
# Part 1 of the equation: sigma.
# We know the true value (3) because we built the population.  From the
# sample we only get the estimate, the "Residual standard error".
# ----------------------------------------------------------------------
sigma_hat <- summary(fit)$sigma
cat("\nsigma: true =", sigma, "  estimated from the sample =", round(sigma_hat, 3), "\n\n")

# ----------------------------------------------------------------------
# Part 2 of the equation: sqrt([(X'X)^-1]_jj).
#
# X is the matrix of predictors: one row per penguin, a column of 1s for the
# intercept, then a column for each predictor.
# ----------------------------------------------------------------------
X <- model.matrix(fit)
print(head(X))

XtX_inverse <- solve(t(X) %*% X)     # (X'X)^-1
second_term <- sqrt(diag(XtX_inverse))   # one number per coefficient

cat("\nThe second term, one number per coefficient:\n")
print(round(second_term, 5))

# ----------------------------------------------------------------------
# Put the two together.
# ----------------------------------------------------------------------
with_true_sigma <- sigma * second_term
with_sigma_hat <- sigma_hat * second_term
r_std_error <- summary(fit)$coefficients[, "Std. Error"]

results <- data.frame(estimate = coef(fit), true_sigma_x_term = with_true_sigma, sigma_hat_x_term = with_sigma_hat, R_std_error = r_std_error)
cat("\n")
print(round(results, 4))

cat("\nsigma_hat x term is exactly R's Std. Error: that is how R computes it.\n")
cat("sigma x term is the true spread of the estimates for these heights and ages.\n")

# ======================================================================
# Check against repeated sampling from the population
# ======================================================================
# The equation says how much the estimates SHOULD vary from sample to sample.
# Here we let them vary: take many samples of 50, fit the model to each, and
# measure the spread of the estimates directly.
repeats <- 1000

b0 <- rep(NA, repeats)
b1 <- rep(NA, repeats)
b2 <- rep(NA, repeats)

for (i in 1:repeats)
{
  chosen <- sample(1:N, size = n)
  one <- lm(weight[chosen] ~ height[chosen] + age[chosen])
  b0[i] <- coef(one)[1]
  b1[i] <- coef(one)[2]
  b2[i] <- coef(one)[3]
}

sd_repeated <- c(sd(b0), sd(b1), sd(b2))

comparison <- data.frame(equation_true_sigma = with_true_sigma, repeated_sampling = sd_repeated, equation_sigma_hat = with_sigma_hat)
cat("\nSpread of the estimates, three ways:\n")
print(round(comparison, 4))

cat("\nSpread of our sample's heights:", round(sd(penguins$height), 2), "cm  (population: 6 cm)\n")
cat("Spread of our sample's ages:   ", round(sd(penguins$age), 2), "years  (population:", round(18 / sqrt(12), 2), "years)\n")

# The first two columns agree closely: the equation, with the true sigma,
# predicts what repeated sampling shows.  They do not agree exactly, for two
# reasons.  1000 samples is not infinitely many.  And the equation used OUR
# sample's heights and ages, while every repeated sample has its own.  If our
# penguins happen to be bunched together in height (see below), the equation
# predicts a little more spread than the average sample shows.
#
# The third column is what we can compute from one sample.  It differs from
# the first only because sigma-hat is not sigma.  That gap is what the
# t distribution takes care of.
