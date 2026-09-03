# Simulates coin tosses that violate the assumptions of the bionomial distribution.

p_head <- 0.65
throws <- 10
repeats <- 20000

# The binomial is not just "a bell-ish shape for counts".  It is the shortcut
# for one particular process: every throw has the SAME p(head), and no throw
# influences any other.  Each knob below breaks one of those assumptions.
#
# Set one at a time.  With all three at 0 this is an ordinary coin and the
# binomial fits.  Each knob is built so that the AVERAGE number of heads stays
# at throws * p_head, so whatever changes in the plot is the broken assumption
# showing itself -- not simply a different coin.

stickiness <- 0      # 0-1: a head makes the next throw more likely to be a head
wear <- 0              # 0-1: p(head) slides down across the ten throws
coin_variation <- 0    # 0-1: each repeat is played with a slightly different coin

plot_binomial <- 1

results <- rep(NA, repeats)
for (i in 1: repeats)
{

  # The coin used for this repeat.  With coin_variation = 0 it is always the
  # same coin, which is what the binomial assumes.
  p_coin <- p_head + runif(1, -coin_variation, coin_variation)

  previous <- NA
  number_of_heads <- 0

  for (j in 1:throws)
  {

    # Wear: p(head) starts high and finishes low, centred so that its average
    # across the ten throws is still p_coin.
    p_now <- p_coin + wear/2 - wear * (j - 1)/(throws - 1)

    # Stickiness: the previous throw pulls this one towards itself.  The two
    # adjustments are chosen so that heads still come up a fraction p_coin of
    # the time in the long run.
    if (!is.na(previous))
    {
      if (previous == 1) {p_now <- p_now + stickiness * (1 - p_now)} else {p_now <- p_now * (1 - stickiness)}
    }

    p_now <- min(max(p_now, 0), 1)

    throw <- sample.int(2, size=1, prob=c(1-p_now, p_now))
    throw <- throw - 1

    number_of_heads <- number_of_heads + throw
    previous <- throw

  }

  results[i] <- number_of_heads

}

possible <- 0:throws
breaks <- seq(-0.5, throws + 0.5, by = 1)

h <- hist(results, breaks = breaks, plot = FALSE)
expected <- dbinom(possible, throws, p_head)

title <- paste("stickiness =", stickiness, "  wear =", wear,
               "  coin_variation =", coin_variation)

hist(results, breaks = breaks, freq = FALSE, main = title,
     xlab = "number of heads", ylim = c(0, max(h$density, expected)))

if (plot_binomial)
{
  points(possible, expected, col = "red", pch = 19)
  legend("topleft", legend = c("simulation", "binomial"),
         col = c("black", "red"), pch = c(15, 19), bty = "n")
}

# The average is the same whichever knob is turned.  It is the SPREAD that
# gives the broken assumption away.
cat("simulation:  mean", round(mean(results), 2), " sd", round(sd(results), 2), "\n")
cat("binomial  :  mean", round(throws * p_head, 2),
    " sd", round(sqrt(throws * p_head * (1 - p_head)), 2), "\n")
