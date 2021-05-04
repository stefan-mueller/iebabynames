
# iebabynames: Full baby name data for the Republic of Ireland

## Description

Full baby name data (1964–2020) for the Republic of Ireland, gathered
from the [Central Statistics
Office](https://www.cso.ie/en/interactivezone/visualisationtools/babynamesofireland/).

The package contains the dataset `iebabynames` with 72,585 observations
on six variables: `year`, `sex`, `name`, `n`, `rank`, and `prop`. Due to
confidentiality reasons, only names with 3 or more instances in the
relevant year are included.

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

head(iebabynames)
##   year    sex   name   n rank        prop
## 1 2020 Female  Grace 410    1 0.008414572
## 2 2020 Female  Fiadh 366    2 0.007511544
## 3 2020 Female  Emily 329    3 0.006752181
## 4 2020 Female Sophie 328    4 0.006731657
## 5 2020 Female    Ava 297    5 0.006095434
## 6 2020 Female Amelia 275    6 0.005643920
```

### Inspecting the development of selected names

``` r
# select names
iebabynames_subset <- iebabynames %>% 
    filter(name %in% c("Aisling", "Grace", "Mary",
                       "Emily", "Sophie", "Saoirse", "Paul",
                       "John", "Jack", "Patrick", "Noah",
                       "Conor"))


ggplot(data = iebabynames_subset,
       aes(x = year, y = n, colour = sex)) +
    scale_colour_manual(values = c("darkgreen", "grey50")) +
    geom_smooth(se = FALSE) +
    scale_x_continuous(breaks = c(seq(1965, 2020, 10))) +
    geom_point(alpha = 0.4) +
    facet_wrap(~name) +
    labs(x = NULL, y = "Frequency") +
    theme_bw() +
    theme(legend.title = element_blank(),
          legend.position = "bottom")
```

![](man/images/unnamed-chunk-4-1.png)<!-- -->

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
  labs(x = NULL, y = "Overall frequency (1964-2020)") +
  theme(axis.text.y = element_blank(),
        axis.ticks.y = element_blank(),
        legend.title = element_blank(),
        legend.position = "bottom") 
```

![](man/images/unnamed-chunk-5-1.png)<!-- -->

### Exploring different variants of names

``` r
iebabynames_variants1 <- iebabynames %>% 
  filter(name %in% c("Aoife", "Aoibhe", "Eva",
                     "Eve"))

ggplot(data = iebabynames_variants1,
       aes(x = year, y = n)) +
  geom_smooth(se = FALSE) +
  scale_x_continuous(breaks = c(seq(1970, 2020, 20))) +
  geom_point(alpha = 0.4) +
  facet_wrap(~name, nrow = 1) +
  labs(x = NULL, y = "Frequency") +
  theme_bw()
```

![](man/images/unnamed-chunk-6-1.png)<!-- -->

``` r
iebabynames_variants2 <- iebabynames %>% 
  filter(name %in% c("Eoin", "Eoghan", "Ewan",
                     "Evan", "Owen"))


ggplot(data = iebabynames_variants2,
       aes(x = year, y = n)) +
  geom_smooth(se = FALSE) +
  scale_x_continuous(breaks = c(seq(1970, 2020, 20))) +
  geom_point(alpha = 0.4) +
  facet_wrap(~name, nrow = 1) +
  labs(x = NULL, y = "Frequency") +
  theme_bw()
```

![](man/images/unnamed-chunk-7-1.png)<!-- -->

The [website of the Central Statistics
Office](https://www.cso.ie/en/interactivezone/visualisationtools/babynamesofireland/)
includes an interactive interface that allows you to plot the frequency
and rank of custom names.

## How to cite

Stefan Müller (2021). *iebabynames: Full baby name data for the Republic
of Ireland*. R package version 0.2.1. URL:
<http://github.com/stefan-mueller/iebabynames>.

For a BibTeX entry, use the output from
`citation(package = "iebabynames")`.

If you use the data, please also cite the CSO website:
<https://www.cso.ie/en/interactivezone/visualisationtools/babynamesofireland/>.

## Issues

Please file an issue (with a bug, wish list, etc.) [via
GitHub](https://github.com/stefan-mueller/iebabynames/issues).
