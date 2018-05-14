library(dplyr)

select(mtcars, cyl, mpg) %>%
  group_by(cyl) %>%
  arrange(cyl, mpg) %>%
  mutate(rank = min_rank(mpg)) %>%
  top_n(-3)