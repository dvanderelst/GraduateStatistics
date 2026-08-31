# Real data sets that are roughly normal -- and two that are not.
#
# The two that are not are the point of the script.  What makes something
# normal is many small independent influences ADDING UP.  When that fails, it
# fails in ways you can recognise and name.

show <- 1     # 1 = roughly normal
              # 2 = skewed      -- influences that multiply instead of adding
              # 3 = two humps   -- one influence dominates, and we did not measure it

body <- read.csv("data/body.csv")
temperature <- read.csv("data/normtemp.csv")

# ----------------------------------------------------------------------
# A histogram with the normal that has the same mean and sd drawn on top.
# If the data really are normal, the curve should sit on the bars.
# ----------------------------------------------------------------------
normal_hist <- function(values, title, xlabel)
{
  m <- mean(values)
  s <- sd(values)
  hist(values, breaks = 25, freq = FALSE, col = "grey85", border = "white",
       main = title, xlab = xlabel)
  grid <- seq(min(values), max(values), length.out = 200)
  lines(grid, dnorm(grid, m, s), col = "red", lwd = 2)
}

# How lopsided is it?  0 means symmetric.
skew <- function(values) {mean(((values - mean(values)) / sd(values))^3)}

describe <- function(label, values)
{
  cat(sprintf("%-32s n = %4d   skew %6.2f   Shapiro W %.3f\n",
      label, length(values), skew(values), shapiro.test(values)$statistic))
}

# ----------------------------------------------------------------------
if (show == 1)
{
  par(mfrow = c(2, 2))
  normal_hist(temperature$temp, "Human body temperature", "degrees F")
  normal_hist(body$WristDia,    "Wrist diameter",         "cm")
  normal_hist(body$Height,      "Height",                 "cm")
  normal_hist(iris$Sepal.Width, "Iris sepal width",       "cm")

  describe("body temperature", temperature$temp)
  describe("wrist diameter", body$WristDia)
  describe("height", body$Height)
  describe("iris sepal width", iris$Sepal.Width)
  cat("\nAll four are measurements -- each one the sum of many small influences.\n")
}

# ----------------------------------------------------------------------
if (show == 2)
{
  par(mfrow = c(1, 2))
  normal_hist(rivers, "River lengths", "miles")
  normal_hist(log(rivers), "The same lengths, logged", "log(miles)")

  describe("river lengths", rivers)
  describe("log(river lengths)", log(rivers))
  cat("\nInfluences that MULTIPLY give a long right tail, not a bell.\n")
  cat("Taking logs turns multiplying back into adding -- and the bell returns.\n")
}

# ----------------------------------------------------------------------
if (show == 3)
{
  # Old Faithful erupts in two ways: short eruptions are followed by a short
  # wait, long ones by a long wait.  Ignore which kind it was and the waiting
  # times have two humps.  Measure it, and each kind is normal again.
  short <- faithful$waiting[faithful$eruptions < 3]
  long <- faithful$waiting[faithful$eruptions >= 3]

  par(mfrow = c(1, 3))
  normal_hist(faithful$waiting, "All eruptions pooled", "minutes to next eruption")
  normal_hist(short, "After a SHORT eruption", "minutes to next eruption")
  normal_hist(long,  "After a LONG eruption",  "minutes to next eruption")

  describe("all eruptions pooled", faithful$waiting)
  describe("  after a short eruption", short)
  describe("  after a long eruption", long)
  cat("\nOne influence dominates -- which kind of eruption it was.\n")
  cat("Pooled, the bell is gone.  Split by the influence, it comes back.\n")
}
