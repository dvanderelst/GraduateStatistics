# Question 1c, drawn.  Two colonies that agree on mu and on sigma -- one bell
# shaped, one badly skewed -- and what the mean of n penguins does with each.
#
# The table in question 1c asks for three things about the sampling
# distribution, and each one has a different status:
#
#   its mean   mu                exact, whatever the colony looks like
#   its sd     sigma / sqrt(n)   exact, whatever the colony looks like
#   its shape  ???               this is the one that depends on the colony
#
# The first two columns of the console output below are the same for both
# colonies, because those two formulas were never told what shape the colony
# was -- they are handed a mu and a sigma and nothing else.  The pictures are
# not the same.  Everything interesting in this script is in the third row.
#
# There are two rulers here and the t belongs to only one of them:
#
#   row 2   kilograms.   xbar has mean mu and sd sigma/sqrt(n).  For the bell
#           colony its shape is EXACTLY normal -- not approximately.  There is
#           no t anywhere in this row.  Drawing one here would draw a curve
#           that is too wide and fits nothing, because nothing in this row has
#           been divided by a sample sd.
#
#   row 3   standard errors, counted with the sample's own s rather than with
#           sigma.  This is where the t lives, and for the bell colony it is
#           again EXACT.  The normal is the one that is merely close.
#
# So "exact" is true twice over, for two different quantities.  The question
# is never whether a curve is exact, it is what the curve is exact ABOUT.
#
# Section 4, BIOL8001.  Companion to SameMeanSameSD.R and TCurve.R.


n <- 8                # penguins in one sample -- the number to turn in class
repeats <- 20000      # how many times we repeat the whole exercise

target_mean <- 50     # kg, mu.  Both colonies get this
target_sd <- 12       # kg, sigma.  Both colonies get this too
N <- 2000             # penguins per colony

# How lopsided the skewed colony is.  rbeta(N, 1.5, 6) is a hard skew with a
# long right tail; make the first number bigger and it drifts back towards a
# bell, which is worth doing live once the failure has been seen.
skew_shape <- c(1.5, 6)

t_window <- 5         # row 3 is drawn from -t_window to +t_window.  The
                      # skewed colony throws t values far past this; the
                      # console says how many, which is itself the point.

set.seed(4010)        # comment out to see it wobble

# ----------------------------------------------------------------------
# Two colonies, forced to the same mu and the same sigma.  Sliding every
# penguin by a fixed amount and stretching every distance from the centre by a
# fixed factor cannot change a shape -- it only moves and rescales the one you
# started with.  So the shapes stay as different as they were, and the two
# summary numbers come out identical.
# ----------------------------------------------------------------------
rescale <- function(x, m, s) {(x - mean(x)) / sd(x) * s + m}

colonies <- list(
  "Bell"   = rescale(rnorm(N), target_mean, target_sd),
  "Skewed" = rescale(rbeta(N, skew_shape[1], skew_shape[2]),
                     target_mean, target_sd))

skew <- function(values) {mean(((values - mean(values)) / sd(values))^3)}

se <- target_sd / sqrt(n)     # what sigma/sqrt(n) predicts, for both
df <- n - 1

# ----------------------------------------------------------------------
# Catch n penguins, write down two numbers: the mean of the sample, and the sd
# of the sample.  The second one is the whole reason the t exists -- it is the
# stand-in we use when sigma is not available, and it changes from sample to
# sample while sigma never does.
# ----------------------------------------------------------------------
sample_mean <- matrix(NA, nrow = repeats, ncol = length(colonies))
sample_sd <- matrix(NA, nrow = repeats, ncol = length(colonies))
colnames(sample_mean) <- names(colonies)
colnames(sample_sd) <- names(colonies)

for (k in names(colonies))
{
  for (i in 1:repeats)
  {
    a_sample <- sample(colonies[[k]], size = n)
    sample_mean[i, k] <- mean(a_sample)
    sample_sd[i, k] <- sd(a_sample)
  }
}

# The kilogram answer standardised by the sample's own s.  Dividing by
# sigma/sqrt(n) instead would just relabel row 2 and give back a normal; it is
# the s in the denominator that produces a t.
t_value <- (sample_mean - target_mean) / (sample_sd / sqrt(n))

