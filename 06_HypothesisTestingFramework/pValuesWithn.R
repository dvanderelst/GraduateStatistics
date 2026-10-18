# A difference nobody cares about becomes "significant" if the sample is big.
#
# Penguins on two islands differ in mean height by 1 mm (0.1 cm).  Heights vary
# with a standard deviation of 3 cm, so 1 mm is far too small to matter.  But
# it is not zero, and the null hypothesis says it is exactly zero.
#
# For a range of sample sizes we measure n penguins on each island and test
# whether the two means differ (a t-test).  Each sample size gets one study.
# Left panel:  the p value of each study.
# Right panel: the t value of each study, the statistic behind the p value.

difference <- 0.1      # true difference in mean height (cm): 1 mm
sd <- 3                # spread of heights within each island (cm)

n_values <- seq(from = 10, to = 40000, by = 400)   # penguins per island

# ---------------------------------------------------------------- the studies

p_values <- n_values * 0
t_values <- n_values * 0

counter <- 1
for (n in n_values) {
  island_a <- rnorm(n, mean = 0, sd = sd)
  island_b <- rnorm(n, mean = difference, sd = sd)
  result <- t.test(island_b, island_a, var.equal = TRUE)
  p_values[counter] <- result$p.value
  t_values[counter] <- result$statistic
  counter <- counter + 1
}

# ---------------------------------------------------------------- the trend

# Without the noise of sampling, t would be the true difference divided by its
# standard error.  The standard error shrinks with the square root of n, so t
# grows with it, even though the difference itself never changes.
n_fine <- seq(min(n_values), max(n_values), length.out = 500)
t_expected <- difference / (sd * sqrt(2 / n_fine))
p_expected <- 2 * pt(-t_expected, df = 2 * n_fine - 2)

# ---------------------------------------------------------------- the plot

par(mfrow = c(1, 2), oma = c(0, 0, 3, 0), mar = c(5, 5, 4, 1),
    cex.axis = 1.2, cex.lab = 1.3, cex.main = 1.4)

significant <- p_values < 0.05
colours <- ifelse(significant, "red", "grey50")

# Left: the p values, and the line studies are judged against.
plot(n_values, p_values, pch = 19, col = colours, ylim = c(0, 1),
     xlab = "penguins per island (n)", ylab = "p value",
     main = "p value of each study")
lines(n_fine, p_expected, lwd = 2)
abline(h = 0.05, lty = 2, col = "red")
legend("topright", legend = c("p < 0.05", "p >= 0.05", "without sampling noise"),
       col = c("red", "grey50", "black"), pch = c(19, 19, NA),
       lty = c(NA, NA, 1), lwd = c(NA, NA, 2), bty = "n")

# Right: the t values.  The dashed line is the t that gives p = 0.05.
plot(n_values, t_values, pch = 19, col = colours,
     xlab = "penguins per island (n)", ylab = "t value",
     main = "t value of each study")
lines(n_fine, t_expected, lwd = 2)
abline(h = qt(0.975, df = 2 * max(n_values) - 2), lty = 2, col = "red")
abline(h = 0, lty = 3)

mtext(paste0("true difference = ", difference, " cm,  sd = ", sd,
             " cm      one study per sample size"),
      outer = TRUE, line = 0.8, cex = 1.2)

# ---------------------------------------------------------------- the point

# The difference is the same 1 mm in every study.  Only n changes.  Small
# studies rarely reject the null; large studies almost always do.  So whether
# we reject tells us as much about our sample size as about the penguins.
#
# Also look at the middle of the plot: studies of the same size, sampling the
# same islands, land on both sides of p = 0.05.  Which side a single study
# ends up on is largely luck.
small <- n_values <= 1000
large <- n_values >= 30000
cat("share of studies with p < 0.05\n")
cat("  n <= 1,000  :", round(mean(significant[small]), 2), "\n")
cat("  n >= 30,000 :", round(mean(significant[large]), 2), "\n")
