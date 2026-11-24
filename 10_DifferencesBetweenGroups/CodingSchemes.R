# Same model, two codings.
#
# The species model fitted twice: once with R's default dummy (treatment)
# coding, once with Helmert coding.  The coefficients change, because each
# coding asks different questions of the group means.  The model does not:
# the fitted group means, the residuals, R-squared and the F-test are the
# same.  Compare the two summaries side by side.

penguins <- read.csv("data/penguins.csv")

# Keep the penguins with both body mass and sex recorded (333 of 344): the
# same penguins as in every other example in this section.
penguins <- penguins[!is.na(penguins$body_mass_g) & !is.na(penguins$sex), ]
penguins$species <- factor(penguins$species)

# ----------------------------------------------------------------------
# The codes each penguin gets.
# ----------------------------------------------------------------------
contr.treatment(levels(penguins$species))
contr.helmert(levels(penguins$species))

# ----------------------------------------------------------------------
# The two fits.  The contrasts argument shows up in the Call line, so each
# summary says which coding it used.  For another coding, replace
# "contr.helmert" with "contr.sum", or with contr.treatment(3) - 1/3
# (simple coding, no quotes).
# ----------------------------------------------------------------------
fit_dummy <- lm(body_mass_g ~ species, data = penguins)
fit_other <- lm(body_mass_g ~ species, data = penguins, contrasts = list(species = "contr.helmert"))

summary(fit_dummy)
summary(fit_other)

# ----------------------------------------------------------------------
# Same model: the same fitted value (group mean) for every penguin.
# ----------------------------------------------------------------------
all.equal(fitted(fit_dummy), fitted(fit_other))
