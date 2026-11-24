# Two factors: species and sex.
#
# Two questions, two models:
#
#   additive:     body_mass ~ species + sex
#                 males are heavier by the same amount in every species
#   interaction:  body_mass ~ species * sex
#                 each species has its own male-female gap
#
# Whether the gaps really differ is a comparison of the two models: the
# F-test for nested models from the significance-testing section.

penguins <- read.csv("data/penguins.csv")

# Keep the penguins with both body mass and sex recorded (333 of 344): the
# same penguins as in every other example in this section.
penguins <- penguins[!is.na(penguins$body_mass_g) & !is.na(penguins$sex), ]
penguins$species <- factor(penguins$species)
penguins$sex <- factor(penguins$sex)    # female is the reference: first in the alphabet

# ----------------------------------------------------------------------
# The data: the mean of each species x sex cell, and the male-female gap
# in each species.
# ----------------------------------------------------------------------
cell_means <- tapply(penguins$body_mass_g, list(penguins$species, penguins$sex), mean)
round(cell_means)
round(cell_means[, "male"] - cell_means[, "female"])

# ----------------------------------------------------------------------
# Model 1: additive.  One sexmale coefficient: the same gap everywhere.
# ----------------------------------------------------------------------
fit_add <- lm(body_mass_g ~ species + sex, data = penguins)
summary(fit_add)

# ----------------------------------------------------------------------
# Model 2: with interaction.  species * sex is short for
# species + sex + species:sex.
# ----------------------------------------------------------------------
fit_int <- lm(body_mass_g ~ species * sex, data = penguins)
summary(fit_int)

# Reading the coefficients: sexmale is the gap in the reference species
# (Adelie) only.  Each interaction term is how much another species' gap
# differs from it.
b <- coef(fit_int)
c(Adelie = b[["sexmale"]], Chinstrap = b[["sexmale"]] + b[["speciesChinstrap:sexmale"]], Gentoo = b[["sexmale"]] + b[["speciesGentoo:sexmale"]])

# ----------------------------------------------------------------------
# Do the gaps differ between species?  Compare the two models.
# ----------------------------------------------------------------------
anova(fit_add, fit_int)
