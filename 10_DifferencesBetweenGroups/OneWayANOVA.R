# Do the three penguin species differ in mean body mass?
#
# Three groups, one factor: a one-way ANOVA.  We run it as a linear model,
#
#   mass_i = beta0 + beta1 * x1_i + beta2 * x2_i + epsilon_i
#
# where x1 = 1 for Chinstrap and x2 = 1 for Gentoo (dummy coding).  Adelie
# gets x1 = x2 = 0: it is the reference group.  R builds x1 and x2 for us,
# as long as it knows that species is a categorical variable (a factor).

penguins <- read.csv("data/penguins.csv")

# Keep the penguins with both body mass and sex recorded (333 of 344): the
# same penguins as in every other example in this section.
penguins <- penguins[!is.na(penguins$body_mass_g) & !is.na(penguins$sex), ]

# ----------------------------------------------------------------------
# Tell R that species is categorical.  The first level is the reference
# group; by default the levels are in alphabetical order.
# ----------------------------------------------------------------------
penguins$species <- factor(penguins$species)
levels(penguins$species)

# ----------------------------------------------------------------------
# Fit the model.
# ----------------------------------------------------------------------
fit <- lm(body_mass_g ~ species, data = penguins)

# The x1 and x2 that R made: one row per penguin.  Here, the first penguin
# of each species.
first_of_each <- match(levels(penguins$species), penguins$species)
data.frame(species = penguins$species[first_of_each], model.matrix(fit)[first_of_each, ], check.names = FALSE)

# ----------------------------------------------------------------------
# The coefficients are the group means, read from the reference group.
# ----------------------------------------------------------------------
coef(fit)

group_means <- tapply(penguins$body_mass_g, penguins$species, mean)
group_means
group_means - group_means["Adelie"]    # compare with coef(fit)

# ----------------------------------------------------------------------
# The test.  The last line of the summary is the omnibus F-test of the
# significance-testing section: could all slopes be 0?  Here "all slopes
# are 0" means "beta1 = beta2 = 0": all three species have the same mean.
# That is the null hypothesis of the one-way ANOVA.
# ----------------------------------------------------------------------
summary(fit)

# The same F-test, as a comparison with the intercept-only model.
fit0 <- lm(body_mass_g ~ 1, data = penguins)
anova(fit0, fit)
