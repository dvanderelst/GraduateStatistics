# From one candidate coin to all of them: how the likelihood curve is built.
#
# CoinLikelihood.R supposed a coin, generated data under it, and read off the
# red bar: the share of generated data sets that look like ours.  That gave
# one number for one candidate.  Here we do the same for every candidate
# between 0 and 1, and plot the red bars against the candidate they came from.
#
# Left panel:  ONE candidate theta, all possible data.
# Right panel: ALL candidate thetas, only the data we actually saw.
# The red bar on the left and the red dot on the right are the same number.

theta_shown <- 0.3     # the candidate on display.  Change this and run again.

heads <- 7             # the data, D: what we actually saw ...
throws <- 10           # ... in this many flips
repeats <- 10000       # hypothetical data sets per candidate

# ---------------------------------------------------------------- one candidate

possible <- 0:throws

# The model at work: independent flips, one fixed theta.  Each repeat is one
# hypothetical data set, reduced to its statistic (the number of heads).
simulated <- rbinom(repeats, size = throws, prob = theta_shown)
shares <- table(factor(simulated, levels = possible)) / repeats

# The red bar: p(D | theta, M) for the candidate on display.
share_shown <- shares[possible == heads]

# ---------------------------------------------------------------- every candidate

# The same procedure, once for each candidate on a grid.  For each we keep only
# the red bar and throw the rest of the bar chart away.
grid <- seq(0, 1, by = 0.02)
share_grid <- sapply(grid, function(theta)
  mean(rbinom(repeats, size = throws, prob = theta) == heads))

# The binomial distribution gives the same numbers without any simulating.
fine <- seq(0, 1, by = 0.001)
exact <- dbinom(heads, throws, fine)

# ---------------------------------------------------------------- the plot

# Both panels get the same y axis, so the red bar and the red dot sit at the
# same height and the dashed line can run through both.
ymax <- max(shares, exact) * 1.15

par(mfrow = c(1, 2), oma = c(0, 0, 3, 0))

# Left: the sampling distribution for the candidate on display.
colours <- rep("grey80", length(possible))
colours[possible == heads] <- "red"

mids <- barplot(shares, names.arg = possible, col = colours, border = NA,
                space = 0, ylim = c(0, ymax),
                xlab = "number of heads in hypothetical data",
                ylab = "share of data sets")
points(mids, dbinom(possible, throws, theta_shown), pch = 19, cex = 0.7)
abline(h = share_shown, lty = 2, col = "red")

# In both panels grey is simulated and black is the binomial.  The legend goes
# to whichever side the bars leave free.
legend(ifelse(theta_shown > 0.5, "topleft", "topright"),
       legend = c("simulated", "binomial"), col = c("grey80", "black"),
       pch = c(15, 19), pt.cex = c(1.8, 0.7), bty = "n")

# bquote() so that the titles carry the same symbol as the slides.
title(main = bquote("assume " * theta * " = " * .(theta_shown)), line = 2.4)
title(main = bquote("p(D | " * theta * ", M) = " * .(signif(share_shown, 3))),
      line = 0.9)

# Right: the red bar of every candidate, plotted against the candidate.
plot(grid, share_grid, pch = 19, cex = 0.6, col = "grey60",
     xlim = c(0, 1), ylim = c(0, ymax), yaxs = "i",
     xlab = bquote("candidate " * theta),
     ylab = bquote("p(D | " * theta * ", M)"))
lines(fine, exact)
abline(h = share_shown, lty = 2, col = "red")
segments(theta_shown, 0, theta_shown, share_shown, lty = 3, col = "red")
points(theta_shown, share_shown, pch = 19, cex = 1.5, col = "red")

legend(ifelse(heads / throws > 0.5, "topleft", "topright"),
       legend = c("simulated", "binomial", bquote(theta * " on the left")),
       col = c("grey60", "black", "red"), pch = c(19, NA, 19),
       lty = c(NA, 1, NA), pt.cex = c(0.6, NA, 1.5), bty = "n")

title(main = bquote("every " * theta * " from 0 to 1"), line = 2.4)
title(main = "the red bar of each", line = 0.9, font.main = 1)

mtext(paste0("observed data D:  ", throws, " flips,  ", heads, " heads",
             "      (", repeats, " simulated data sets per ", "candidate)"),
      outer = TRUE, line = 1, cex = 1)

# ---------------------------------------------------------------- the point

# On the left the coin is fixed and the data vary: the bars are a probability
# distribution and sum to 1.  On the right the data are fixed and the coin
# varies: every height is a probability, but each comes from a different bar
# chart, so the curve is NOT a distribution over theta and its area is not 1.
# It is called the likelihood.  It says which coins make our data
# unsurprising; it does not yet say how probable each coin is.
cat("candidate on display: theta =", theta_shown, "\n")
cat("  p(D | theta, M) =", signif(dbinom(heads, throws, theta_shown), 3),
    " (exact)\n\n")
cat("area under the likelihood curve:",
    round(integrate(function(theta) dbinom(heads, throws, theta), 0, 1)$value, 3),
    "\n")
