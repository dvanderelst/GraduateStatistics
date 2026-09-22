# Two researchers go to the same colony, catch five penguins each, and come
# back with two different t pictures.  Neither of them made a mistake.
#
# TAxisInKilograms.R put two rulers under one curve.  This script is the next
# question: where did that ruler come from?  It came from s, and s is
# something you measured -- so a second sample brings a second ruler.
#
# The thing to watch, and the thing students get backwards:
#
#   on the t axis     nothing depends on the data.  With the same n the two
#                     curves are the SAME curve.  dt() is handed df and
#                     nothing else; it never sees a penguin.  Change n and the
#                     curves differ, but only through df -- still not through
#                     the weights.
#
#   in kilograms      everything depends on the data.  One step along the t
#                     axis is worth s/sqrt(n) kg, and s came out of the sample.
#                     Sample A's t = 2 and sample B's t = 2 sit in completely
#                     different places on the scale.
#
# So "the t distribution depends on the observed data" is true and false
# depending on which ruler you are holding, and the top two panels are the
# same shape twice with the tick labels moved.  What the data bought you is
# not a shape.  It is the exchange rate.
#
# Section 4, BIOL8001.  Companion to TAxisInKilograms.R and TCurve.R.


mu <- 50            # kg, the value the curve is centred on.  We are asking
                    # where sample means fall IF the colony mean is 50
sigma <- 12         # kg, the colony's true sd.  Used only to draw the two
                    # samples below -- neither researcher gets to see it, and
                    # it appears nowhere in a t calculation

n_a <- 5            # penguins caught by researcher A
n_b <- 5            # and by researcher B.  Set this to 15 to let the sample
                    # SIZE differ too, and the two curves stop matching even
                    # on the t axis -- different df, different shape

# Seed 429 gives two samples that agree about where the colony sits and
# disagree by a factor of two and a half about how wide a kilogram is.  That
# is the lesson, so the seed is chosen rather than lucky -- the console says
# below how ordinary each of the two draws actually is.  Comment it out and
# keep running the script to watch the ruler breathe.
set.seed(429)

# Escape hatch: put real numbers here, from class or from a data sheet, and
# the simulation is skipped.  c(41, 63, 38, 55, 44) and so on.
weights_a <- NULL
weights_b <- NULL

# 1 draws the grey double arrow under each curve spanning the middle 95%, so
#   the two widths can be compared in kilograms directly.  It is a span of the
#   curve and nothing more -- no test is being run, and no claim is being made
#   about any particular colony.  0 leaves the curves bare.
show_span <- 1

# ----------------------------------------------------------------------
# Two samples, one colony.
# ----------------------------------------------------------------------
if (is.null(weights_a)) {weights_a <- rnorm(n_a, mu, sigma)}
if (is.null(weights_b)) {weights_b <- rnorm(n_b, mu, sigma)}

n_a <- length(weights_a)
n_b <- length(weights_b)

samples <- list("A" = weights_a, "B" = weights_b)

# Everything each researcher can actually compute.  Note what is missing:
# sigma.  It went into making the penguins and plays no further part.
stats <- lapply(samples, function(x)
  list(n = length(x), xbar = mean(x), s = sd(x),
       se = sd(x) / sqrt(length(x)), df = length(x) - 1))

cat("Both samples come from one colony: mu =", mu, "kg, sigma =", sigma, "kg\n")
cat("Neither researcher knows either of those numbers.\n\n")

for (k in names(samples))
{
  cat("Researcher", k, "caught", stats[[k]]$n, "penguins:\n  ")
  cat(paste(sprintf("%.1f", sort(samples[[k]])), collapse = "  "), "kg\n")
  cat(sprintf("  xbar = %.2f kg    s = %.2f kg    se = s/sqrt(n) = %.2f kg    df = %d\n\n",
              stats[[k]]$xbar, stats[[k]]$s, stats[[k]]$se, stats[[k]]$df))
}

