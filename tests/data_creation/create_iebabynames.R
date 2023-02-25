library(readtext)
library(stringr)
library(dplyr)
library(usethis)

dat <- readtext("/Users/smueller/Dropbox/datasets/babynames_ireland/*")

dat_22 <- readtext("/Users/smueller/Dropbox/datasets/babynames_2022/*")


iebabynames_22 <- dat_22 |>
    mutate(sex = ifelse(str_detect(text, "Boys"), "Male",
                        ifelse(str_detect(text, "Girls"), "Female", NA))) %>%
    rename(year = Year,
           n = VALUE,
           name = Names) |>
    filter(n != "") |> # remove names that appeared fewer than three times
    mutate(n = as.integer(n)) |>
    group_by(sex) |>
    arrange(sex, -n) |>
    group_by(year, sex) |>
    mutate(rank = base::rank(-n, ties.method = "min")) |>
    ungroup() |>
    mutate(prop = n / sum(n)) %>%
    group_by(year, sex) %>%
    mutate(prop_sex = n / sum(n)) %>%
    ungroup() %>%
    dplyr::select(year, sex, name, n, rank, prop, prop_sex) |>
    as.data.frame()


iebabynames_pre22 <- dat %>%
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

iebabynames <- bind_rows(iebabynames_22, iebabynames_pre22)

usethis::use_data(iebabynames, overwrite = TRUE)
