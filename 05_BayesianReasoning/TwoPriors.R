# Same data, two priors: the three curves of Bayes' theorem.
#
# CoinLikelihoodCurve.R built the likelihood curve.  This script adds the two
# remaining pieces, the prior and the posterior, and lets us swap the prior
# while the data stay exactly the same.

prior_used <- "narrow"   # the switch: "narrow" (machine A) or "wide" (machine B)

heads <- 700               # the data, D: what we actually saw ...
throws <- 1000             # ... in this many flips

# Both priors are centred on 0.5; they differ only in how wide they are.  One
# way to read the numbers: a prior with shapes (a, b) is what we would believe
# after already having seen a heads and b tails from this coin.  Machine A
# comes with 120 flips' worth of trust, machine B with 4.
priors <- list(narrow = c(60, 60),   # machine A: high quality, bias near 0.5
               wide   = c(2, 2))     # machine B: sloppy, bias almost anywhere

# ---------------------------------------------------------------- the curves

# Candidate values for theta.  Everything below is done once per candidate.
step <- 0.001
theta <- seq(0, 1, by = step)

# p(D | theta, M): the red bar of each candidate.  It does not know which
# prior we picked, so it is the same curve whichever way the switch is set.
likelihood <- dbinom(heads, throws, theta)

# Bayes' theorem, candidate by candidate.  The denominator p(D | M) is one
# number: the likelihood averaged over the prior.  Dividing by it changes the
# height of the posterior, so that its area is 1, but not its shape.
posterior_for <- function(shapes)
{
  prior <- dbeta(theta, shapes[1], shapes[2])
  p_data <- sum(likelihood * prior) * step
  list(prior = prior, posterior = likelihood * prior / p_data)
}

curves <- lapply(priors, posterior_for)
shown <- curves[[prior_used]]

# ---------------------------------------------------------------- the plot

# The density axis is set by BOTH priors, not just the one on display.  That
# way nothing but the curves changes when the switch is flipped.
ymax <- max(sapply(curves, function(x) max(x$prior, x$posterior))) * 1.05

# R shrinks the text when three panels share a row; the cex settings undo that
# so the labels survive being put on a slide.
par(mfrow = c(1, 3), oma = c(0, 0, 3, 0), mar = c(5, 5, 4, 1),
    cex.axis = 1.4, cex.lab = 1.6, cex.main = 1.8)

# The likelihood.  Its y axis is a probability (of the data), not a density.
plot(theta, likelihood, type = "l", lwd = 2, col = "steelblue",
     ylim = c(0, max(likelihood) * 1.05), yaxs = "i",
     xlab = bquote(theta), ylab = "probability of the data",
     main = bquote("p(D | " * theta * ", M)"))
abline(v = heads / throws, lty = 3)

# The prior.
plot(theta, shown$prior, type = "l", lwd = 2, col = "orange",
     ylim = c(0, ymax), yaxs = "i",
     xlab = bquote(theta), ylab = "density",
     main = bquote("p(" * theta * ")"))
abline(v = heads / throws, lty = 3)

# The posterior.
plot(theta, shown$posterior, type = "l", lwd = 2, col = "forestgreen",
     ylim = c(0, ymax), yaxs = "i",
     xlab = bquote(theta), ylab = "density",
     main = bquote("p(" * theta * " | D, M)"))
abline(v = heads / throws, lty = 3)

mtext(paste0("observed data D:  ", throws, " flips,  ", heads, " heads",
             "  (dotted line)      prior: ", prior_used),
      outer = TRUE, line = 0.8, cex = 1)

# ---------------------------------------------------------------- the point

# The posterior is a compromise between what we believed and what we saw.
# With the narrow prior ten flips hardly move us: the coin gave 70% heads and
# we still think it is close to fair.  With the wide prior the same ten flips
# carry most of the weight, and the posterior ends up near the data.
best <- theta[which.max(shown$posterior)]
cat("prior               :", prior_used, "\n")
cat("observed proportion :", heads / throws, "\n")
cat("posterior peaks at  :", round(best, 2), "\n")
