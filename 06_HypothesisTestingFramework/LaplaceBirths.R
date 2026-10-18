# Laplace's question: are boys more likely to be born than girls?
#
# Paris baptism records, 1745 to 1770: 251,527 boys and 241,945 girls.  That
# is 50.97% boys.  Is the probability of a boy, theta, really above 0.5, or
# could a fair "coin" have produced this?
#
# The three curves of TwoPriors.R, for Laplace's data.  The likelihood panel
# also shows the difference between the two frameworks of this section:
# a hypothesis test looks at ONE point on the likelihood curve (theta = 0.5);
# Bayes' theorem uses the WHOLE curve.

share_of_records <- 1   # 1 = all records.  Try 0.01 or 0.001 and run again.
prior_births <- 2000   # 0 = Laplace's flat prior.  Try 20000 and run again.

boys <- round(251527 * share_of_records)    # the data, D ...
girls <- round(241945 * share_of_records)
births <- boys + girls                       # ... out of this many births

theta_null <- 0.5      # the value a hypothesis test would assume

# ---------------------------------------------------------------- the curves

# Candidate values for theta.  The grid is fine because, with this much data,
# the posterior is very narrow.
step <- 0.000001
theta <- seq(0, 1, by = step)

# p(D | theta, M) for every candidate.
likelihood <- dbinom(boys, births, theta)

# Laplace used a flat prior: before seeing the records, every theta between
# 0 and 1 was taken as equally probable.  With prior_births above 0 we use a
# skeptic's prior instead: someone who is sure the ratio is close to 50/50,
# as sure as if they had already seen prior_births births, half of them boys.
# 20000 puts 95% of the prior between 0.493 and 0.507.
prior_shape <- 1 + prior_births / 2
prior <- dbeta(theta, prior_shape, prior_shape)    # flat when prior_births = 0
flat_prior <- dunif(theta)

# Bayes' theorem, candidate by candidate, as in TwoPriors.R.  We also keep the
# posterior under the flat prior, to see how much the prior changed it.
p_data <- sum(likelihood * prior) * step
posterior <- likelihood * prior / p_data
flat_posterior <- likelihood * flat_prior / (sum(likelihood * flat_prior) * step)

# ---------------------------------------------------------------- the numbers

# The hypothesis test uses only the likelihood at theta = 0.5 ...
likelihood_null <- dbinom(boys, births, theta_null)

# ... or, in practice, the p value: the probability of at least this many
# boys if theta = 0.5.  That is a sum over possible data, all at theta = 0.5.
p_value <- pbinom(boys - 1, births, theta_null, lower.tail = FALSE)

# Bayes: the probability that theta is 0.5 or less, the area of the posterior
# left of 0.5.  The grid gives it approximately; the beta distribution exactly.
p_below_grid <- sum(posterior[theta <= theta_null]) * step
p_below <- pbeta(theta_null, boys + prior_shape, girls + prior_shape)

# ---------------------------------------------------------------- the plot

# The likelihood and posterior panels show only a narrow stretch of theta:
# from just below 0.5 to just past the posterior.  Everywhere else both curves
# are flat at zero.
spread <- sqrt(boys * girls / births^3)
shown <- theta >= min(theta_null, boys / births - 5 * spread) - spread &
         theta <= boys / births + 5 * spread

# R shrinks the text when three panels share a row; the cex settings undo that
# so the labels survive being put on a slide.
par(mfrow = c(1, 3), oma = c(0, 0, 3, 0), mar = c(5, 5, 4, 1),
    cex.axis = 1.4, cex.lab = 1.6, cex.main = 1.8)

# The likelihood, with the one point a hypothesis test looks at.
plot(theta[shown], likelihood[shown], type = "l", lwd = 2, col = "steelblue",
     ylim = c(0, max(likelihood) * 1.05), yaxs = "i",
     xlab = bquote(theta), ylab = "probability of the data",
     main = bquote("p(D | " * theta * ", M)"))
abline(v = theta_null, lty = 3)
points(theta_null, likelihood_null, pch = 19, cex = 2, col = "red", xpd = NA)
title(main = bquote("at " * theta * " = " * .(theta_null) * ":  " *
                      .(signif(likelihood_null, 3))),
      line = 0.6, font.main = 1, cex.main = 1.2)

