# The t-test is a linear model.
#
# Adelie vs Chinstrap body mass, tested twice: with t.test(), and with a
# linear model with species (two levels) as its only predictor.  Compare:
#
#   - the t-test's difference in means and the lm's speciesChinstrap estimate
#   - the two t values, degrees of freedom, and p-values
#   - the F-test on the last line of the lm summary: with one slope, F = t^2
#
# The match needs var.equal = TRUE.  The linear model has one sigma for all
# penguins; the default t.test() (Welch) lets each species have its own.

penguins <- read.csv("data/penguins.csv")

# Keep the penguins with both body mass and sex recorded (333 of 344): the
# same penguins as in every other example in this section.
penguins <- penguins[!is.na(penguins$body_mass_g) & !is.na(penguins$sex), ]

# Two species only.
two <- penguins[penguins$species %in% c("Adelie", "Chinstrap"), ]
two$species <- factor(two$species)

adelie <- two$body_mass_g[two$species == "Adelie"]
chinstrap <- two$body_mass_g[two$species == "Chinstrap"]

# ----------------------------------------------------------------------
# The t-test: Chinstrap minus Adelie, as in TTest.R.
# ----------------------------------------------------------------------
t.test(chinstrap, adelie, var.equal = TRUE)

# ----------------------------------------------------------------------
# The linear model: Adelie is the reference, so the slope is Chinstrap
# minus Adelie.
# ----------------------------------------------------------------------
fit <- lm(body_mass_g ~ species, data = two)
summary(fit)
