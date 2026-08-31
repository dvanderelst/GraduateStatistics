

probabilities1 <- c(2, 1, 1, 1, 1, 1)
probabilities1 <- probabilities1 / sum(probabilities1)

probabilities2 <- c(1, 1, 1, 1, 1, 1)
probabilities2 <- probabilities2 / sum(probabilities2)

probabilities3 <- c(1, 1, 1, 1, 1, 1)
probabilities3 <- probabilities3 / sum(probabilities3)

throws <- 20000
final_result <- rep(NA, throws)


for(i in 1:throws)
{
  
  roll1 <- sample.int(6, size=1, prob=probabilities1)
  roll2 <- sample.int(6, size=1, prob=probabilities2)
  roll3 <- sample.int(6, size=1, prob=probabilities3)
  
  
  rolls <- c(roll1, roll2, roll3)
  
  # which.max() on a table gives a position in that table, not the face value,
  # so take the name (the face) and turn it back into a number.
  most_common <- as.numeric(names(which.max(table(rolls))))
  n_unique <- length(unique(rolls))
  n_matching <- (3 - n_unique) + 1
  
  if (n_unique < 3){final<-most_common * n_matching} else {final <- max(rolls)}
  
  final_result[i] <- final
  
}
# The lowest score the game can give is a pair of ones (2), the highest is three
# sixes (18).  Fixing the axis to that range keeps the plot steady from run to
# run, and leaves the scores the game simply cannot produce visible as gaps.
hist(final_result, breaks = seq(1.5, 18.5, by = 1))
