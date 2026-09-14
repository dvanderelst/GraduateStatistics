# The t distribution comes on a ruler nobody weighs penguins with.
#
# Its x axis is not kilograms -- it counts standard errors away from mu. That
# is what lets one curve serve every problem, and it is also why a student can
# read a number off it and have no idea what was just said about penguins.
#
# The fix is one line of arithmetic. The curve never changes; only the ruler
# under it does:
#
#     kg  =  mu  +  t * se           se = s / sqrt(n)
#
# This script draws the curve once and puts both rulers on it.


mu <- 50            # kg, the mean we are assuming
s <- 12             # kg, the sd this sample happened to give
n <- 5              # penguins in the sample

repeats <- 100000   # for the check at the bottom
sigma <- 12         # the colony's true sd, used only for that check

se <- s / sqrt(n)
df <- n - 1

# ----------------------------------------------------------------------
# The same positions said twice.
# ----------------------------------------------------------------------
cat("mu =", mu, "kg    s =", s, "kg    n =", n, "\n")
cat("se = s / sqrt(n) =", round(se, 3), "kg\n")
cat("One step along the t axis is a step of", round(se, 2), "kg.\n\n")

cat(sprintf("%12s %12s\n", "t axis", "kg axis"))
for (m in -3:3)
{
  cat(sprintf("%12.0f %12.2f%s\n", m, mu + m * se, if (m == 0) "   <- mu" else ""))
}

# ----------------------------------------------------------------------
# One curve, two rulers.
#
# Nothing is redrawn between the two axes -- axis(1) and axis(3) label the
# identical set of x positions. That is the point: the shape was never in
# kilograms or in t units, it was always just the shape.
#
# The regularly spaced grey guides ARE the ruler: each runs from a t reading at
# the bottom to the kg reading it corresponds to at the top. Nothing happens to
# the curve at any of them, which is exactly why they can be drawn -- they are
# positions, not features. Anything emphatic here (a cutoff, a shaded tail)
# would be read as a feature of the curve, and would also be borrowing from
# hypothesis testing, which is several sections away.
# ----------------------------------------------------------------------
par(mar = c(3.4, 3.6, 5.2, 1.2), mgp = c(2.3, 0.7, 0))

t_grid <- seq(-4.5, 4.5, length.out = 600)
dens <- dt(t_grid, df)

plot(t_grid, dens, type = "n", xaxt = "n", yaxt = "n", bty = "n",
     xlab = "", ylab = "Density", xlim = range(t_grid),
     ylim = c(0, max(dens) * 1.08), main = "")

abline(v = seq(-3, 3, by = 2), col = "grey93", lwd = 1)   # minor
abline(v = seq(-4, 4, by = 2), col = "grey85", lwd = 1)   # major, labelled

lines(t_grid, dens, lwd = 2.2)

t_at <- seq(-4, 4, by = 2)
axis(1, at = t_at, labels = t_at)
axis(3, at = t_at, labels = round(mu + t_at * se, 1))

mtext(bquote("t axis: standard errors from " * mu), side = 1, line = 1.9, cex = 0.9)
mtext(bquote("kg axis: " * mu + t %.% se), side = 3, line = 1.9, cex = 0.9)
mtext(bquote(bold("One Curve, Two Rulers") ~ "  (n =" ~ .(n) * ", df =" ~ .(df) * ")"),
      side = 3, line = 3.5, cex = 1.05, adj = 0)

# ----------------------------------------------------------------------
# Raising n shrinks the kg the ruler buys you, because se does.
# ----------------------------------------------------------------------
cat("\n", sprintf("%4s %8s %10s %14s %12s", "n", "df", "se (kg)",
                  "t = -2 is", "t = +2 is"), "\n", sep = "")
for (ni in c(5, 10, 30))
{
  sei <- s / sqrt(ni)
  cat(sprintf("%4d %8d %10.2f %13.1f %12.1f\n", ni, ni - 1, sei,
              mu - 2 * sei, mu + 2 * sei))
}
cat("\nSame curve, same t readings -- but each t unit is worth fewer kg, so the\n")
cat("whole picture shrinks towards mu when translated.\n")

# ----------------------------------------------------------------------
# Does the curve actually describe the standardised sample mean?
#
# Simulate the quantity the t is supposed to be about, and compare where its
# quantiles fall against what dt/qt claim -- in both currencies at once.
# ----------------------------------------------------------------------
t_sim <- rep(NA, repeats)
for (i in 1:repeats)
{
  x <- rnorm(n, mu, sigma)
  t_sim[i] <- (mean(x) - mu) / (sd(x) / sqrt(n))
}

probs <- c(0.10, 0.25, 0.50, 0.75, 0.90)
cat("\n", sprintf("%10s %14s %10s %12s", "quantile", "simulated t",
                  paste0("t(", df, ")"), "kg axis"), "\n", sep = "")
for (pr in probs)
{
  theo <- qt(pr, df)
  cat(sprintf("%9.0f%% %14.3f %10.3f %12.2f\n",
              pr * 100, quantile(t_sim, pr), theo, mu + theo * se))
}
cat("\nThe simulated column is the sample means themselves, standardised.\n")
cat("The kg column is the same row read off the other ruler.\n")