# ----------------------------------------------------------------------
# The two columns the formulas fill in, and the one they do not.
# ----------------------------------------------------------------------
cat("Two colonies of", N, "penguins, mu =", target_mean, "kg, sigma =",
    target_sd, "kg\n")
cat("Samples of n =", n, ",", repeats, "repeats\n\n")

cat(sprintf("%-8s %10s %10s %10s %10s %10s\n",
            "colony", "skew", "mean of", "sigma/sqrt", "sd of", "skew of"))
cat(sprintf("%-8s %10s %10s %10s %10s %10s\n",
            "", "of colony", "the means", "(n)", "the means", "the means"))
for (k in names(colonies))
{
  cat(sprintf("%-8s %10.2f %10.2f %10.2f %10.2f %10.2f\n",
              k, skew(colonies[[k]]), mean(sample_mean[, k]), se,
              sd(sample_mean[, k]), skew(sample_mean[, k])))
}

cat("\nBoth colonies land on mu and on sigma/sqrt(n).  Those two entries in the\n")
cat("table are exact for any colony at any n -- neither formula was ever told\n")
cat("what shape it was dealing with.  The last column is where they part.\n")

# ----------------------------------------------------------------------
# Question 1d, in numbers.  Take the normal curve at face value and ask it for
# a tail probability, then count how often it actually happened.  For the bell
# colony the two agree because the curve is right; for the skewed colony they
# do not, and no amount of extra repeats will bring them together.
# ----------------------------------------------------------------------
cut <- target_mean + 1.645 * se

cat("\n\nP(sample mean >", round(cut, 2), "kg), which a normal curve with mean",
    target_mean, "\nand sd", round(se, 2), "puts at 0.0500:\n\n")
cat(sprintf("%-8s %14s %12s\n", "colony", "actually", "off by"))
for (k in names(colonies))
{
  got <- mean(sample_mean[, k] > cut)
  cat(sprintf("%-8s %14.4f %12.4f\n", k, got, got - 0.05))
}

# ----------------------------------------------------------------------
# The same check one ruler over.  95% of a t(df) lies inside these limits, and
# it is worth reading the two tails separately: a colony with a long right
# tail does not push the t out symmetrically, it pushes it out to the LEFT.
# A sample that catches one heavy penguin gets a big mean AND a big s, and the
# big s in the denominator pulls t back towards zero; a sample that misses the
# tail entirely gets a small mean and a very small s, and that is the
# combination that throws t a long way negative.
# ----------------------------------------------------------------------
lim <- qt(0.975, df)

cat("\n\nWhere the t values fell.  t(", df, ") says 2.5% below ",
    round(-lim, 3), " and 2.5% above ", round(lim, 3), ":\n\n", sep = "")
cat(sprintf("%-8s %12s %12s %14s\n",
            "colony", "below", "above", paste0("past +-", t_window)))
for (k in names(colonies))
{
  cat(sprintf("%-8s %12.4f %12.4f %14.4f\n",
              k, mean(t_value[, k] < -lim), mean(t_value[, k] > lim),
              mean(abs(t_value[, k]) > t_window)))
}

cat("\nThe bell colony splits it 2.5 / 2.5, because the t is exactly right\n")
cat("there.  The skewed colony does not, and the two tails are wrong by\n")
cat("different amounts -- so the error is not 'a bit too wide', it is lopsided.\n")

# ----------------------------------------------------------------------
# Six panels.  Columns are the two colonies, rows are the three things worth
# looking at.  Both columns of a row share an x axis, or the shapes cannot be
# compared.
# ----------------------------------------------------------------------
par(mfrow = c(3, 2), mar = c(4.2, 4, 4, 1))

# Row 1: the colonies.  The red dashed line is mu and the red bar spans one
# sigma either side.  Both sit in the same place in both panels, which is the
# joke: the summary cannot see the difference you are looking at.
colony_limits <- range(unlist(colonies))
colony_edges <- seq(colony_limits[1], colony_limits[2], length.out = 45)

