library(datasets)
library(corrplot)
data(iris)

# Select the numeric columns
irisNumeric <- Filter(is.numeric, iris)
# Compute the correlation matrix
irisCor <- cor(irisNumeric)

# No margin
corrplot(irisCor, method="color",
         type="upper",
         title="Correlation Plot: No Margin",
         tl.col="black", tl.srt=0, tl.cex = 1,
         # Spacing between feature labels and plot
         tl.offset = 1,
         diag=FALSE)

corrplot(irisCor, method="color",
         type="upper",
         title="Correlation Plot: mar = c(0,0,3,0)",
         tl.col="black", tl.srt=0, tl.cex = 1,
         # Spacing between feature labels and plot
         # Set margin here
         mar=c(0,0,3,0),
         diag=FALSE)
