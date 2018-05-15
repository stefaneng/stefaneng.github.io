library(jsonlite)

jsonString <- '{"score": 10, "info": { "name": "Stefan", "website": "stefanengineering.com"}}
{"score": 12, "info": { "name": "Lars"}}'

# If reading from a file, use con <- file(filename)
con <- textConnection(jsonString)
(res <- stream_in(con))
# Nested objects are stored as data frames
sapply(res, class)

# Flatten the nested data frames
# Use the jsonlite flatten rather than purrr flatten
(flatRes <- jsonlite::flatten(res))
sapply(flatRes, class)