# ----------------------------------------------------------------------
# The exchange rate, which is the whole script in one table.  Same t readings
# down the left, two different kilogram columns beside them.
# ----------------------------------------------------------------------
cat(sprintf("%8s %16s %16s\n", "t", "kg for A", "kg for B"))
for (m in -3:3)
{
  cat(sprintf("%8.0f %16.2f %16.2f%s\n", m,
              mu + m * stats$A$se, mu + m * stats$B$se,
              if (m == 0) "   <- mu" else ""))
}

cat(sprintf("\nOne step along the t axis is %.2f kg for A and %.2f kg for B.\n",
            stats$A$se, stats$B$se))
cat(sprintf("A's ruler is %.1f times the size of B's, from the same colony.\n",
            stats$A$se / stats$B$se))

# ----------------------------------------------------------------------
# The middle 95% of each curve, in both currencies.  With equal n the t column
# is identical and only the kg column moves; with unequal n even the t column
# shifts, because df changed.
# ----------------------------------------------------------------------
crit <- sapply(stats, function(z) qt(0.975, z$df))
# unname() on the way in: crit is a named vector, so without it every value
# arrives carrying its own name and sapply hands back "A.A" and "B.B".
span <- sapply(names(stats), function(k) unname(2 * crit[k] * stats[[k]]$se))

cat("\n", sprintf("%8s %6s %10s %14s %14s", "sample", "n", "t at 95%",
                  "in kg, from", "to"), "\n", sep = "")
for (k in names(stats))
{
  cat(sprintf("%8s %6d %10.3f %14.2f %14.2f\n", k, stats[[k]]$n, crit[k],
              mu - crit[k] * stats[[k]]$se, mu + crit[k] * stats[[k]]$se))
}
cat(sprintf("\nWidths: %.1f kg for A, %.1f kg for B.\n", span["A"], span["B"]))

if (n_a == n_b)
{
  cat("Same n, so the t column is one number twice -- the curve did not\n")
  cat("change.  Only what it is worth changed.\n")
} else {
  cat("Different n here, so the t column moves too: that part is df doing it,\n")
  cat("not the weights.  The kg column moves for both reasons at once.\n")
}

# How ordinary were these two samples?  An honest footnote to a chosen seed:
# an s this small or this large is not a freak event at n = 5.  This is the
# same fact question 4c asks you to simulate.
tries <- 20000
for (k in names(stats))
{
  sims <- replicate(tries, sd(rnorm(stats[[k]]$n, mu, sigma)))
  cat(sprintf("About %2.0f%% of samples of %d give an s at least as far from %g as %s's.\n",
              100 * mean(abs(sims - sigma) >= abs(stats[[k]]$s - sigma)),
              stats[[k]]$n, sigma, k))
}

# ----------------------------------------------------------------------
# Three panels.  The top two are the same picture twice, once per researcher,
# on a shared kilogram axis -- so the curves can be compared, and so the t
# ticks on top can be seen sliding in and out while their LABELS stay put.
# The bottom panel lays them over each other.
#
# The y axis is shared as well.  Both curves enclose an area of one, so the
# narrow one has to be tall.  That is not B being more confident by decree;
# it is the same total spread over fewer kilograms.
# ----------------------------------------------------------------------
se_max <- max(stats$A$se, stats$B$se)
kg_grid <- seq(mu - 4.2 * se_max, mu + 4.2 * se_max, length.out = 700)
kg_limits <- range(kg_grid)

density_of <- function(k) dt((kg_grid - mu) / stats[[k]]$se, stats[[k]]$df) /
                          stats[[k]]$se

y_top <- max(sapply(names(stats), function(k) max(density_of(k)))) * 1.08
curve_col <- c(A = "steelblue", B = "darkorange")
t_at <- seq(-4, 4, by = 2)

layout(matrix(c(1, 2, 3, 3), nrow = 2, byrow = TRUE))

# Room above for the t ticks, the t axis title, then the panel title.
par(mar = c(4, 4, 5.4, 1.2), mgp = c(2.3, 0.7, 0))

