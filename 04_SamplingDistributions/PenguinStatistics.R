# The same 31 penguins, the same samples of 5 -- but now we calculate five
# different statistics on every sample, not just the mean.
#
# Every one of them has a sampling distribution.  There is nothing special
# about the mean in that respect.  What IS special about the mean is the SHAPE
# it comes out with, and where it sits.  The other four are the control group
# that shows you this has to be earned, not assumed:
#
#   - the mean lands on the truth, and is bell shaped
#   - the median nearly lands on the truth, but not quite, and it is both
#     lumpier and WIDER than the mean -- a noisier answer to the same question
#   - the sd runs low
#   - the min runs high and the max runs low, both badly, and neither is
#     remotely symmetric
#
# Of the five, only the mean is centred on the truth.
#
# Run PenguinMean.R first; this is the same machinery with a wider net.


population <- c(12, 34, 69, 36, 13, 47, 98, 12, 18, 87, 65,
                42, 98, 76, 34, 18, 10, 89, 90, 78, 65, 53,
                27, 57, 69, 23, 44, 12, 67, 11, 15)

n <- 5              # how many penguins we catch in one sample
repeats <- 10000    # how many times we repeat the whole exercise

# 0 = catch 5 different penguins.  This is what you would actually do, and
#     there really are only 31 birds out there.
# 1 = throw each penguin back before catching the next one.
with_replacement <- 0

N <- length(population)

# ----------------------------------------------------------------------
# The statistics.  A statistic is any recipe that turns a sample into one
# number, so we may as well keep the recipes in a list and apply them all to
# the same sample.  Add your own here and everything below follows along.
# ----------------------------------------------------------------------
statistics <- list(mean = mean, median = median, sd = sd, min = min, max = max)

# How each one is spelled on a plot.  The list keeps the R names, because that
# is what a student types; the plots get prose.
nice <- c(mean = "Mean", median = "Median", sd = "SD",
          min = "Minimum", max = "Maximum")

# The truth: the same recipe applied to all 31 penguins.  Using the identical
# function for both is the point -- it is the SAMPLE that is partial, not the
# recipe that is different.
pop_values <- sapply(statistics, function(f) f(population))

# ----------------------------------------------------------------------
# One loop, five answers per pass.  Each row of the matrix is one imaginary
# research group: they caught 5 penguins and reported all five numbers.
# ----------------------------------------------------------------------
results <- matrix(NA, nrow = repeats, ncol = length(statistics))
colnames(results) <- names(statistics)

for (i in 1:repeats)
{
  a_sample <- sample(population, size = n, replace = with_replacement == 1)
  for (s in 1:length(statistics))
  {
    results[i, s] <- statistics[[s]](a_sample)
  }
}

# ----------------------------------------------------------------------
# Where did each sampling distribution end up?
#
# "Off by" is the gap between the truth and the average answer.  If a
# statistic were going to give you the right answer on average, this column
# would be zero.  Two of them are, three of them are not.
# ----------------------------------------------------------------------
cat("Samples of n =", n, "from", N, "penguins,", repeats, "repeats\n\n")
cat(sprintf("%-8s %12s %12s %10s %10s\n",
            "", "population", "average of", "off by", "spread of"))
cat(sprintf("%-8s %12s %12s %10s %10s\n",
            "statistic", "value", "the answers", "", "the answers"))

for (s in names(statistics))
{
  cat(sprintf("%-8s %12.2f %12.2f %10.2f %10.2f\n",
              s, pop_values[s], mean(results[, s]),
              mean(results[, s]) - pop_values[s], sd(results[, s])))
}

cat("\nOnly the mean is centred on the truth.  The other four are off, and more\n")
cat("repeats will not fix it -- it is the statistic doing this, not bad luck:\n\n")
cat("  min     A sample of 5 can never find a penguin lighter than the\n")
cat("          lightest one there is, but it very easily misses it.  It can\n")
cat("          only err upwards, so it runs high.\n")
cat("  max     The same argument upside down.  It runs low.\n")
cat("  sd      Five penguins rarely include both extremes, so they look more\n")
cat("          alike than the colony really is.\n")
cat("  median  Nearly right, but only nearly.  Note its spread: asking the\n")
cat("          same question with a median instead of a mean gives a noisier\n")
cat("          answer here, not a safer one.\n")

# ----------------------------------------------------------------------
# Six panels: the penguins themselves, then what each statistic does.
#
# The red line is the truth.  Watch which histograms straddle it and which
# sit to one side of it.
# ----------------------------------------------------------------------
par(mfrow = c(2, 3), mar = c(4, 4, 5, 1))

hist(population, breaks = seq(0, 100, by = 5), freq = FALSE,
     col = "grey70", border = "white", xlab = "Weight (kg)",
     main = paste0("The Population\nAll ", N, " Penguins"))

for (s in names(statistics))
{
  values <- results[, s]
  distinct <- sort(unique(values))
  # "Simulated", because we got these by brute force: catch 5, write the
  # number down, repeat.  Later we work some of these out on paper instead,
  # and the two had better agree.
  title <- paste0("Simulated Sampling Distribution\nof the ", nice[s],
                  "   (n = ", n, ")")

  if (length(distinct) <= 40)
  {
    # The min, max and median of 5 penguins can only ever BE one of those 5
    # weights, so these statistics do not take a continuous range of values --
    # they can land on about two dozen numbers and nowhere else.
    #
    # A histogram is the wrong picture for that.  The weights are not evenly
    # spaced (10, 11, 12, 13, 15, 18, 23, ...), so a bar per value would give
    # bars of different widths, and with freq = FALSE the heights get divided
    # by those widths -- making a wide bar look short for no reason.  One
    # spike per attainable value, whose height is simply the proportion of
    # samples that landed there, says it without distorting anything.
    proportion <- as.numeric(table(values)) / length(values)
    plot(distinct, proportion, type = "h", lwd = 4, col = "grey40",
         xlab = paste(nice[s], "of a Sample"), ylab = "Proportion of Samples",
         ylim = c(0, max(proportion) * 1.15), main = title)
    points(distinct, proportion, pch = 19, cex = 0.5, col = "grey40")
  } else {
    # The mean and the sd average things out, so they land anywhere.
    hist(values, breaks = 30, freq = FALSE, col = "grey85", border = "white",
         xlab = paste(nice[s], "of a Sample"), main = title)
  }
  abline(v = pop_values[s], col = "red", lwd = 2, lty = 2)
  abline(v = mean(values), col = "blue", lwd = 2)

  if (s == names(statistics)[1])
  {
    legend("topleft", legend = c("The Truth", "Average Answer"),
           col = c("red", "blue"), lwd = 2, lty = c(2, 1), bty = "n", cex = 0.8)
  }
}

cat("\nRed dashed = the truth.  Blue solid = the average answer.\n")
cat("Where the two lines come apart, the statistic is misleading you.\n")
