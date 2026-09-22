# A world parameter: the average height of Gentoo penguins.
#
# The coin scripts inferred the bias of one coin.  Nothing changes when the
# parameter describes the world instead of a case: suppose a value for theta,
# ask the model how probable our data are under it, do that for every value,
# and combine the result with the prior.
#
# Figure 1: the data, and the population that each of three thetas proposes.
# Figure 2: the priors we could choose from.
# Figure 3: likelihood, prior and posterior for the prior we picked.

prior_used <- "two_camps"   # the switch: "confident", "vague" or "two_camps"
save_images <- FALSE        # TRUE writes the figures to PNG files for slides

# The data, D: the heights (cm) of the penguins we managed to measure.  Use
# fewer of them, heights[1:3], to see what the prior does when data are scarce.
heights <- c(81.2, 76.4, 79.9, 83.1, 77.5, 78.8, 74.9, 80.6)

# The model: heights are normally distributed around theta.  We take the
# spread as known, so that theta is the only parameter left to infer.
sd_known <- 3

# Three candidates to look at closely in figure 1.
candidates <- c(77, 79, 82)

# We are free to choose the prior.  Each of these is a belief about theta
# held BEFORE measuring a single penguin.
priors <- list(
  confident = function(theta) dnorm(theta, 75, 1),    # "it is 75, give or take"
  vague     = function(theta) dnorm(theta, 75, 5),    # "somewhere around 75"
  two_camps = function(theta) 0.5 * dnorm(theta, 72, 1.5) +
                              0.5 * dnorm(theta, 80, 1.5))   # two rival books

# ---------------------------------------------------------------- the curves

step <- 0.01
theta <- seq(65, 90, by = step)

# p(D | theta, M): how probable are ALL our heights if the mean were theta?
# The penguins are independent, so the probabilities multiply.
likelihood_of <- function(candidate) prod(dnorm(heights, candidate, sd_known))
likelihood <- sapply(theta, likelihood_of)

# Heights are continuous, so these numbers are densities and they are tiny
# (around 1e-9 here).  Only the shape of the curve matters, because the
# denominator of Bayes' theorem rescales it anyway.  We therefore show the
# RELATIVE likelihood: each candidate's likelihood divided by that of the best
# candidate.  0.15 means the data are 0.15 times as probable under this theta
# as under the theta that explains them best.
best <- max(likelihood)
relative <- likelihood / best

# Bayes' theorem, candidate by candidate, exactly as for the coin.
posterior_for <- function(prior_function)
{
  prior <- prior_function(theta)
  prior <- prior / (sum(prior) * step)
  list(prior = prior,
       posterior = likelihood * prior / (sum(likelihood * prior) * step))
}

curves <- lapply(priors, posterior_for)
prior <- curves[[prior_used]]$prior
posterior <- curves[[prior_used]]$posterior

# The range that holds the middle 95% of the posterior.
cumulative <- cumsum(posterior) * step
interval <- c(theta[which(cumulative >= 0.025)[1]],
              theta[which(cumulative >= 0.975)[1]])

# ---------------------------------------------------------------- the plots

candidate_colours <- c("firebrick", "purple", "grey30")
prior_types <- c(confident = 1, vague = 2, two_camps = 4)   # line types

# Three separate figures.  In RStudio, use the arrows of the Plots pane to
# move between them.  With save_images switched on they are written to PNG
# files at slide size instead.
show_figure <- function(name, draw, width = 1900, height = 800)
{
  if (save_images)
  {
    png(paste0("PenguinPosterior_", name, ".png"),
        width = width, height = height, res = 150)
    draw()
    dev.off()
  } else
  {
    draw()
  }
}

# Figure 1: what a candidate theta IS.  Each candidate is a claim about the
# whole population, so each is a different curve over HEIGHT.  Remember this
# when reading the other figures: every point on their theta axis stands for
# one such hypothetical population.  A candidate makes the data probable when
# the dots sit under the bulk of its curve.
draw_candidates <- function()
{
  par(mfrow = c(1, 1), oma = c(0, 0, 0, 0), mar = c(5, 5, 4, 1),
      cex.axis = 1.3, cex.lab = 1.5, cex.main = 1.7)

  height_axis <- seq(65, 90, by = 0.05)
  plot(NA, xlim = range(height_axis), ylim = c(0, dnorm(0, 0, sd_known) * 1.5),
       yaxs = "i", xlab = "height (cm)", ylab = "density",
       main = "one data set, three hypothetical populations", font.main = 1)
  for (i in seq_along(candidates))
  {
    lines(height_axis, dnorm(height_axis, candidates[i], sd_known),
          lwd = 3, col = candidate_colours[i])
    segments(candidates[i], 0, candidates[i], dnorm(0, 0, sd_known),
             lty = 3, col = candidate_colours[i])
  }
  points(heights, rep(0.004, length(heights)), pch = 19, cex = 1.8)
  legend("topleft", bty = "n", lwd = 3, col = candidate_colours, cex = 1.3,
         legend = as.expression(lapply(candidates, function(candidate)
           bquote(theta * " = " * .(candidate) * "     relative likelihood " *
                  .(signif(likelihood_of(candidate) / best, 2))))))
  legend("topright", bty = "n", pch = 19, pt.cex = 1.8, cex = 1.3,
         legend = "measured penguins")
}

