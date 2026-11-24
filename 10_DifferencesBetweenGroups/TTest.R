# Do two penguin species differ in mean body mass?
#
# Two groups, one measurement: the job of the t-test.  We compare Adelie and
# Chinstrap penguins, look at both samples, then test whether the population
# means could be the same.

par(las = 1, bty = "o")    # horizontal axis numbers, full box around the plot

penguins <- read.csv("data/penguins.csv")

# Keep the penguins with both body mass and sex recorded (333 of 344): the
# same penguins as in every other example in this section.
penguins <- penguins[!is.na(penguins$body_mass_g) & !is.na(penguins$sex), ]

adelie <- penguins$body_mass_g[penguins$species == "Adelie"]
chinstrap <- penguins$body_mass_g[penguins$species == "Chinstrap"]

# ----------------------------------------------------------------------
# The two samples, on top of each other.
# ----------------------------------------------------------------------
grey <- adjustcolor("grey40", alpha.f = 0.4)
blue <- adjustcolor("blue", alpha.f = 0.35)
breaks <- seq(2500, 5000, by = 100)

hist(adelie, breaks = breaks, col = grey, border = "white", xlab = "Body mass (g)", main = "Adelie vs Chinstrap")
hist(chinstrap, breaks = breaks, col = blue, border = "white", add = TRUE)
legend("topright", legend = c("Adelie", "Chinstrap"), fill = c(grey, blue), border = NA, bty = "n")

# ----------------------------------------------------------------------
# The t-test.  var.equal = TRUE: both species share one spread, as in
# section 6 (and, later, as in the linear model).
# ----------------------------------------------------------------------
t.test(chinstrap, adelie, var.equal = TRUE)