for (k in names(colonies))
{
  x <- colonies[[k]]
  h <- hist(x, breaks = colony_edges, plot = FALSE)
  hist(x, breaks = colony_edges, freq = FALSE, col = "grey85", border = "white",
       xlim = colony_limits, xlab = "Weight (kg)", ylab = "Density",
       main = bquote(atop(bold(.(k) ~ "Colony"),
                          mu == .(round(mean(x), 1)) * " kg," ~
                          sigma == .(round(sd(x), 1)) * " kg")))
  abline(v = mean(x), col = "red", lwd = 2, lty = 2)
  arrows(mean(x) - sd(x), max(h$density) * 0.9,
         mean(x) + sd(x), max(h$density) * 0.9,
         code = 3, angle = 90, length = 0.04, col = "red", lwd = 2)
}

# Row 2: the kilogram ruler.  One curve only, N(mu, sigma/sqrt(n)), because
# that is the only curve this row is about.  For Bell the fit is exact; for
# Skewed at a small n the histogram still leans and the curve cannot follow it.
mean_limits <- c(target_mean - 4.5 * se, target_mean + 4.5 * se)
mean_edges <- seq(min(sample_mean) - 1, max(sample_mean) + 1, by = se / 6)
kg_grid <- seq(mean_limits[1], mean_limits[2], length.out = 400)

for (k in names(colonies))
{
  hist(sample_mean[, k], breaks = mean_edges, freq = FALSE, col = "grey85",
       border = "white", xlim = mean_limits, xlab = "Mean of the Sample (kg)",
       ylab = "Density",
       main = bquote(atop(bold("Mean of" ~ .(n) ~ "From" ~ .(k)),
                          "sd of the means =" ~ .(round(sd(sample_mean[, k]), 2))
                          ~ "kg")))
  lines(kg_grid, dnorm(kg_grid, target_mean, se), col = "red", lwd = 2.2)
  abline(v = target_mean, col = "red", lwd = 1.5, lty = 2)

  if (k == names(colonies)[1])
  {
    legend("topright", legend = bquote("N(" * mu * "," ~ sigma / sqrt(n) * ")"),
           col = "red", lwd = 2.2, bty = "n", cex = 0.85)
  }
}

# Row 3: the t ruler.  Same samples, divided by their own s instead of by
# sigma.  Now there are two curves to compare, and for Bell the t is the one
# that fits -- the normal is too narrow in the tails, which is the whole of
# question 4 arriving early.
t_grid <- seq(-t_window, t_window, length.out = 600)
t_edges <- seq(floor(min(t_value)) - 1, ceiling(max(t_value)) + 1, by = 0.2)

for (k in names(colonies))
{
  hist(t_value[, k], breaks = t_edges, freq = FALSE, col = "grey85",
       border = "white", xlim = c(-t_window, t_window),
       xlab = "(mean - mu) / (s / sqrt(n))", ylab = "Density",
       main = bquote(atop(bold("The Same Samples, Divided by Their Own s"),
                          .(k) * ", df =" ~ .(df))))
  lines(t_grid, dt(t_grid, df), col = "blue", lwd = 2.4)
  lines(t_grid, dnorm(t_grid), col = "red", lwd = 2, lty = 2)
  abline(v = 0, col = "grey50", lwd = 1, lty = 3)

  if (k == names(colonies)[1])
  {
    legend("topright", legend = c(paste0("t, df = ", df), "standard normal"),
           col = c("blue", "red"), lwd = c(2.4, 2), lty = c(1, 2),
           bty = "n", cex = 0.85)
  }
}

cat("\n\nRow 2 is kilograms and has one curve, because on that ruler the mean of\n")
cat("a sample from a normal colony IS normal, exactly.  Row 3 is the same\n")
cat("samples divided by their own s, and there the t is the exact one and the\n")
cat("normal is the approximation.  Two exact answers about two quantities.\n")
cat("\nThe right-hand column is neither, at n =", n, ".  Raise n to 30 and watch\n")
cat("both rows on that side come into line -- that is the only thing the\n")
cat("central limit theorem ever promised, and it says nothing about row 1.\n")
