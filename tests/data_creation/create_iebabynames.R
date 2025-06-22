library(readtext)
library(stringr)
library(dplyr)
library(usethis)

dat <- readtext("babynames_ireland/*")

dat_22 <- readtext("babynames_2022/*")

dat_23 <- readtext("babynames_2023/*") |>
    filter(Year == "2023") |>
    filter(!str_detect(`Statistic.Label`, "Rank")) # remove rank observations

dat_24 <- readtext("babynames_2024/*") |>
   filter(Year == "2024") |>
   filter(!str_detect(`Statistic.Label`, "Rank")) # remove rank observations


iebabynames_24 <- dat_24 |>
   mutate(sex = ifelse(str_detect(`Statistic.Label`, "Boys"), "Male",
                       ifelse(str_detect(`Statistic.Label`, "Girls"), "Female", NA))) %>%
   mutate(name = ifelse(is.na(`Boys.Names`), `Girls.Names`, `Boys.Names`)) |> 
   rename(year = Year,
          n = VALUE) |>
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



iebabynames_23 <- dat_23 |>
    mutate(sex = ifelse(str_detect(`Statistic.Label`, "Boys"), "Male",
                        ifelse(str_detect(`Statistic.Label`, "Girls"), "Female", NA))) %>%
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

iebabynames <- bind_rows(iebabynames_24, iebabynames_23, iebabynames_22, iebabynames_pre22)

usethis::use_data(iebabynames, overwrite = TRUE)
