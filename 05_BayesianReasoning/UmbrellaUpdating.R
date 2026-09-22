# Rainy or sunny: updating a belief one passer-by at a time.
#
# The slides did a single update: one person with an umbrella moved p(rainy)
# from 0.30 to 0.44.  Nothing stops us from doing that again.  The belief we
# end up with after one passer-by is the belief we start with for the next:
# yesterday's posterior is today's prior.

# What we see, in order.  1 = a person with an umbrella, 0 = a person without.
# Change these and run again.
observations <- c(1, 0, 0, 1, 1, 0, 0, 1, 1,1,1,1,1,1,1,1)

# To let the world decide instead, suppose it is raining and generate them:
# observations <- rbinom(8, size = 1, prob = 0.9)

prior_rainy <- 0.3     # p(theta = rainy), before we have seen anybody

# The model: how likely is an umbrella under each state of the weather?  It
# also assumes that the weather does not change while we watch, and that one
# person's umbrella tells us nothing about the next person's once the weather
# is known.
p_umbrella_rainy <- 0.9
p_umbrella_sunny <- 0.5

# ---------------------------------------------------------------- the updating

# belief[1] is the prior; belief[i + 1] is p(rainy) after i passers-by.
belief <- numeric(length(observations) + 1)
belief[1] <- prior_rainy

for (i in seq_along(observations))
{

  # p(D | theta, M) for this one observation.  Not seeing an umbrella is data
  # too: it is just the other outcome of the same model.
  if (observations[i] == 1)
  {
    likelihood_rainy <- p_umbrella_rainy
    likelihood_sunny <- p_umbrella_sunny
  } else
  {
    likelihood_rainy <- 1 - p_umbrella_rainy
    likelihood_sunny <- 1 - p_umbrella_sunny
  }

  # Bayes' theorem, with the current belief in the role of the prior.
  prior <- belief[i]
  p_data <- likelihood_rainy * prior + likelihood_sunny * (1 - prior)
  belief[i + 1] <- likelihood_rainy * prior / p_data

}

# ---------------------------------------------------------------- the plot

steps <- 0:length(observations)

# Same letters as on the slides: u for an umbrella, x for none.
letters_seen <- ifelse(observations == 1, "u", "x")
colours <- c("black", ifelse(observations == 1, "blue", "orange"))

par(mar = c(5, 4, 5, 2))

plot(steps, belief, type = "l", col = "grey60", ylim = c(0, 1),
     xaxt = "n", xlab = "passers-by seen so far", ylab = "p(rainy | data so far)",
     main = "Updating the belief that it is raining")
axis(1, at = steps)

# Above this line rain is the better bet, below it sun.
abline(h = 0.5, lty = 2, col = "grey60")

points(steps, belief, pch = 19, cex = 1.3, col = colours)
text(steps[-1], belief[-1], labels = letters_seen, pos = 3, col = colours[-1])
text(0, belief[1], labels = "prior", pos = 3)

legend("topleft", legend = c("u: umbrella", "x: no umbrella"),
       col = c("blue", "orange"), pch = 19, bty = "n")

# ---------------------------------------------------------------- the point

# An umbrella nudges the belief up, because umbrellas are somewhat more common
# in the rain (0.9 against 0.5).  A person WITHOUT one pulls it down much
# harder, because going without is five times as common in the sun (0.5
# against 0.1).  How far an observation moves us depends on how specific it is
# to one state of the world.
cat("seen    p(rainy)\n")
cat("prior  ", format(round(belief[1], 3), nsmall = 3), "\n")
for (i in seq_along(observations))
{
  cat(letters_seen[i], "     ", format(round(belief[i + 1], 3), nsmall = 3), "\n")
}

# The order in which the people walk by does not matter.  Treating all of them
# as one data set gives the same answer as updating person by person.
n_u <- sum(observations == 1)
n_x <- sum(observations == 0)
all_rainy <- p_umbrella_rainy^n_u * (1 - p_umbrella_rainy)^n_x * prior_rainy
all_sunny <- p_umbrella_sunny^n_u * (1 - p_umbrella_sunny)^n_x * (1 - prior_rainy)
cat("\nall at once:", round(all_rainy / (all_rainy + all_sunny), 3), "\n")
