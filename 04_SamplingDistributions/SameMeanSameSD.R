# Four penguin colonies that agree on their mean and their standard deviation
# to fifteen decimal places, and agree on nothing else.
#
# The mean and the sd are a summary, and every summary throws something away.
# Here we throw away the SHAPE, and the point of the script is how much of the
# colony that turns out to be.  Look at Two Humps in particular: its
# mean is 50 kg and there is hardly a penguin within 10 kg of that weight.
#
# show <- 1   the four colonies
# show <- 2   the four colonies, and what the sampling distribution of the
#             mean does with them -- which is where this bites in section 4

show <- 2

target_mean <- 50     # kg
target_sd <- 12       # kg
N <- 2000             # penguins per colony

n <- 5                # sample size, for show = 2
repeats <- 5000

# ----------------------------------------------------------------------
# Force a set of values to have exactly the mean and sd we asked for, without
# touching its shape.  Sliding every penguin by the same amount and then
# stretching every distance from the centre by the same factor cannot turn one
# shape into another -- it only moves and rescales the one you started with.
# ----------------------------------------------------------------------
rescale <- function(x, m, s) {(x - mean(x)) / sd(x) * s + m}

colonies <- list(
  "Bell"      = rescale(rnorm(N), target_mean, target_sd),
  "Flat"      = rescale(runif(N), target_mean, target_sd),
  "Two Humps" = rescale(c(rnorm(N / 2, -1, 0.35), rnorm(N / 2, 1, 0.35)),
                        target_mean, target_sd),
  # Beta rather than a gamma or a lognormal: it is skewed but it has a hard
  # upper edge, so it cannot throw a lone outlier out to 130 kg and force the
  # shared x axis to squash the other three panels flat.
  "Skewed"    = rescale(rbeta(N, 2, 6), target_mean, target_sd))

# How lopsided is it?  0 means symmetric.  This is one of the things the mean
# and the sd do not tell you.
skew <- function(values) {mean(((values - mean(values)) / sd(values))^3)}

# ----------------------------------------------------------------------
cat("Four colonies of", N, "penguins each\n\n")
cat(sprintf("%-11s %8s %8s %8s %10s %10s\n",
            "colony", "mean", "sd", "skew", "lightest", "heaviest"))
for (k in names(colonies))
{
  x <- colonies[[k]]
  cat(sprintf("%-11s %8.2f %8.2f %8.2f %10.1f %10.1f\n",
              k, mean(x), sd(x), skew(x), min(x), max(x)))
}

# Not "the same to two decimals" -- the same to the limit of what the machine
# can represent.  Any difference you can see in the plots is a difference the
# mean and the sd could never have told you about.
off_mean <- max(abs(sapply(colonies, mean) - target_mean))
off_sd <- max(abs(sapply(colonies, sd) - target_sd))
cat(sprintf("\nLargest departure from mean %g: %.2g\n", target_mean, off_mean))
cat(sprintf("Largest departure from sd   %g: %.2g\n", target_sd, off_sd))
cat("\nThe mean and sd columns are identical.  Nothing else is.\n")

# ----------------------------------------------------------------------
# Same x axis on every panel, or the shapes cannot be compared.  The red line
# is the mean and the red bar under it spans one sd either side: both are in
# the same place in all four panels, which is the whole joke.
# ----------------------------------------------------------------------
limits <- range(unlist(colonies))
edges <- seq(limits[1], limits[2], length.out = 40)

draw_colony <- function(k)
{
  x <- colonies[[k]]
  h <- hist(x, breaks = edges, plot = FALSE)

  # mu and sigma, not "mean" and "sd", because these are facts about the whole
  # colony rather than anything measured off a sample.  Greek needs plotmath,
  # so the title is an expression: atop() stacks the two lines, bold() puts
  # back the weight that plotmath otherwise drops from a title.
  mu <- round(mean(x), 1)
  sigma <- round(sd(x), 1)
  hist(x, breaks = edges, freq = FALSE, col = "grey85", border = "white",
       xlim = limits, xlab = "Weight (kg)",
       main = bquote(atop(bold(.(k)), mu == .(mu) * "," ~ sigma == .(sigma))))
  abline(v = mean(x), col = "red", lwd = 2, lty = 2)
  arrows(mean(x) - sd(x), max(h$density) * 0.9,
         mean(x) + sd(x), max(h$density) * 0.9,
         code = 3, angle = 90, length = 0.04, col = "red", lwd = 2)
}

if (show == 1)
{
  par(mfrow = c(2, 2), mar = c(4, 4, 4, 1))
  for (k in names(colonies)) {draw_colony(k)}
}

# ----------------------------------------------------------------------
# Now sample from each of them.
#
# sd / sqrt(n) never asks what shape the colony was.  It is handed a mean and
# an sd, and those are identical here -- so it has to give the same answer for
# all four, and it does.  Four colonies you would never mistake for one
# another produce four sampling distributions you cannot tell apart.
#
# This is why the formula is worth having.  It also shows what you gave up to
# get it: everything the mean and sd left out stopped mattering.
# ----------------------------------------------------------------------
if (show == 2)
{
  means <- matrix(NA, nrow = repeats, ncol = length(colonies))
  colnames(means) <- names(colonies)
  for (k in names(colonies))
  {
    for (i in 1:repeats)
    {
      means[i, k] <- mean(sample(colonies[[k]], size = n))
    }
  }

  cat("\n\nSampling distribution of the mean, n =", n, "\n\n")
  cat(sprintf("%-11s %14s %14s %10s\n",
              "colony", "mean of means", "sd of means", "skew"))
  for (k in names(colonies))
  {
    cat(sprintf("%-11s %14.2f %14.2f %10.2f\n",
                k, mean(means[, k]), sd(means[, k]), skew(means[, k])))
  }
  cat(sprintf("\nsd / sqrt(n) predicts %.2f for every one of them.\n",
              target_sd / sqrt(n)))

  # The colonies on top, what the mean does with them underneath.  Each
  # sampling distribution sits directly below the colony it came from.
  par(mfrow = c(2, 4), mar = c(4, 4, 4, 1))

  for (k in names(colonies)) {draw_colony(k)}

  mean_limits <- range(means)
  for (k in names(colonies))
  {
    hist(means[, k], breaks = seq(mean_limits[1], mean_limits[2],
                                  length.out = 30),
         freq = FALSE, col = "grey60", border = "white", xlim = mean_limits,
         xlab = "Mean of a Sample (kg)",
         main = paste0("Mean of ", n, " From ", k, "\nSD = ",
                       round(sd(means[, k]), 2)))
    abline(v = target_mean, col = "red", lwd = 2, lty = 2)
  }

  cat("\nFour colonies you could never confuse; four sampling distributions\n")
  cat("you cannot tell apart.  With n =", n,
      "the skewed one still leans a little --\n")
  cat("raise n and that goes too.\n")
}
