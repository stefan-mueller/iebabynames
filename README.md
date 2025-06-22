
# iebabynames: Full baby name data for Ireland

## Description

Full baby name data (1964–2024) for Ireland, gathered from the [Central
Statistics
Office](https://www.cso.ie/en/interactivezone/visualisationtools/babynamesofireland/).

The package contains the dataset `iebabynames` with 81,060 observations
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
if (!require("remotes")) {
    install.packages("remotes")
}
remotes::install_github("stefan-mueller/iebabynames") 
```

## Demonstration

``` r
# load packages
library(iebabynames)
library(dplyr)
library(ggplot2)
library(scales)

# set ggplot2 theme
theme_set(theme_bw())

head(iebabynames)
##   year    sex   name   n rank        prop   prop_sex
## 1 2024 Female Sophie 294    1 0.006455863 0.01359726
## 2 2024 Female  Éabha 293    2 0.006433904 0.01355101
## 3 2024 Female  Grace 291    3 0.006389987 0.01345851
## 4 2024 Female  Emily 290    4 0.006368028 0.01341227
## 5 2024 Female  Fiadh 286    5 0.006280193 0.01322727
## 6 2024 Female   Lily 253    6 0.005555556 0.01170105
```

### Get most popular names in 2024

``` r
dat_top_2024 <- iebabynames |> 
    filter(year == "2024") |> 
    group_by(sex) |> 
    top_n(n = 10, wt = -rank) # get top 10

dat_top_2024
## # A tibble: 20 × 7
## # Groups:   sex [2]
##     year sex    name        n  rank    prop prop_sex
##    <dbl> <chr>  <chr>   <int> <dbl>   <dbl>    <dbl>
##  1  2024 Female Sophie    294     1 0.00646  0.0136 
##  2  2024 Female Éabha     293     2 0.00643  0.0136 
##  3  2024 Female Grace     291     3 0.00639  0.0135 
##  4  2024 Female Emily     290     4 0.00637  0.0134 
##  5  2024 Female Fiadh     286     5 0.00628  0.0132 
##  6  2024 Female Lily      253     6 0.00556  0.0117 
##  7  2024 Female Olivia    246     7 0.00540  0.0114 
##  8  2024 Female Amelia    220     8 0.00483  0.0102 
##  9  2024 Female Sadie     216     9 0.00474  0.00999
## 10  2024 Female Mia       213    10 0.00468  0.00985
## 11  2024 Male   Jack      490     1 0.0108   0.0205 
## 12  2024 Male   Noah      486     2 0.0107   0.0203 
## 13  2024 Male   Rían      432     3 0.00949  0.0181 
## 14  2024 Male   Cillian   352     4 0.00773  0.0147 
## 15  2024 Male   James     336     5 0.00738  0.0140 
## 16  2024 Male   Tadhg     318     6 0.00698  0.0133 
## 17  2024 Male   Fionn     304     7 0.00668  0.0127 
## 18  2024 Male   Liam      303     8 0.00665  0.0127 
## 19  2024 Male   Oisín     286     9 0.00628  0.0120 
## 20  2024 Male   Charlie   258    10 0.00567  0.0108
```

### Visualising the 10 most frequent male and female names across the entire period

``` r
iebabynames_top <- iebabynames |> 
    group_by(sex, name) |> 
    summarise(n_total = sum(n)) |> 
    top_n(n = 10, wt = n_total)

ggplot(iebabynames_top, aes(x = n_total,
                            y = reorder(name, n_total), 
                            fill = sex)) +
    geom_bar(stat = "identity") +
    geom_text(aes(label = name), nudge_x = -2000, 
              hjust = "right",
              colour = "white") +
    scale_x_continuous(labels = scales::comma_format()) +
    scale_fill_manual(values = c("#83D0F5", "#71B294")) +
    labs(title = "Frequency of Baby Names in Ireland (1964–2024)", 
         x = "Number of Babies",
         y = NULL) +
    theme(axis.text.y = element_blank(),
          axis.ticks.y = element_blank(),
          legend.title = element_blank(),
          legend.position = "bottom") 
```

![](man/images/unnamed-chunk-6-1.png)<!-- -->

### Inspecting the development of selected names

``` r
ggplot(data = filter(iebabynames, name %in% c("John", "Mary")),
       aes(x = year, y = prop)) +
    geom_smooth(se = FALSE) +
    scale_x_continuous(breaks = c(seq(1963, 2024, 10))) +
    scale_y_continuous(labels = scales::percent,
                       breaks = c(seq(0, 0.06, 0.01))) +
    geom_point(alpha = 0.4) +
    facet_wrap(~name) +
    labs(x = NULL, y = "Percentage of Babies") 
```

![](man/images/unnamed-chunk-7-1.png)<!-- -->

### Explore different variants of names

``` r
iebabynames_variants <- iebabynames |> 
    filter(name %in% c("Aoibhe", "Eva", "Eve"))

ggplot(data = iebabynames_variants,
       aes(x = year, y = n)) +
    geom_smooth(se = FALSE) +
    scale_x_continuous(breaks = c(seq(1963, 2024, 20))) +
    geom_point(alpha = 0.4) +
    facet_wrap(~name, nrow = 1) +
    labs(x = NULL, y = "Frequency") +
    theme(axis.text.x = element_text(angle = 90, vjust = 0.5))
```

![](man/images/unnamed-chunk-8-1.png)<!-- -->

The [website of the Central Statistics
Office](https://www.cso.ie/en/interactivezone/visualisationtools/babynamesofireland/)
includes an interactive interface that allows you to plot the frequency
and rank of custom names.

## How to cite

Stefan Müller (2025). *iebabynames: Ireland Baby Names, 1964–2024*. R
package version 0.2.5. URL:
<http://github.com/stefan-mueller/iebabynames>.

If you use the data, please also cite the CSO website:
<https://www.cso.ie/en/interactivezone/visualisationtools/babynamesofireland/>.

## Issues

Please file an issue (with a bug, wish list, etc.) [via
GitHub](https://github.com/stefan-mueller/iebabynames/issues).
