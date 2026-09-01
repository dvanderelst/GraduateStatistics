# Simulates 1 series of n throws of a coin

p_head <- 0.65
throws <- 10

series_of_throws <- sample.int(2, size=throws, prob=c(1-p_head, p_head), replace=TRUE)
series_of_throws <- series_of_throws - 1 #To get min() =
number_of_heads <- sum(run)
number_of_heads