# Figure 2: the priors we could choose from, in one picture.
draw_priors <- function()
{
  par(mfrow = c(1, 1), oma = c(0, 0, 0, 0), mar = c(5, 5, 4, 1),
      cex.axis = 1.3, cex.lab = 1.5, cex.main = 1.7)

  plot(NA, xlim = range(theta),
       ylim = c(0, max(sapply(curves, function(x) max(x$prior))) * 1.05),
       yaxs = "i", xlab = bquote(theta * ": average Gentoo height (cm)"),
       ylab = "density",
       main = bquote("three priors, p(" * theta * "): beliefs before any data"))
  for (name in names(curves))
  {
    lines(theta, curves[[name]]$prior, lwd = 3, col = "orange",
          lty = prior_types[name])
  }
  legend("topright", bty = "n", lwd = 3, col = "orange", cex = 1.3,
         lty = prior_types[names(curves)], legend = names(curves))
}

# Figure 3: likelihood, prior and posterior for the prior picked by the switch.
draw_update <- function()
{
  par(mfrow = c(1, 3), oma = c(0, 0, 3, 0), mar = c(5, 5, 4, 1),
      cex.axis = 1.4, cex.lab = 1.6, cex.main = 1.8)

  # The likelihood.  The three coloured dots are the three populations of
  # figure 1, each boiled down to one number.
  plot(theta, relative, type = "l", lwd = 2, col = "steelblue",
       ylim = c(0, 1.05), yaxs = "i",
       xlab = bquote("candidate " * theta),
       ylab = "relative likelihood",
       main = bquote("p(D | " * theta * ", M)"))
  points(candidates, sapply(candidates, likelihood_of) / best,
         pch = 19, cex = 1.8, col = candidate_colours)

  # Prior and posterior share a y axis, so the two densities compare by eye.
  # It is set by ALL the priors, so that only the curves change when the
  # switch is flipped.
  ymax <- max(sapply(curves, function(x) max(x$prior, x$posterior))) * 1.05

  plot(theta, prior, type = "l", lwd = 2, col = "orange",
       lty = prior_types[prior_used], ylim = c(0, ymax), yaxs = "i",
       xlab = bquote(theta), ylab = "density",
       main = bquote("p(" * theta * ")"))
  abline(v = mean(heights), lty = 3)

  # The posterior.  The same three populations sit on this curve as well: its
  # height at a theta says how believable that population still is.
  plot(theta, posterior, type = "l", lwd = 2, col = "forestgreen",
       ylim = c(0, ymax), yaxs = "i",
       xlab = bquote(theta), ylab = "density",
       main = bquote("p(" * theta * " | D, M)"))
  inside <- theta >= interval[1] & theta <= interval[2]
  polygon(c(interval[1], theta[inside], interval[2]), c(0, posterior[inside], 0),
          col = adjustcolor("forestgreen", alpha.f = 0.25), border = NA)
  abline(v = mean(heights), lty = 3)
  points(candidates, posterior[match(candidates, round(theta, 2))],
         pch = 19, cex = 1.8, col = candidate_colours)

  mtext(paste0("observed data D:  ", length(heights),
               " penguins,  mean height ", round(mean(heights), 1),
               " cm  (dotted line)      prior: ", prior_used),
        outer = TRUE, line = 0.8, cex = 1.1)
}

show_figure("1_candidates", draw_candidates)
show_figure("2_priors", draw_priors)
show_figure(paste0("3_update_", prior_used), draw_update)

# ---------------------------------------------------------------- the point

# We never see theta.  What we end up with is not a number but a distribution:
# a statement of which average heights remain believable after these penguins,
# given where we started.  The shaded range is the honest answer to "what is
# the average height of a Gentoo?".
cat("prior               :", prior_used, "\n")
cat("penguins measured   :", length(heights), "\n")
cat("sample mean         :", round(mean(heights), 2), "cm\n")
cat("posterior peaks at  :", round(theta[which.max(posterior)], 2), "cm\n")
cat("95% of the posterior:", round(interval[1], 1), "to",
    round(interval[2], 1), "cm\n")
