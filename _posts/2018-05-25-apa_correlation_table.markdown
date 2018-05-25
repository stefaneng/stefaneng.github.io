---
layout: post
title:  "Create an APA style correlation table with R"
date:   2018-05-25 10:00:00 -0800
categories: dev
tags: [R,rcorr,knitr]
---

We will create the correlation matrix using `Hmisc::rcorr` to get the correlations along with the p-values and `knitr::kable` to print the table.
Using R-Studio, we can knit directly to word and format it the way we like.

{% highlight R %}
library(Hmisc) # For rcorr
library(knitr) # Pretty print table
{% endhighlight %}

The general format for each of the cell is to display the correlation, along with stars to indicate the significance level.
We want to apply a function (Pasting `*`) for each cell that is below a specific level.

### Helper Function
First we define a function that allows us to apply a function to each cell that satisfies a property.
There may already be a function for this, but I could not find it.

{% highlight R %}
#' Applies a function `f` to each cell of a data frame `mat` if the corresponding cell in `p` is TRUE
#'
#' @param mat A matrix or data frame
#' @param p A matrix with the same dimension as `mat`
#' @param f A function to apply
#' @return `mat` with `f` applied to each cell where `p` is TRUE.
#' @examples
#' x <- rbind(c(1,2,3), c(4,5,6), c(7,8,9))
#' apply_if(x, upper.tri(x), function(x) x + 5)
apply_if <- function(mat, p, f) {
  # Fill NA with FALSE
  p[is.na(p)] <- FALSE
  mat[p] <- f(mat[p])
  mat
}
{% endhighlight %}

### APA Correlation Matrix
Now we can define a function to return the matrix with the stars appended to significant correlations.
The row names are kept with the index appended.
The column names are replaced with the index.

{% highlight R %}
#' @param mat an rcorr object or a double matrix
#' @param corrtype is either pearson or spearman. Will be passed into Hmsic::rcorr if mat is not already an rcorr object
#' @return `mat` with stars appended for each level of significants (p < 0.05, p < 0.01, p < 0.001)
apaCorr <- function(mat, corrtype = "pearson") {
  matCorr <- mat
  if (class(matCorr) != "rcorr") {
    matCorr <- rcorr(mat, type = corrtype)
  }

  # Add one star for each p < 0.05, 0.01, 0.001
  stars <- apply_if(round(matCorr$r, 2), matCorr$P < 0.05, function(x) paste0(x, "*"))
  stars <- apply_if(stars, matCorr$P < 0.01, function(x) paste0(x, "*"))
  stars <- apply_if(stars, matCorr$P < 0.001, function(x) paste0(x, "*"))
  # Put - on diagonal and blank on upper diagonal
  stars[upper.tri(stars, diag = T)] <- "-"
  stars[upper.tri(stars, diag = F)] <- ""
  n <- length(stars[1,])
  colnames(stars) <- 1:n
  # Remove _ and convert to title case
  row.names(stars) <- tools::toTitleCase(sapply(row.names(stars), gsub, pattern="_", replacement = " "))
  # Add index number to row names
  row.names(stars) <- paste(paste0(1:n,"."), row.names(stars))
  stars
}
{% endhighlight %}

### Example
Now we can use `apaCorr` and `kable` to pretty print the correlation table in a format similar to APA.

{% highlight R %}
irisStars <- apaCorr(as.matrix(mtcars), corrtype = "pearson")

kable(irisStars, format = "markdown")
{% endhighlight %}


|         |1        |2        |3        |4        |5        |6        |7        |8        |9       |10   |11 |
|:--------|:--------|:--------|:--------|:--------|:--------|:--------|:--------|:--------|:-------|:----|:--|
|1. Mpg   |-        |         |         |         |         |         |         |         |        |     |   |
|2. Cyl   |-0.85*** |-        |         |         |         |         |         |         |        |     |   |
|3. Disp  |-0.85*** |0.9***   |-        |         |         |         |         |         |        |     |   |
|4. Hp    |-0.78*** |0.83***  |0.79***  |-        |         |         |         |         |        |     |   |
|5. Drat  |0.68***  |-0.7***  |-0.71*** |-0.45**  |-        |         |         |         |        |     |   |
|6. Wt    |-0.87*** |0.78***  |0.89***  |0.66***  |-0.71*** |-        |         |         |        |     |   |
|7. Qsec  |0.42*    |-0.59*** |-0.43*   |-0.71*** |0.09     |-0.17    |-        |         |        |     |   |
|8. Vs    |0.66***  |-0.81*** |-0.71*** |-0.72*** |0.44*    |-0.55*** |0.74***  |-        |        |     |   |
|9. Am    |0.6***   |-0.52**  |-0.59*** |-0.24    |0.71***  |-0.69*** |-0.23    |0.17     |-       |     |   |
|10. Gear |0.48**   |-0.49**  |-0.56*** |-0.13    |0.7***   |-0.58*** |-0.21    |0.21     |0.79*** |-    |   |
|11. Carb |-0.55**  |0.53**   |0.39*    |0.75***  |-0.09    |0.43*    |-0.66*** |-0.57*** |0.06    |0.27 |-  |