for (k in names(stats))
{
  plot(kg_grid, density_of(k), type = "n", bty = "n", xaxt = "n",
       xlab = "Mean of the Sample (kg)", ylab = "Density",
       xlim = kg_limits, ylim = c(0, y_top), main = "")

  # The grey verticals ARE the ruler: evenly spaced in t, and therefore not
  # evenly spaced between the two panels.  Nothing happens to the curve at any
  # of them, which is what makes them safe to draw.
  abline(v = mu + t_at * stats[[k]]$se, col = "grey90", lwd = 1)

  axis(1, at = pretty(kg_limits, 6))
  axis(3, at = mu + t_at * stats[[k]]$se, labels = t_at)
  mtext("t axis: standard errors from mu", side = 3, line = 1.8, cex = 0.8)

  lines(kg_grid, density_of(k), lwd = 2.6, col = curve_col[k])
  abline(v = mu, col = "red", lwd = 1.5, lty = 2)

  mtext(bquote(bold("Researcher" ~ .(k)) ~ ":  n =" ~ .(stats[[k]]$n) * ", s =" ~
               .(round(stats[[k]]$s, 1)) ~ "kg,  one t step =" ~
               .(round(stats[[k]]$se, 2)) ~ "kg"),
        side = 3, line = 3.5, cex = 0.92)
}

# ----------------------------------------------------------------------
# Both curves, one kilogram axis.  There is deliberately no t axis on this
# panel: there is no single t axis to draw, because the two samples do not
# agree on what a t step costs.  That absence is the point of the panel.
# ----------------------------------------------------------------------
par(mar = c(4.2, 4, 3.4, 1.2))

plot(kg_grid, density_of("A"), type = "n", bty = "n",
     xlab = "Mean of the Sample (kg)", ylab = "Density",
     xlim = kg_limits, ylim = c(0, y_top), main = "")

mtext(bquote(bold("One Colony, Two Rulers")), side = 3, line = 1.7,
      cex = 1.05, adj = 0)
# The subtitle has to stop claiming one curve as soon as n differs, because
# then it honestly is two.
mtext(paste(if (n_a == n_b) "same curve on the t axis, different kilograms underneath it."
            else "different n, so two curves AND two sets of kilograms.",
            " Bars span the middle 95%"),
      side = 3, line = 0.5, cex = 0.85, adj = 0)

for (k in names(stats)) {lines(kg_grid, density_of(k), lwd = 2.6, col = curve_col[k])}
abline(v = mu, col = "red", lwd = 1.5, lty = 2)

if (show_span)
{
  heights <- c(A = y_top * 0.60, B = y_top * 0.72)
  for (k in names(stats))
  {
    lo <- mu - crit[k] * stats[[k]]$se
    hi <- mu + crit[k] * stats[[k]]$se
    arrows(lo, heights[k], hi, heights[k], code = 3, angle = 90, length = 0.05,
           col = curve_col[k], lwd = 2)
    # Just the width, parked at the right-hand tip.  Spelling out "middle 95%"
    # on each bar runs the longer label off the panel, and the subtitle has
    # already said what the bars are.
    text(hi, heights[k], labels = sprintf(" %.1f kg", span[k]),
         adj = c(0, -0.4), cex = 0.85, col = curve_col[k])
  }
}

legend("topleft",
       legend = sapply(names(stats), function(k)
         sprintf("%s:  s = %.1f kg, n = %d", k, stats[[k]]$s, stats[[k]]$n)),
       col = curve_col[names(stats)], lwd = 2.6, bty = "n", cex = 0.9)

layout(1)

cat("\nTop panels: the identical shape drawn twice.  Read the numbers on top\n")
cat("and they are the same numbers in the same order; read the numbers on the\n")
cat("bottom and they are not.  The data moved the ruler, not the curve.\n")
cat("\nBottom panel: what that costs.  Two honest reports about one colony,\n")
cat("differing by", sprintf("%.1f", abs(span["A"] - span["B"])), "kg in width, because one sample happened to\n")
cat("catch a more varied five than the other.\n")
