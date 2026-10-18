# How often is a "significant" finding true?  It depends on the prior.
#
# Ioannidis (2005): of all findings with p < alpha, the share that report a
# real effect is the positive predictive value (PPV).  Without bias,
#
#   PPV = p_e * power / (p_e * power + (1 - p_e) * alpha)
#
# where p_e is the prior probability that the effect is real.  This is the
# same calculation as the penguin disease test in 05: prevalence -> p_e,
# true positive rate -> power, false positive rate -> alpha.

alpha <- 0.05          # false positive rate of each test
power <- 0.80          # chance of p < alpha when the effect is real

# ---------------------------------------------------------------- the curve

p_e <- seq(0, 1, by = 0.001)
ppv <- p_e * power / (p_e * power + (1 - p_e) * alpha)

# ---------------------------------------------------------------- the plot

par(mar = c(5, 5, 4, 1), cex.axis = 1.2, cex.lab = 1.3, cex.main = 1.4)

plot(p_e, ppv, type = "l", lwd = 2, ylim = c(0, 1), yaxs = "i",
     xlab = bquote("prior probability that the effect is real, " * p[e]),
     ylab = "PPV",
     main = bquote(alpha * " = " * .(alpha) * ",  power = " * .(power)))
abline(h = 0.5, lty = 3)

# ---------------------------------------------------------------- the point

# When few of the tested effects are real, most significant findings are
# false, even with decent power.  Below this prior, PPV is under 0.5:
cat("PPV < 0.5 when p_e <", round(alpha / (alpha + power), 3), "\n")
