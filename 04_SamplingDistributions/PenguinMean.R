# A population of 31 penguins.  We weigh 5 of them and take the mean.
#
# That mean is a statistic: one number, calculated from one sample.  Run the
# script twice and it comes out different, because a different 5 penguins got
# caught.  The question of this section is how that number moves around, so we
# do the whole thing thousands of times and look at the answers we get.
#
# The result is NOT the distribution of penguin weights.  It is the
# distribution of the MEAN of 5 penguin weights -- the sampling distribution.


# The whole population.  In real life we never have this; here we do, so we
# can check the answer against the truth.
population <- c(12, 34, 69, 36, 13, 47, 98, 12, 18, 87, 65,
                42, 98, 76, 34, 18, 10, 89, 90, 78, 65, 53,
                27, 57, 69, 23, 44, 12, 67, 11, 15)

n <- 5              # how many penguins we catch in one sample
repeats <- 10000    # how many times we repeat the whole exercise

# 0 = catch 5 different penguins.  This is what you would actually dNexo, and
#     there really are only 31 birds out there.
# 1 = throw each penguin back before catching the next one, so the same bird
#     can turn up twice.  This pretends the colony is endless.  We come back
#     to it when we work the sampling distribution out on paper instead of
#     by simulation.
with_replacement <- 0

N <- length(population)

# ----------------------------------------------------------------------
# The population parameters.  These are fixed facts about the 31 penguins --
# they do not depend on which ones we happen to catch.
#
# Note the divisor: this is the spread of the population itself, so we divide
# by N.  (R's sd() divides by N-1, because it is built to ESTIMATE the
# population spread from a sample, which is a different job.)
# ----------------------------------------------------------------------
pop_mean <- mean(population)
pop_sd <- sqrt(mean((population - pop_mean)^2))

cat("The population:", N, "penguins\n")
cat("  mean =", round(pop_mean, 2), "kg   sd =", round(pop_sd, 2), "kg\n\n")

# ----------------------------------------------------------------------
# One sample.  This is all a real study ever gets to see.
# ----------------------------------------------------------------------
one_sample <- sample(population, size = n, replace = with_replacement == 1)

cat("One sample of", n, "penguins:", paste(one_sample, collapse = ", "), "\n")
cat("  mean =", round(mean(one_sample), 2), "kg\n")
cat("  If we went out and caught 5 more, would we get this number again?\n\n")

# ----------------------------------------------------------------------
# So do it again.  And again.  Each pass through the loop is one imaginary
# research group going out, catching 5 penguins, and reporting a mean.
# ----------------------------------------------------------------------
show <- 14          # how many of the repeats to print

means <- rep(NA, repeats)
kept <- list()      # the first few samples, kept so we can look at them
for (i in 1:repeats)
{
  a_sample <- sample(population, size = n, replace = with_replacement == 1)
  means[i] <- mean(a_sample)
  if (i <= show) {kept[[i]] <- a_sample}
}

# The first few, laid out the way the slides do it.
cat("The first", show, "of", repeats, "repeats:\n")
for (i in 1:show)
{
  cat(sprintf("  %-22s --> %5.1f\n",
              paste(kept[[i]], collapse = ", "), means[i]))
}
cat("  And many, many more...\n\n")

# ----------------------------------------------------------------------
# What came out.
#
# The means cluster on the population mean and they are far less spread out
# than the penguins are.  That second part is the whole point: averaging 5
# penguins cancels the light ones against the heavy ones.
#
# The spread of a sampling distribution has its own name -- the standard
# error -- and for the mean we can predict it without simulating anything.
# ----------------------------------------------------------------------
if (with_replacement)
{
  # The colony is being treated as endless, so every catch is independent of
  # the ones before it and the spread of the means is just sd / sqrt(n).
  expected_se <- pop_sd / sqrt(n)
  se_formula <- "sd / sqrt(n)"
} else {
  # We are catching 5 DIFFERENT penguins out of only 31.  Landing the 98 kg
  # bird takes it out of the pool, so the four catches that follow come from
  # a colony that is now lighter: the sample partly corrects itself, extreme
  # samples get rarer, and the means come out tighter than sd / sqrt(n).
  #
  # The (N-n)/(N-1) term is what accounts for that.  Sample every bird
  # (n = N) and it goes to zero -- weigh all 31 and the mean IS the
  # population mean, with nothing left to vary.  Make the colony large next
  # to the sample and it goes to one, which is the case above.
  expected_se <- (pop_sd / sqrt(n)) * sqrt((N - n) / (N - 1))
  se_formula <- "sd / sqrt(n) * sqrt((N-n)/(N-1))"
}

cat("The SIMULATED sampling distribution of the mean, from", repeats, "repeats:\n")
cat("  mean of the means =", round(mean(means), 2),
    "kg   (population mean =", round(pop_mean, 2), "kg)\n")
cat("  sd of the means   =", round(sd(means), 2), "kg\n")
cat("  predicted by", se_formula, "=", round(expected_se, 2), "kg\n\n")
cat("  The penguins are spread over", round(pop_sd, 1),
    "kg; the means over only", round(sd(means), 1), "kg.\n")

# ----------------------------------------------------------------------
# Both distributions, side by side and on the same axis, because the
# comparison is the lesson.  Left: how heavy penguins are.  Right: how heavy
# the mean of 5 penguins is.  Same population, different question.
# ----------------------------------------------------------------------
par(mfrow = c(1, 2), mar = c(4, 4, 5, 1))

limits <- range(population)

hist(population, breaks = seq(0, 100, by = 5), xlim = limits, freq = FALSE,
     col = "grey85", border = "white",
     xlab = "Weight (kg)",
     main = paste0("The Population\nAll ", N, " Penguins\n",
                   "Mean = ", round(pop_mean, 1), ", SD = ", round(pop_sd, 1)))
abline(v = pop_mean, col = "red", lwd = 2, lty = 2)

hist(means, breaks = 30, xlim = limits, freq = FALSE,
     col = "grey85", border = "white",
     xlab = "Mean Weight of a Sample (kg)",
     main = paste0("Simulated Sampling Distribution\nof the Mean, n = ", n,
                   "\nMean = ", round(mean(means), 1),
                   ", SD = ", round(sd(means), 1)))
abline(v = pop_mean, col = "red", lwd = 2, lty = 2)

cat("\nTry n <- 10, or n <- 20, and watch the right-hand plot tighten.\n")
cat("Try n <- 31 -- catch every penguin, and there is nothing left to vary.\n")
