---
layout: post
title:  "Rename column names with dplyr"
date:   2018-05-14 8:00:00 -0800
categories: R dplyr regex
---

Rename iris columns from `Sepal.Length` to `Length of Sepal` using the [setNames function](https://www.rdocumentation.org/packages/stats/versions/3.5.0/topics/setNames) and [gsub](https://www.rdocumentation.org/packages/base/versions/3.5.0/topics/grep).

{% highlight R %}
library(datasets)
library(dplyr)
data(iris)

iris %>%
  setNames(gsub("([a-zA-Z]+)\\.(Length|Width)", "\\2 of \\1", names(.))) %>%
  head
{% endhighlight %}

Results in

{% highlight text %}
Length of Sepal Width of Sepal Length of Petal Width of Petal Species
1             5.1            3.5             1.4            0.2  setosa
2             4.9            3.0             1.4            0.2  setosa
3             4.7            3.2             1.3            0.2  setosa
4             4.6            3.1             1.5            0.2  setosa
5             5.0            3.6             1.4            0.2  setosa
6             5.4            3.9             1.7            0.4  setosa
{% endhighlight %}
