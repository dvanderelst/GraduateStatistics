# One data set, two candidate coins: where p(D | theta, M) comes from.
#
# CoinInference.R in section 3 threw a coin and then looked at the result
# under four candidate coins.  Here the data are FIXED: they are the throws on
# the slide.  We do not know which coin made them.  All we can do is suppose a
# coin, let the model generate data under that supposition, and see how often
# the generated data look like ours.  That share is p(D | theta, M).

observed <- c("H", "T", "H", "T", "H", "T", "T", "T", "H", "H")   # the data, D
candidates <- c(0.45, 0.65)   # the two values theta can take
repeats <- 10000              # hypothetical data sets per candidate

throws <- length(observed)
heads <- sum(observed == "H")

# ---------------------------------------------------------------- the plot

possible <- 0:throws

# Both panels get the same y axis, so that the two red bars can be compared
# by eye.
ymax <- max(sapply(candidates, function(p) dbinom(possible, throws, p))) * 1.15

par(mfrow = c(1, 2), oma = c(0, 0, 5, 0))

for (p in candidates)
{

  # The model at work: independent throws, one fixed p.  Each repeat is one
  # hypothetical data set, reduced to its statistic (the number of heads).
  simulated <- rbinom(repeats, size = throws, prob = p)
  shares <- table(factor(simulated, levels = possible)) / repeats

  # The red bar: the share of hypothetical data sets that look like ours.
  share <- shares[possible == heads]

  colours <- rep("grey80", length(possible))
  colours[possible == heads] <- "red"

  mids <- barplot(shares, names.arg = possible, col = colours, border = NA,
                  space = 0, ylim = c(0, ymax),
                  xlab = "number of heads in hypothetical data",
                  ylab = "share of data sets")

  # bquote() so that the titles carry the same symbol as the slides.
  title(main = bquote("assume " * theta * " = " * .(p)), line = 2.4)
  title(main = bquote("p(D | " * theta * ", M) = " * .(signif(share, 3))),
        line = 0.9)

  # The binomial distribution is the same model, written as mathematics.  The
  # dots are what the bars settle on as `repeats` grows.
  points(mids, dbinom(possible, throws, p), pch = 19, cex = 0.7)

}

mtext(paste(observed, collapse = " "), outer = TRUE, line = 2.2, cex = 1.1)
mtext(paste0("observed data D:  ", throws, " throws,  ", heads, " heads",
             "      (bars: ", repeats, " simulated data sets;  dots: binomial)"),
      outer = TRUE, line = 0.6, cex = 1)

# ---------------------------------------------------------------- the point

# The data never change.  What changes between the panels is the coin we
# suppose, and with it the probability of seeing what we saw.  Neither red bar
# says how probable the coin is: for that we still need the prior.
cat("observed:", paste(observed, collapse = " "), "\n")
cat("heads   :", heads, "of", throws, "\n\n")
for (p in candidates)
{
  cat("  if theta =", format(p, nsmall = 2), "  p(D | theta, M) =",
      signif(dbinom(heads, throws, p), 3), " (exact)\n")
}
