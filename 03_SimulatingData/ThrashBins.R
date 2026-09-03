# Two kinds of citizen, each with their own trash habit.  Set number2 to 0 to
# get the single-habit version back.

# --- citizen type 1: households ---
weights1 <- c(0, 1, 5, 10)
probs1 <- c(10, 1, 2, 3)
probs1 <- probs1 / sum(probs1)
number1 <- 70

# --- citizen type 2: restaurants (rarer, but much heavier) ---
weights2 <- c(0, 15, 30)
probs2 <- c(2, 3, 5)
probs2 <- probs2 / sum(probs2)
number2 <- 10

bins <- 1000

all_weights <- list(weights1, weights2)
all_probs <- list(probs1, probs2)
all_numbers <- c(number1, number2)

# ----------------------------------------------------------------------
# Simulate: every citizen drops something in every bin
# ----------------------------------------------------------------------
bin_weights <- rep(0, bins)
for (g in 1:length(all_numbers))
{
  for (i in seq_len(all_numbers[g]))
  {
    dumps <- sample(all_weights[[g]], size=bins, prob=all_probs[[g]], replace=TRUE)
    bin_weights <- bin_weights + dumps
  }
}

# ----------------------------------------------------------------------
# Predict the answer from the contributions alone -- without looking at the
# bins.  Means add; VARIANCES add (not standard deviations).
# ----------------------------------------------------------------------
group_mean <- rep(NA, length(all_numbers))
group_var <- rep(NA, length(all_numbers))
for (g in 1:length(all_numbers))
{
  w <- all_weights[[g]]
  p <- all_probs[[g]]
  group_mean[g] <- sum(w * p)
  group_var[g] <- sum(w^2 * p) - group_mean[g]^2
}

total_mean <- sum(all_numbers * group_mean)
total_var <- sum(all_numbers * group_var)
total_sd <- sqrt(total_var)

cat("ONE citizen of each type contributes:\n")
cat(sprintf("%-14s %8s %8s %8s %10s %8s\n",
            "type", "how many", "mean", "sd", "variance", "% of var"))
for (g in 1:length(all_numbers))
{
  cat(sprintf("%-14s %8d %8.3f %8.3f %10.3f %7.0f%%\n",
      paste0("type ", g), all_numbers[g], group_mean[g], sqrt(group_var[g]),
      group_var[g], 100 * all_numbers[g] * group_var[g] / total_var))
}

cat("\nAdd them up.  Variances add, standard deviations do not:\n")
cat("  total variance =", paste(all_numbers, "x", round(group_var, 3), collapse=" + "),
    "=", round(total_var, 1), "\n")
cat("  total sd       = sqrt(", round(total_var, 1), ") =", round(total_sd, 2), "kg\n")
cat("  total mean     =", round(total_mean, 1), "kg\n")

cat("\nObserved in the", bins, "bins:\n")
cat("  mean =", round(mean(bin_weights), 1), "  sd =", round(sd(bin_weights), 2), "\n")

# ----------------------------------------------------------------------
# Plot: what goes in, and what comes out
# ----------------------------------------------------------------------
par(mfrow = c(1, length(all_numbers) + 1))

for (g in 1:length(all_numbers))
{
  w <- all_weights[[g]]
  p <- all_probs[[g]]
  plot(w, p, type = "h", lwd = 8, col = "grey40",
       xlab = "kg dropped", ylab = "probability", ylim = c(0, max(p) * 1.15),
       main = paste0("Type ", g, ": ", all_numbers[g], " citizens\n",
                     "mean = ", round(group_mean[g], 2),
                     ", sd = ", round(sqrt(group_var[g]), 2)))
  points(w, p, pch = 19)
  abline(v = group_mean[g], col = "red", lwd = 2, lty = 2)
}

# The bin totals are still whole kilograms -- but the steps are tiny next to a
# spread of tens of kg, which is why a continuous curve fits them.
hist(bin_weights, breaks = 30, freq = FALSE, col = "grey85", border = "white",
     xlab = "total kg in a bin",
     main = paste0("The sum\nmean = ", round(total_mean, 1),
                   ", sd = ", round(total_sd, 1)))
curve(dnorm(x, total_mean, total_sd), add = TRUE, col = "red", lwd = 3)
abline(v = total_mean, col = "red", lwd = 2, lty = 2)
legend("topright", legend = c("simulated bins", "Normal from\nthe addition rule"),
       col = c("grey60", "red"), lwd = c(8, 3), bty = "n", cex = 0.8)
