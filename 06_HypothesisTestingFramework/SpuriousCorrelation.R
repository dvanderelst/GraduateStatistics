# A "highly significant" correlation between two things that cannot be linked.
#
# Data from https://www.tylervigen.com/spurious-correlations: UFO sightings in
# Ohio and electricity generation in Yemen, one value per year, 1980 to 2021.
#
# Left panel:   what the test sees.  42 pairs of numbers, a strong
#               correlation, a tiny p value.
# Middle panel: what the test ignores.  Both series in the order of the years.
# Right panel:  how often this happens by chance.  Pairs of series that are
#               unrelated by construction, tested the same way.

walks <- 2000          # pairs of unrelated series to simulate

ufo <- c(9, 8, 7, 3, 10, 8, 8, 7, 10, 5, 5, 6, 10, 14, 26, 25, 23, 26, 59, 120,
         75, 90, 86, 111, 123, 83, 93, 111, 130, 127, 123, 151, 263, 348, 270,
         202, 151, 138, 83, 174, 172, 44)
electricity <- c(0.471, 0.54, 0.647, 0.721, 0.818, 0.855, 1.094, 1.183, 1.565,
                 1.579, 1.563, 1.693, 1.836, 1.928, 2.029, 2.227, 2.194, 2.404,
                 2.357, 2.571, 3.208, 3.424, 3.543, 3.85, 4.103, 4.482, 5.064,
                 5.66538, 6.15324, 6.33936, 7.2917, 5.83376, 6.65162, 7.99594,
                 7.19724, 5.92332, 4.51942, 3.81864, 3.30588, 3.41492, 3.23725,
                 3.52087)
years <- 1980:2021

# ---------------------------------------------------------------- the test

# The null hypothesis: the correlation is 0, and every year is an independent
# draw.  The second part is easy to overlook, and it is the part that fails.
result <- cor.test(ufo, electricity)
r <- result$estimate
p <- result$p.value

# ---------------------------------------------------------------- unrelated series

# A random walk: each year is last year plus a random step.  Like the real
# series, it changes slowly, so each year is close to the one before.  Two
# walks made with separate calls to rnorm() have nothing to do with each
# other: no link, no common cause.  We test them exactly as above.
years_n <- length(years)
p_walks <- replicate(walks, {
  walk_1 <- cumsum(rnorm(years_n))
  walk_2 <- cumsum(rnorm(years_n))
  cor.test(walk_1, walk_2)$p.value
})
share_significant <- mean(p_walks < 0.05)

# ---------------------------------------------------------------- the plot

# R shrinks the text when three panels share a row; the cex settings undo that
# so the labels survive being put on a slide.
par(mfrow = c(1, 3), oma = c(0, 0, 3, 0), mar = c(5, 5, 5, 1),
    cex.axis = 1.4, cex.lab = 1.6, cex.main = 1.8)

# Left: the scatter plot.  The years are gone; only the pairs remain.
plot(electricity, ufo, pch = 19, col = "grey30",
     xlab = "electricity generation in Yemen (billion kWh)",
     ylab = "UFO sightings in Ohio")
title(main = "what the test sees", line = 2.4)
abline(lm(ufo ~ electricity), col = "red", lwd = 2)
title(main = paste0("r = ", round(r, 2), ",  p = ", signif(p, 2)),
      line = 0.9, font.main = 1, cex.main = 1.3)

# Middle: both series against time.  scale() puts them on the same axis by
# turning each into standard deviations from its own mean.  Shuffling the
# years (keeping each year's pair together) would leave r and p unchanged:
# the test never uses this order.
plot(years, scale(ufo), type = "o", pch = 19, cex = 0.7, lwd = 2,
     col = "darkgreen", ylim = range(scale(ufo), scale(electricity)),
     xlab = "year", ylab = "standardised value")
title(main = "what the test ignores", line = 2.4)
title(main = "the order of the years", line = 0.9, font.main = 1,
      cex.main = 1.3)
lines(years, scale(electricity), type = "o", pch = 19, cex = 0.7, lwd = 2,
      col = "steelblue")
legend("topleft", legend = c("UFO sightings in Ohio", "electricity in Yemen"),
       col = c("darkgreen", "steelblue"), lwd = 2, pch = 19, bty = "n",
       cex = 1.3)

# Right: the p values of the unrelated pairs.  If the test's assumptions held,
# they would be spread evenly between 0 and 1, and 5% would land left of the
# dashed line.
hist(p_walks, breaks = seq(0, 1, by = 0.05), col = "grey70", border = "white",
     xlab = "p value", ylab = "number of pairs", main = "")
title(main = "unrelated random walks", line = 2.4)
abline(v = 0.05, lty = 2, col = "red", lwd = 2)
title(main = paste0(round(100 * share_significant), "% have p < 0.05"),
      line = 0.9, font.main = 1, cex.main = 1.3)

mtext("UFO sightings in Ohio vs. electricity generation in Yemen, 1980-2021",
      outer = TRUE, line = 0.8, cex = 1.2)

# ---------------------------------------------------------------- the point

# Nobody believes UFO sightings in Ohio and electricity in Yemen are linked:
# the prior for a link is essentially zero.  But the data are not surprising
# without one.  Both series rise over the same decades, and any two rising
# series correlate.  Both also happen to peak around 2013 and drop after it
# (in Yemen, the drop follows the start of the civil war).  The years are not
# independent draws: each one is close to the year before.  So the null model
# behind the p value was never a fair description of "no link".
#
# No common cause is needed.  The random walks share nothing, yet most pairs
# come out "significant", where the test promises 5%.  Slowly changing series
# hold far less information than their number of years suggests, and the test
# does not know that.  Yule pointed this out in 1926: "Why do we sometimes get
# nonsense-correlations between time-series?"
#
# The test compares the data with one alternative only: rho = 0, independent
# years.  It never asks what else could have produced them.
cat("correlation r                     :", round(r, 3), "\n")
cat("p value                           :", signif(p, 3), "\n")
cat("unrelated random walks, p < 0.05  :", round(share_significant, 2), "\n")
