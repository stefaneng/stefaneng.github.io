---
layout: post
title:  "corrplot fix title cut off type='upper'"
date:   2018-05-14 10:00:00 -0800
categories: R corrplot
---

[corrplot](https://cran.r-project.org/web/packages/corrplot/index.html)

When creating a correlation plot using `type="upper"`, the default settings will cut off the title in the plot.
Add an upper margin to fix `mar=c(0,0,2,0)`.

{% highlight R %}
library(datasets)
library(corrplot)
data(iris)

# Select the numeric columns
irisNumeric <- Filter(is.numeric, iris)
# Compute the correlation matrix
irisCor <- cor(irisNumeric)

corrplot(irisCor, method="color",
         type="upper",
         title="Correlation Plot: No Margin",
         tl.col="black", tl.srt=0,
         diag=FALSE)

{% endhighlight %}

![corrplot upper no margin]({{ "/assets/corrplot_title_cut_off/title_cut_off.png" }})

{% highlight R %}
corrplot(irisCor, method="color",
         type="upper",
         title="Correlation Plot: mar = c(0,0,2,0)",
         tl.col="black", tl.srt=0,
         # Margin added here
         mar=c(0,0,2,0),
         diag=FALSE)
{% endhighlight %}

![corrplot with margin for title]({{ "/assets/corrplot_title_cut_off/title_margin.png" }})
