p_head <- 0.65
throws <- 10

run <- sample.int(2, size=throws, prob=c(1-p_head, p_head), replace=TRUE)
run <- run - 1
number_of_heads <- sum(run)
number_of_heads
