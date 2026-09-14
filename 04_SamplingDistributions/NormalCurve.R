# Draws a Normal density for a given mean and sd.
#
# The parameters are in the title, so a screenshot of the plot still says which
# Normal it is.


mu <- 5          # mean
sigma <- 3/sqrt(15)       # standard deviation

# How to name the two parameters in the title. The curve is identical either
# way -- this only changes what the plot calls them.
#   1 = mu and sigma, once the Greek has been introduced
#   0 = mean and sd, before it has
use_greek <- 0

# Significant digits for the title only. sigma is often an expression such as
# 3 / sqrt(15), and without this the title would carry all 15 of its digits.
digits <- 3

# Optional marks on the curve. All three are off by default -- set them and
# rerun.
#
#   show_mean   1 draws a red dashed line at the mean, 0 draws nothing
#   vlines      values to mark, e.g. c(4, 6); NULL for none
#   shade       region to fill under the curve, as c(from, to).
#               Use -Inf or Inf for an open end: c(-Inf, 4) shades the left
#               tail, c(6, Inf) the right. NULL for no shading.
show_mean <- 1
vlines <- c(6.15)
shade <- c(6.15, 1008)

shade_col <- "grey85"

# Four sds either side of the mean covers all but about 0.006% of the curve,
# so the tails are drawn down to nothing rather than chopped off.
x <- seq(mu - 4 * sigma, mu + 4 * sigma, length.out = 600)
y <- dnorm(x, mean = mu, sd = sigma)

par(mar = c(4, 4, 3.4, 1.2), mgp = c(2.3, 0.7, 0))

mu_lab <- signif(mu, digits)
sigma_lab <- signif(sigma, digits)

# Greek needs plotmath, and plotmath drops the bold a title normally gets, so
# bold() puts it back. A plain string is already bold, hence the two forms.
if (use_greek)
{
  title <- bquote(bold("Normal Distribution") ~~
                  list(mu == .(mu_lab), sigma == .(sigma_lab)))
} else {
  title <- paste0("Normal Distribution   mean = ", mu_lab, ", sd = ", sigma_lab)
}

plot(x, y, type = "n", bty = "n",
     xlab = "Value", ylab = "Density", main = title)

# Shading goes down first so the curve is drawn over its top edge rather than
# under it. The region is clamped to the plotted range, but the probability is
# computed from the values you asked for, so an infinite end still reports the
# whole tail.
if (!is.null(shade))
{
  lo <- max(shade[1], min(x))
  hi <- min(shade[2], max(x))
  if (hi > lo)
  {
    region <- c(lo, x[x > lo & x < hi], hi)
    polygon(c(region, rev(region)),
            c(dnorm(region, mu, sigma), rep(0, length(region))),
            col = shade_col, border = NA)
  }
  cat("Shaded from", shade[1], "to", shade[2], "  probability =",
      round(pnorm(shade[2], mu, sigma) - pnorm(shade[1], mu, sigma), 4), "\n")
}

lines(x, y, lwd = 2.2)

if (show_mean) {abline(v = mu, col = "red", lwd = 2, lty = 2)}
if (!is.null(vlines)) {abline(v = vlines, col = "grey30", lwd = 1.5, lty = 2)}

