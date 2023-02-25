
# iebabynames: Full baby name data for Ireland

## Description

Full baby name data (1964–2022) for Ireland, gathered from the [Central
Statistics
Office](https://www.cso.ie/en/interactivezone/visualisationtools/babynamesofireland/).

The package contains the dataset `iebabynames` with 76794 observations
on six variables: `year`, `sex`, `name`, `n`, `rank`, and `prop`, and
`prop_sex`. Due to confidentiality reasons, only names with 3 or more
instances in the relevant year are included.

The package can be used to explore patterns of baby names in Ireland
over time. The dataset `iebabynames` is also very suitable for
filtering, summarising and plotting variables in workshops or lectures.

The structure of the package follows the
[**babynames**](https://cran.r-project.org/web/packages/babynames/index.html)
package by Hadley Wickham and the
[**ukbabynames**](https://mine-cetinkaya-rundel.github.io/ukbabynames/)
package by Mine Çetinkaya-Rundel, Thomas Leeper, and Nicholas
Goguen-Compagnoni.

## Installation

The package is hosted on GitHub and not available at CRAN. To install
the latest development version:

``` r
if (!require("devtools")) {
  install.packages("devtools")
}
devtools::install_github("stefan-mueller/iebabynames") 
```

## Demonstration

``` r
# load packages
library(iebabynames)
library(dplyr)
library(ggplot2)
library(scales)

head(iebabynames)
##   year    sex   name   n rank        prop   prop_sex
## 1 2022 Female  Emily 349    1 0.007029204 0.01469164
## 2 2022 Female  Grace 342    2 0.006888218 0.01439697
## 3 2022 Female  Fiadh 320    3 0.006445116 0.01347085
## 4 2022 Female Sophie 292    4 0.005881168 0.01229215
## 5 2022 Female   Lily 291    5 0.005861027 0.01225005
## 6 2022 Female  Éabha 271    6 0.005458207 0.01140812
```

### Get most popular names in 2022

``` r
dat_top_2022 <- iebabynames %>% 
  filter(year == "2022") %>% 
  group_by(sex) %>% 
  top_n(n = 10, wt = -rank) # get top 10

dat_top_2022
## # A tibble: 20 × 7
## # Groups:   sex [2]
##     year sex    name        n  rank    prop prop_sex
##    <dbl> <chr>  <chr>   <int> <dbl>   <dbl>    <dbl>
##  1  2022 Female Emily     349     1 0.00703   0.0147
##  2  2022 Female Grace     342     2 0.00689   0.0144
##  3  2022 Female Fiadh     320     3 0.00645   0.0135
##  4  2022 Female Sophie    292     4 0.00588   0.0123
##  5  2022 Female Lily      291     5 0.00586   0.0123
##  6  2022 Female Éabha     271     6 0.00546   0.0114
##  7  2022 Female Ava       269     7 0.00542   0.0113
##  8  2022 Female Mia       262     8 0.00528   0.0110
##  9  2022 Female Ellie     259     9 0.00522   0.0109
## 10  2022 Female Olivia    258    10 0.00520   0.0109
## 11  2022 Male   Jack      641     1 0.0129    0.0248
## 12  2022 Male   Noah      485     2 0.00977   0.0187
## 13  2022 Male   James     412     3 0.00830   0.0159
## 14  2022 Male   Rían      372     4 0.00749   0.0144
## 15  2022 Male   Charlie   348     5 0.00701   0.0134
## 16  2022 Male   Oisín     340     6 0.00685   0.0131
## 17  2022 Male   Tadhg     324     7 0.00653   0.0125
## 18  2022 Male   Liam      323     8 0.00651   0.0125
## 19  2022 Male   Cillian   316     9 0.00636   0.0122
## 20  2022 Male   Daniel    303    10 0.00610   0.0117
```

### Inspecting how the most popular names in 2022 have developed over time

``` r
# combine name and sex for correct subsetting
dat_top_2022 <- dat_top_2022 %>% 
  mutate(name_sex = paste(name, sex, sep = "_"))  

# extract all years for the most frequent names in 2022
dat_top_timeseries <- iebabynames %>% 
  mutate(name_sex = paste(name, sex, sep = "_")) %>% 
  filter(name_sex %in% dat_top_2022$name_sex)

ggplot(data = dat_top_timeseries,
       aes(x = year, y = prop, colour = sex)) +
  scale_colour_manual(values = c("darkgreen", "grey50")) +
  scale_x_continuous(breaks = c(seq(1962, 2022, 10))) +
  scale_y_continuous(labels = scales::percent) +
  geom_point(alpha = 0.4) +
  facet_wrap(~name) +
  labs(x = NULL, y = "Percentage of Babies") +
  theme_bw() +
  theme(legend.title = element_blank(),
        axis.text.x = element_text(angle = 90, hjust = 0.5),
        legend.position = "bottom")
```

![](man/images/unnamed-chunk-6-1.png)<!-- -->

### Inspecting the development of selected names

``` r
ggplot(data = filter(iebabynames, name %in% c("John", "Mary")),
       aes(x = year, y = prop)) +
  geom_smooth(se = FALSE) +
  scale_x_continuous(breaks = c(seq(1962, 2022, 5))) +
  scale_y_continuous(labels = scales::percent,
                     breaks = c(seq(0, 0.06, 0.01))) +
  geom_point(alpha = 0.4) +
  facet_wrap(~name) +
  labs(x = NULL, y = "Percentage of Babies") +
  theme_bw()
```

![](man/images/unnamed-chunk-7-1.png)<!-- -->

### Plotting the 10 most frequent male and female names across the entire period

``` r
iebabynames_top <- iebabynames %>% 
  group_by(sex, name) %>% 
  summarise(n_total = sum(n)) %>% 
  top_n(n = 10, wt = n_total)

ggplot(iebabynames_top, aes(x = reorder(name, n_total),
                            y = n_total,
                            fill = sex)) +
  geom_bar(stat = "identity") +
  geom_text(aes(label = name), nudge_y = -2000, 
            hjust = "right",
            colour = "white") +
  scale_fill_manual(values = c("darkgreen", "grey50")) +
  coord_flip() +
  theme_bw() +
  labs(x = NULL, y = "Frequency (1964-2022)") +
  theme(axis.text.y = element_blank(),
        axis.ticks.y = element_blank(),
        legend.title = element_blank(),
        legend.position = "bottom") 
```

![](man/images/unnamed-chunk-8-1.png)<!-- -->

### Exploring different variants of names

``` r
iebabynames_variants1 <- iebabynames %>% 
  filter(name %in% c("Aoife", "Aoibhe", "Eva",
                     "Eve"))

ggplot(data = iebabynames_variants1,
       aes(x = year, y = n)) +
  geom_smooth(se = FALSE) +
  scale_x_continuous(breaks = c(seq(1970, 2022, 20))) +
  geom_point(alpha = 0.4) +
  facet_wrap(~name, nrow = 1) +
  labs(x = NULL, y = "Frequency") +
  theme_bw()
```

![](man/images/unnamed-chunk-9-1.png)<!-- -->

The [website of the Central Statistics
Office](https://www.cso.ie/en/interactivezone/visualisationtools/babynamesofireland/)
includes an interactive interface that allows you to plot the frequency
and rank of custom names.

## How to cite

Stefan Müller (2023). *iebabynames: Ireland Baby Names, 1964-2023*. R
package version 0.2.3. URL:
<http://github.com/stefan-mueller/iebabynames>.

If you use the data, please also cite the CSO website:
<https://www.cso.ie/en/interactivezone/visualisationtools/babynamesofireland/>.

## Issues

Please file an issue (with a bug, wish list, etc.) [via
GitHub](https://github.com/stefan-mueller/iebabynames/issues).
