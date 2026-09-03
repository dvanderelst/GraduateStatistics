# Simulates how many trees a bird has to inspect before finding a good nesting tree
# for a given p(good)

p_good <- 0.15
birds <- 20000

# At 200 birds the one-tree-wide bars are too sparse to compare against the
# shortcut -- most bars hold one or two birds and the shape is lost in noise.
# 200 is the right number for "look how much birds differ"; the comparison
# needs more.  20000 takes under a second and tracks the curve closely.
#
# Do NOT try to read the mode off these bars.  P(1 tree) = 0.0500 and
# P(2 trees) = 0.0475 differ by five percent, so the tallest bar lands on 1
# only about ten times in twelve even at 50000 birds.  That the mode is 1 is a
# fact about the formula, not something a sample can show -- it is the red
# dots that make the claim, and they are monotone by construction.

normalize_and_compare <- 0
plot_geometric <- 0

# There is no largest possible number of trees: an unlucky bird could keep
# looking forever.  So the plot shows a fixed window and reports what ran past
# it, rather than letting the single unluckiest bird set the axis.
max_shown <- 60

if (p_good <= 0) {stop("p_good must be above 0, or the bird never finds a tree")}

results <- rep(NA, birds)
for(b in 1:birds)
{
  found_nest <- FALSE
  trees_tried <- 0
  while (!found_nest)
  {
    found_nest <- runif(1) < p_good
    trees_tried <- trees_tried + 1
  }
  results[b]<-trees_tried
}

# One bar per number of trees.  The default breaks would put 1 and 2 in the
# same bar, which hides the whole point: the single most likely outcome is
# that the first tree tried is good.
breaks <- seq(0.5, max(results) + 0.5, by = 1)
possible <- 1:max_shown

# dgeom() counts the FAILURES before the first success, but trees_tried counts
# the trees inspected including the good one -- hence the minus one.
expected <- dgeom(possible - 1, p_good)

title <- paste("p(tree is suitable) =", p_good, "  birds =", birds)

hist(results, breaks = breaks, freq = !normalize_and_compare, main = title,
     xlab = "trees inspected, including the one chosen",
     xlim = c(0, max_shown + 1))

if (plot_geometric)
{
  points(possible, expected, col = "red", pch = 19)
  legend("topright", legend = c("simulation", "geometric"),
         col = c("black", "red"), pch = c(15, 19), bty = "n")
}

# The three summaries are the point of this example: they disagree, and none
# of them is "what to expect".
cat("birds followed    :", birds, "\n")
cat("settled in tree 1 :", sum(results == 1), "birds  (", 
    round(100 * mean(results == 1)), "% ; dgeom says", round(100 * p_good), "% )\n")
cat("median            :", median(results), "\n")
cat("mean              :", round(mean(results), 1), "  (1/p =", 1/p_good, ")\n")
cat("searched more than", 1/p_good, "trees:", sum(results > 1/p_good), "birds\n")
cat("longest search    :", max(results), "trees\n")
if (any(results > max_shown))
{
  cat("ran past the axis :", sum(results > max_shown), "birds\n")
}
