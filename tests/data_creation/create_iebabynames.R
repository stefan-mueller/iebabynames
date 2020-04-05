library(readtext)
library(tidyverse)

dat <- readtext("/Users/stefan/Desktop/names_ireland/*")

iebabynames <- dat %>%
    mutate(sex = ifelse(str_detect(doc_id, "Boys"), "Male",
                        ifelse(str_detect(doc_id, "Girls"), "Female", NA))) %>%
    mutate(year = str_replace_all(doc_id, "Top Girls Names ", "")) %>%
    mutate(year = str_replace_all(year, "Top Boys Names ", "")) %>%
    mutate(year = str_replace_all(year, ". Source CSO Ireland.csv.*", "")) %>%
    mutate(year = as.numeric(year),
           Rank = as.numeric(Rank)) %>%
    rename(name = text,
           rank = Rank, n = `Number.of.Births`) %>%
    dplyr::select(year, sex, name, n, rank) %>%
    arrange(sex, -year, rank) %>%
    group_by(year) %>%
    mutate(prop = n / sum(n)) %>%
    ungroup()


usethis::use_data(iebabynames, overwrite = TRUE)
