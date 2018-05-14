library(dplyr)

select(mtcars, cyl, mpg) %>%
  group_by(cyl) %>%
  arrange(cyl, mpg) %>%
  mutate(rank = row_number()) %>%
  top_n(-3)