# The prior, over the full range of theta: flat (or not) only means something
# when we see all of it.  The grey strip is the stretch the other two panels zoom
# into.  It has its own y axis: on the posterior's axis it would be a line
# along the bottom.
prior_top <- max(1.2, max(prior) * 1.05)
plot(c(0, 1), c(1, 1), type = "n",
     xlim = c(0, 1), ylim = c(0, prior_top), xaxs = "i", yaxs = "i",
     xlab = bquote(theta), ylab = "density",
     main = bquote("p(" * theta * ")"))
rect(min(theta[shown]), 0, max(theta[shown]), prior_top, col = "grey85",
     border = NA)
lines(theta, prior, lwd = 2, col = "orange")
abline(v = theta_null, lty = 3)
box()
title(main = if (prior_births == 0) "flat" else
               paste("worth", format(prior_births, big.mark = ","),
                     "births, half boys"),
      line = 0.6, font.main = 1, cex.main = 1.2)

# The posterior.
plot(theta[shown], posterior[shown], type = "l", lwd = 2, col = "forestgreen",
     ylim = c(0, max(posterior) * 1.05), yaxs = "i",
     xlab = bquote(theta), ylab = "density",
     main = bquote("p(" * theta * " | D, M)"))
abline(v = theta_null, lty = 3)
if (prior_births > 0) {
  # The posterior Laplace got with the flat prior, for comparison.
  lines(theta[shown], flat_posterior[shown], lwd = 2, lty = 2, col = "grey50")
  legend("topleft", c("this prior", "flat prior"), lwd = 2, lty = c(1, 2),
         col = c("forestgreen", "grey50"), bty = "n", cex = 1.2)
}
title(main = bquote("p(" * theta <= .(theta_null) * " | D, M) = " *
                      .(signif(p_below, 3))),
      line = 0.6, font.main = 1, cex.main = 1.2)

mtext(paste0("observed data D:  ", format(births, big.mark = ","), " births,  ",
             format(boys, big.mark = ","), " boys  (",
             round(100 * boys / births, 2), "%)      dotted line: theta = ",
             theta_null),
      outer = TRUE, line = 0.8, cex = 1)

# ---------------------------------------------------------------- the point

# The hypothesis test asks: if theta were 0.5, how surprising would these data
# be?  It uses the red dot and nothing else.  Bayes' theorem asks: given these
# data, how probable is each theta?  It uses the whole likelihood curve, and
# tells us what theta is (close to 0.51) and how sure we can be (very).
#
# The p value and p(theta <= 0.5 | D) below are close.  That happens whenever
# the prior is flat (try share_of_records = 0.001), and it is part of why p
# values are so easily read as p(theta | D).  They still answer different
# questions, and once the prior is not flat they come apart.
#
# With prior_births = 20000 the skeptic starts out almost sure that theta is
# below 0.507, yet the posterior hardly moves: 493,472 births outweigh a prior
# worth 20,000.  Try share_of_records = 0.01 with the same prior to see the
# prior win.
cat("share of boys              :", round(boys / births, 4), "\n")
cat("posterior mean of theta    :",
    round((boys + prior_shape) / (births + 2 * prior_shape), 4), "\n")
cat("p(D | theta = 0.5, M)      :", signif(likelihood_null, 3), "\n")
cat("p value (theta = 0.5)      :", signif(p_value, 3), "\n")
cat("p(theta <= 0.5 | D), grid  :", signif(p_below_grid, 3), "\n")
cat("p(theta <= 0.5 | D), exact :", signif(p_below, 3), "\n")
cat("95% credible interval      :",
    round(qbeta(c(0.025, 0.975), boys + prior_shape, girls + prior_shape), 4),
    "\n")

# For comparison: Arbuthnot (1710) found more boys than girls in all 82 years
# of London christenings he looked at.  If theta were 0.5, each year would be
# a coin flip, and 82 boy-years in a row would have this probability:
cat("\nArbuthnot, (1/2)^82        :", signif(0.5^82, 3), "\n")
