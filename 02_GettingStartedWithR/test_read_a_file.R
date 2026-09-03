# ---------------------------------------------------------------
# TEST: reading a file
# ---------------------------------------------------------------

data <- read.csv('data/normtemp.csv')
is_male <- data$sex == 1
is_female <- data$sex == 2


males <- data[is_male, ]
females <- data[is_female, ]

plot(males$temp, males$rate, col='blue')
points(females$temp, females$rate, col='red')