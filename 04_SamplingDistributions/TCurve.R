# Draws a t density for a sample of size n.
#
# The companion to NormalCurve.R, with the same switches. The one addition is
# that a t arrives on a ruler nobody measures anything with -- its axis counts
# standard errors from the centre. Give it a mu as well and it will put your
# own units on the bottom and keep the t axis on top, so the same curve can be
# read either way.


# The usual way in. Both of the numbers the curve needs follow from these, so
# they cannot drift apart: change n and the degrees of freedom and the width
# both follow.
n <- 7           # sample size
s <- 1.23            # sample sd

mu <- 5           # where the distribution sits in your units.
                  # NULL to stay on the bare t axis instead.

# Escape hatch. With n <- NULL the two above are ignored and these are used as
# they stand, for a df or a width that does not come from a sample mean.
#   df      degrees of freedom
#   sigma   what one t unit is worth in your units
df <- 14
sigma <- 3 / sqrt(15)

# How to name the parameters in the title.
#   1 = mu and sigma, once the Greek has been introduced
#   0 = mean and sd, before it has
use_greek <- 0

# Significant digits for the title only.
digits <- 3

# Optional marks on the curve. vlines and shade are read in whatever units the
# BOTTOM axis is in -- your units if you gave a mu, t units if you did not.
# That way they mean the same thing here as in NormalCurve.R.
#
#   show_mean   1 draws a red dashed line at the centre, 0 draws nothing
#   vlines      values to mark, e.g. c(4, 6); NULL for none
#   shade       region to fill, as c(from, to). Use -Inf or Inf for an open
#               end: c(-Inf, 4) shades the left tail. NULL for no shading.
show_mean <- 1
vlines <- c(6.15)
shade <- c(6.15, 1000)

shade_col <- "grey85"

# 1 = write the t value beside each vline and each finite shade edge, so a
#     mark you set in your own units can be read off the t axis too.
# 0 = leave them unlabelled. Ignored when there is no mu, since the marks are
#     already t values then.
label_t <- 1

# ----------------------------------------------------------------------
# One sample mean of n observations: n - 1 degrees of freedom, because one is
# spent locating the centre, and a width of s / sqrt(n). Deriving both from n
# is the point of taking n as the input -- set df and sigma by hand and a
# mismatched pair still draws a perfectly plausible, wrong curve.
# ----------------------------------------------------------------------
if (!is.null(n))
{
  df <- n - 1
  sigma <- s / sqrt(n)
}

cat("df =", df, "  sigma =", signif(sigma, 4),
    if (is.null(n)) "  (set by hand)" else paste0("  (from n = ", n, ", s = ", s, ")"),
    "\n")

# With no mu, the "original" units ARE t units, so the rest of the script does
# not need to know which case it is in.
in_original <- !is.null(mu)
if (!in_original)
{
  mu <- 0
  sigma <- 1
}

# Four sds of the curve either side of the centre. A t has heavier tails than
# a Normal, so this clips a little more than it would there -- at df = 4 about
# 1.2% is left outside, against 0.006% for a Normal.
x <- mu + sigma * seq(-4.5, 4.5, length.out = 600)

# The 1/sigma is the change of units: squeezing the axis by sigma has to
# stretch the density by the same factor, or the area stops being 1.
y <- dt((x - mu) / sigma, df) / sigma

# Every value the reader is being pointed at, in bottom-axis units. Finite
# shade edges count; an infinite one is not a position on the axis.
marks <- unique(c(vlines, shade[is.finite(shade)]))
marks <- marks[marks >= min(x) & marks <= max(x)]
label_marks <- label_t && in_original && length(marks) > 0

# Headroom above the curve only if something is going to be written up there.
ytop <- max(y) * if (label_marks) 1.14 else 1.04

mu_lab <- signif(mu, digits)
sigma_lab <- signif(sigma, digits)

if (use_greek)
{
  title <- if (in_original) {
    bquote(bold("t Distribution") ~~ list(df == .(df), mu == .(mu_lab),
                                          sigma == .(sigma_lab)))
  } else {
    bquote(bold("t Distribution") ~~ list(df == .(df)))
  }
} else {
  title <- if (in_original) {
    paste0("t Distribution   df = ", df, ", mean = ", mu_lab, ", sd = ", sigma_lab)
  } else {
    paste0("t Distribution   df = ", df)
  }
}

# Room above the panel only when there is a second axis to put there. With one
# there, three things stack above the curve -- t tick labels, the t axis title,
# then the plot title -- so the title is placed by hand with mtext further out.
# Left to plot(), main lands on the same lines as the axis and prints over it.
par(mar = c(4, 4, if (in_original) 5.2 else 3.0, 1.2), mgp = c(2.3, 0.7, 0))

plot(x, y, type = "n", bty = "n", xaxt = if (in_original) "s" else "n",
     xlab = if (in_original) "Value" else "", ylab = "Density", main = "",
     ylim = c(0, ytop))

mtext(title, side = 3, line = if (in_original) 3.5 else 1.0, cex = 1.05, font = 2)

if (!in_original)
{
  t_at <- seq(-4, 4, by = 2)
  axis(1, at = t_at, labels = t_at)
  mtext(if (use_greek) bquote("t axis: standard errors from " * mu)
        else "t axis: standard errors from the mean",
        side = 1, line = 1.9, cex = 0.9)
}

if (!is.null(shade))
{
  lo <- max(shade[1], min(x))
  hi <- min(shade[2], max(x))
  if (hi > lo)
  {
    region <- c(lo, x[x > lo & x < hi], hi)
    polygon(c(region, rev(region)),
            c(dt((region - mu) / sigma, df) / sigma, rep(0, length(region))),
            col = shade_col, border = NA)
  }
  cat("Shaded from", shade[1], "to", shade[2], "  probability =",
      round(pt((shade[2] - mu) / sigma, df) - pt((shade[1] - mu) / sigma, df), 4),
      "\n")
}

lines(x, y, lwd = 2.2)

if (show_mean) {abline(v = mu, col = "red", lwd = 2, lty = 2)}
if (!is.null(vlines)) {abline(v = vlines, col = "grey30", lwd = 1.5, lty = 2)}

if (label_marks)
{
  # Nudged away from the centre and anchored on the near edge, so the label
  # sits beside its line rather than having the line drawn through it.
  pad <- 0.015 * diff(range(x))
  outward <- ifelse(marks >= mu, 1, -1)
  for (k in seq_along(marks))
  {
    text(marks[k] + outward[k] * pad, ytop * 0.95,
         labels = paste0("t = ", round((marks[k] - mu) / sigma, 2)),
         adj = c(if (outward[k] > 0) 0 else 1, 0.5), cex = 0.8, col = "grey30")
  }

  cat("\n", sprintf("%12s %10s", "value", "t"), "\n", sep = "")
  for (v in sort(marks))
  {
    cat(sprintf("%12.4g %10.3f\n", v, (v - mu) / sigma))
  }
}

# ----------------------------------------------------------------------
# The second ruler. Same positions, relabelled -- nothing is redrawn.
# ----------------------------------------------------------------------
if (in_original)
{
  t_at <- seq(-4, 4, by = 2)
  axis(3, at = mu + t_at * sigma, labels = t_at)
  mtext(if (use_greek) bquote("t axis: standard errors from " * mu)
        else "t axis: standard errors from the mean",
        side = 3, line = 1.9, cex = 0.9)

  cat("One t unit is", signif(sigma, digits), "units on the bottom axis.\n")
}
