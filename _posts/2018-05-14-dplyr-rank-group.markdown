---
layout: post
title:  "Add rank within group with dplyr"
date:   2018-05-14 8:00:00 -0800
categories: R dplyr regex
---

Add a new column `rank`, which is the rank according to `mpg` for each of the cars in each `cyl` group.
Using [row_number](https://dplyr.tidyverse.org/reference/ranking.html) within each group.

{% highlight R %}
library(dplyr)

select(mtcars, cyl, mpg) %>%
  group_by(cyl) %>%
  arrange(cyl, mpg) %>%
  mutate(rank = row_number()) %>%
  top_n(-3)
{% endhighlight %}

Results in

{% highlight text %}
# A tibble: 9 x 3
# Groups:   cyl [3]
    cyl   mpg  rank
  <dbl> <dbl> <int>
1     4  21.4     1
2     4  21.5     2
3     4  22.8     3
4     6  17.8     1
5     6  18.1     2
6     6  19.2     3
7     8  10.4     1
8     8  10.4     2
9     8  13.3     3
{% endhighlight %}
