library(datasets)
library(dplyr)
data(iris)

iris %>%
  setNames(gsub("([a-zA-Z]+)\\.(Length|Width)", "\\2 of \\1", names(.)))
