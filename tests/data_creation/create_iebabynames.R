library(readtext)
library(stringr)
library(dplyr)
library(usethis)

dat <- readtext("/Users/smueller/Dropbox/datasets/babynames_ireland/*")

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
    group_by(year, sex) %>%
    mutate(prop_sex = n / sum(n)) %>%
    ungroup() %>%
    as.data.frame()


usethis::use_data(iebabynames, overwrite = TRUE)
