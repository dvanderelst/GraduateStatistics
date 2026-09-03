probabilities <- c(1, 1, 1, 1, 1, 1) / 6
throws <- 100000
rolls <- sample.int(6, size=throws, prob = probabilities, replace=TRUE)
title <- paste("Number of throws:", throws)
# A die has six faces, so fix the axis to those.  Tying it to what actually came
# up would shrink the plot if a face happened not to appear.
hist(rolls, breaks = seq(0.5, 6.5, by = 1), main=title)

