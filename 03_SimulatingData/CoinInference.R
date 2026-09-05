# One data set, four candidate coins.
#
# CoinAssumptions.R asked what a distribution looks like when the process
# behind it changes.  This script turns that around.  The throws have already
# happened; what changes from panel to panel is only the coin we SUPPOSE was
# used.  Each panel answers one question: if the coin really were this one,
# how likely was the result I am holding?

p_head <- 0.65         # the coin in the world
throws <- 10           # how many times it is thrown

# Four guesses about that coin.  None of them is the real one, on purpose:
# the data narrow the field down, they do not hand over the answer.
candidates <- c(0.2, 0.4, 0.6, 0.8)

# ---------------------------------------------------------------- the data

# ONE data set.  Everything below is four ways of looking at these same
# throws -- not four experiments.
tosses <- sample(c("H", "T"), size = throws, replace = TRUE,
                 prob = c(p_head, 1 - p_head))
heads <- sum(tosses == "H")

# ---------------------------------------------------------------- the plot

possible <- 0:throws

# Every panel gets the same y axis.  If each panel scaled itself, a bar could
# look tall under one candidate and short under another for no reason except
# the scaling, and the comparison would be an artefact of the picture.
ymax <- max(sapply(candidates, function(p) dbinom(possible, throws, p)))

par(mfrow = c(2, 2), oma = c(0, 0, 5, 0))

for (p in candidates)
{

  probs <- dbinom(possible, throws, p)

  # The height of the bar standing over the count we actually got.  This
  # number is the whole point of the script.  The picture is about the COUNT;
  # the throws are printed above only so that the count feels like something
  # that happened rather than a number out of thin air.
  #
  # signif() rather than round(): under a badly wrong coin the probability is
  # tiny but it is never nought, and a result that rounds to zero is not the
  # same thing as a result that cannot happen.
  height <- dbinom(heads, throws, p)

  colours <- rep("grey80", length(possible))
  colours[possible == heads] <- "red"

  barplot(probs, names.arg = possible, col = colours, border = NA,
          space = 0, ylim = c(0, ymax),
          xlab = "number of heads", ylab = "probability",
          main = paste0("if p = ", p, "\np(", heads, " heads) = ",
                        signif(height, 3)))

}

sequence_text <- paste(tosses, collapse = " ")
if (throws > 40) sequence_text <- paste(paste(tosses[1:40], collapse = " "), "...")

mtext(sequence_text, outer = TRUE, line = 2.2, cex = 1.1)
mtext(paste0("one data set:  ", throws, " throws,  ", heads, " heads"),
      outer = TRUE, line = 0.6, cex = 1)

# ---------------------------------------------------------------- the point

# Same result, four coins, four very different probabilities.  Some coins make
# what we saw an ordinary morning; others make it a small miracle.  Run the
# script again and the throws change, so the red bar moves -- one data set is
# only one data set.  Raise `throws` and watch how much harder it becomes for
# the wrong coins to explain what happened.
cat("throws:", sequence_text, "\n")
cat("heads :", heads, "of", throws, "\n\n")
for (p in candidates)
{
  cat("  if p =", format(p, nsmall = 2), "  p(", heads, "heads ) =",
      signif(dbinom(heads, throws, p), 3), "\n")
}
