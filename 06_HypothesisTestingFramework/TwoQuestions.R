# Two questions about the same data: can people feel the future?
#
# Bem (2011), experiment 1: on each trial, two curtains appear on screen and
# the participant guesses which one hides a picture.  The computer picks the
# picture's position only after the guess.  For erotic pictures, participants
# guessed right 53.1% of the time.  Treating the guesses as independent, that
# is 637 hits out of 1,200.  Theta is the probability of a correct guess;
# pure chance is theta = 0.5.
#
# Left panel:  the hypothesis testing framework.  Theta is fixed at 0.5 and
#              the data vary.  The red area is the p value.
# Right panel: Bayes.  The data are fixed and theta varies.  The red area is
#              p(theta <= 0.5 | D).

prior_weight <- 0      # 0 = flat prior.  Try 10000 and run again.

hits <- 637            # the data, D: correct guesses ...
guesses <- 1200        # ... out of this many

theta_null <- 0.5      # chance: the value a hypothesis test assumes

# ---------------------------------------------------------------- the numbers

# The p value: the probability of at least this many hits if theta = 0.5.
# A sum over possible data, all at one value of theta.
possible_hits <- 0:guesses
sampling <- dbinom(possible_hits, guesses, theta_null)
p_value <- sum(sampling[possible_hits >= hits])

# The prior.  prior_weight is not data: it sets the shape of the prior.
# Above 0 it gives a skeptic's prior, centred on 0.5, and the larger it is,
# the narrower the prior.  The number has a handy reading: the skeptic is as
# sure that guessing is at chance as if they had already watched
# prior_weight guesses, half of them right.
prior_shape <- 1 + prior_weight / 2

# The posterior, candidate by candidate, as in TwoPriors.R.
step <- 0.0001
theta <- seq(0, 1, by = step)
likelihood <- dbinom(hits, guesses, theta)
prior <- dbeta(theta, prior_shape, prior_shape)
posterior <- likelihood * prior / (sum(likelihood * prior) * step)

# p(theta <= 0.5 | D): the area of the posterior left of 0.5.
p_below <- sum(posterior[theta <= theta_null]) * step

# ---------------------------------------------------------------- the plot

par(mfrow = c(1, 2), oma = c(0, 0, 3, 0), mar = c(5, 5, 4, 1),
    cex.axis = 1.2, cex.lab = 1.3, cex.main = 1.3)

# Left: what the data would look like if theta were 0.5.
shown <- possible_hits >= 520 & possible_hits <= 680
plot(possible_hits[shown], sampling[shown], type = "h", lwd = 2,
     col = ifelse(possible_hits[shown] >= hits, "red", "grey60"),
     xlab = "hits out of 1,200", ylab = "probability",
     main = bquote("if " * theta * " = 0.5:  p value = " * .(signif(p_value, 2))))
abline(v = hits, lty = 2)
mtext("observed", side = 3, at = hits, line = 0.2, cex = 0.9)

# Right: what we believe about theta, before (dashed) and after the data.
shown <- theta >= 0.44 & theta <= 0.6
plot(theta[shown], posterior[shown], type = "l", lwd = 2, col = "forestgreen",
     ylim = c(0, max(posterior, prior[shown]) * 1.05),
     xlab = bquote(theta), ylab = "density",
     main = bquote("p(" * theta <= 0.5 * " | D) = " * .(signif(p_below, 2))))
left <- shown & theta <= theta_null
polygon(c(theta[left], rev(theta[left])), c(posterior[left], 0 * theta[left]),
        col = "red", border = NA)
lines(theta[shown], prior[shown], lwd = 2, lty = 2, col = "orange")
abline(v = theta_null, lty = 3)
legend("topright", c("prior", "posterior"), lwd = 2, lty = c(2, 1),
       col = c("orange", "forestgreen"), bty = "n")

mtext(paste0("observed: ", hits, " hits out of ", format(guesses, big.mark = ","),
             " guesses (", round(100 * hits / guesses, 1), "%)      prior: ",
             if (prior_weight == 0) "flat" else
               paste("worth", format(prior_weight, big.mark = ","), "guesses")),
      outer = TRUE, line = 0.8, cex = 1.2)

# ---------------------------------------------------------------- the point

# Both red areas are tails, but of different curves.  The left one is a
# probability of data, with theta fixed.  The right one is a probability of
# theta, with the data fixed.  With a flat prior they come out almost equal,
# which is part of why a p value is so easily read as p(theta | D).  Give
# the prior some weight and they come apart: only the right one uses it.
cat("hit rate                :", round(hits / guesses, 3), "\n")
cat("p value (theta = 0.5)   :", signif(p_value, 3), "\n")
cat("p(theta <= 0.5 | D)     :", signif(p_below, 3), "\n")
