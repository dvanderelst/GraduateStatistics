p_head <- 0.65
throws <- 10
repeats <- 100000

normalize_and_compare <- 1
plot_binomial <- 1

results <- rep(NA, repeats)
for (i in 1: repeats)
{

run <- sample.int(2, size=throws, prob=c(1-p_head, p_head), replace=TRUE)
run <- run - 1
number_of_heads <- sum(run)
results[i] <- number_of_heads

}

# Every outcome the experiment could produce, from no heads up to all heads.
# Fixing the axis to this range (rather than to what we happened to observe)
# keeps the plot the same from run to run, and leaves the rare outcomes
# visible as empty space instead of quietly dropping them.
possible <- 0:throws
breaks <- seq(-0.5, throws + 0.5, by = 1)

title <- paste("p(head) =", p_head, "  throws =", throws, "  repeats =", repeats)

# Work out the simulated and the theoretical heights before plotting, so the
# y axis can be made tall enough for both.
h <- hist(results, breaks = breaks, plot = FALSE)

if (normalize_and_compare)
{
  # The bars are one unit wide, so each bar's height is the proportion of
  # runs that gave that many heads -- directly comparable to a probability.
  simulated <- h$density
  expected <- dbinom(possible, throws, p_head)
} else {
  # The binomial put back on the scale of the raw counts.
  simulated <- h$counts
  expected <- dbinom(possible, throws, p_head) * repeats
}

hist(results, breaks = breaks, freq = !normalize_and_compare, main = title,
     xlab = "number of heads", ylim = c(0, max(simulated, expected)))

if (plot_binomial)
{
  points(possible, expected, col = "red", pch = 19)
  legend("topleft", legend = c("simulation", "binomial"),
         col = c("black", "red"), pch = c(15, 19), bty = "n")
}
