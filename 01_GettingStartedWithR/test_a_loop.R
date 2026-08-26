# ---------------------------------------------------------------
# TEST: Looping and plotting
# ---------------------------------------------------------------

some_vector <- c()
for (i in 0:1000)
{
  rnd <- rnorm(1)
  some_vector <- c(some_vector, rnd)
}

some_vector[1:10]
hist(some_vector)

# Note: you can interact with the variables in the console.