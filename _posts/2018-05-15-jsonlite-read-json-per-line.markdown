---
layout: post
title:  "Read a file with one valid JSON object per line with R and jsonlite"
date:   2018-05-15 8:00:00 -0800
categories: R jsonlite
---

We have a file with one valid JSON objects per line which we will load using [jsonlite](https://cran.r-project.org/web/packages/jsonlite/index.html)

{% highlight R %}
library(jsonlite)

jsonString <- '{"score": 10, "info": { "name": "Stefan", "website": "stefanengineering.com"}}
{"score": 12, "info": { "name": "Lars"}}'
# If reading from a file, use con <- file(filename)
con <- textConnection(jsonString)
(res <- stream_in(con))
#>
 Found 2 records...
 Imported 2 records. Simplifying...
#>   score info.name          info.website
#> 1    10    Stefan stefanengineering.com
#> 2    12      Lars                  <NA>
# Nested objects are stored as data frames
sapply(res, class)
#>        score         info
#>    "integer" "data.frame"
{% endhighlight %}

By default, the nested objects are stored as nested data frames.
The function `jsonlite::flatten` will flatten the resulting data frame.
Note that jsonlite import purrr which has its own version of flatten.

{% highlight R %}
# Flatten the nested data frames
# Use the jsonlite flatten rather than purrr flatten
(flatRes <- jsonlite::flatten(res))
#>   score info.name          info.website
#> 1    10    Stefan stefanengineering.com
#> 2    12      Lars                  <NA>
sapply(flatRes, class)
#>        score    info.name info.website
#>    "integer"  "character"  "character"
{% endhighlight %}
