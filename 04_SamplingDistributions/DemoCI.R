n<-10
samples <- rnorm(n, 50, 10)
results <- t.test(samples)

mean_x <- mean(samples)
sd_x <-sd(samples)

t_critical <- qt(0.975, df = n - 1) 

half_width <- t_critical * (sd_x/sqrt(n))

upper<-mean_x + half_width
lower<-mean_x - half_width
c(lower, upper)
t.test(samples)$conf.int 