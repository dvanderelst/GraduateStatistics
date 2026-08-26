# ---------------------------------------------------------------
# TEST: using a build in dataset for something more pleasing
# library(help = "datasets")
# ---------------------------------------------------------------

data(trees)
height <- trees$Height
girth <- trees$Girth

pdf("output/my_nice_plot.pdf", width = 7, height = 5)
plot(height, girth, main = "what a nice plot")
dev.off()                                    