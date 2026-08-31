# Gaussian NOISE, as opposed to a gaussian quantity.
#
# In EmpiricalNormal.R the thing being measured really varied: people differ in
# height.  Here the thing being measured does not vary at all.  Whatever spread
# we see can only be error -- which is what the linear model means by its
# noise term.

show <- 1     # 1 = measuring one fixed quantity, over and over
              # 2 = the leftovers after fitting a line

body <- read.csv("data/body.csv")

# ----------------------------------------------------------------------
normal_hist <- function(values, title, xlabel, nbreaks = 20)
{
  m <- mean(values)
  s <- sd(values)
  hist(values, breaks = nbreaks, freq = FALSE, col = "grey85", border = "white",
       main = title, xlab = xlabel)
  grid <- seq(min(values), max(values), length.out = 300)
  lines(grid, dnorm(grid, m, s), col = "red", lwd = 2)
}

skew <- function(values) {mean(((values - mean(values)) / sd(values))^3)}

describe <- function(label, values)
{
  cat(sprintf("%-40s n = %4d   skew %6.2f   Shapiro W %.3f\n",
      label, length(values), skew(values), shapiro.test(values)$statistic))
}

# ----------------------------------------------------------------------
if (show == 1)
{
  # Michelson, 1879: one hundred measurements at the speed of light.  The speed of
  # light did not change between runs, so every bit of this spread is error.
  # Speeds are recorded as (km/s - 299000); the modern value is 299792.458.
  speed <- morley$Speed
  true_value <- 792.458

  standard_error <- sd(speed) / sqrt(length(speed))
  interval <- mean(speed) + c(-1.96, 1.96) * standard_error

  par(mfrow = c(1, 1))
  normal_hist(speed, "Michelson 1879: 100 measurements of ONE fixed quantity",
              "measured speed of light   (km/s - 299000)")
  abline(v = mean(speed), col = "red", lwd = 2, lty = 2)
  abline(v = true_value, col = "blue", lwd = 3)
  legend("topright", legend = c("Michelson's mean", "the true value"),
         col = c("red", "blue"), lwd = c(2, 3), lty = c(2, 1), bty = "n")

  describe("Michelson's 100 runs", speed)
  cat("\n  mean            ", round(mean(speed), 1), "\n")
  cat("  sd (the noise)  ", round(sd(speed), 1), "\n")
  cat("  standard error  ", round(standard_error, 1), "\n")
  cat("  95% interval    ", round(interval[1], 1), "to", round(interval[2], 1), "\n")
  cat("  TRUE value      ", true_value, "\n")
  cat("  -> off by", round((mean(speed) - true_value) / standard_error, 1),
      "standard errors\n")
  cat("\nThe noise is beautifully normal, the interval is narrow, and the answer\n")
  cat("is wrong.  Random error averages away as 1/sqrt(n).  A systematic offset\n")
  cat("does not -- no number of extra runs would have rescued him.\n")
}

# ----------------------------------------------------------------------
if (show == 2)
{
  # The linear model's noise term is whatever the line does not account for.
  # Fit a line, and the leftovers ARE that noise.
  simple <- lm(Weight ~ Height, data = body)
  fuller <- lm(Weight ~ Height + Waist + Gender, data = body)

  par(mfrow = c(1, 3))

  plot(body$Height, body$Weight, pch = 19, col = rgb(0, 0, 0, 0.3),
       xlab = "height (cm)", ylab = "weight (kg)", main = "Weight against height")
  abline(simple, col = "red", lwd = 3)

  normal_hist(residuals(simple), "Leftovers: Weight ~ Height", "kg away from the line")
  normal_hist(residuals(fuller), "Leftovers: + Waist + Gender", "kg away from the line")

  describe("Weight ~ Height", residuals(simple))
  describe("Weight ~ Height + Waist + Gender", residuals(fuller))
  cat("\nThe leftovers of the first model are lopsided -- not because the normal\n")
  cat("assumption is wrong, but because things that matter were left out of the\n")
  cat("model.  Put them in, and the leftovers become normal.\n")
}
