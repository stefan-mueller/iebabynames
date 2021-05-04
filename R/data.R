#' @rdname iebabynames
#' @aliases iebabynames
#' @title Irish baby names
#' @description Full baby name data (1964--2020) for the Republic of Ireland from the Central Statistics Office.
#'    Due to confidentiality reasons, only names with 3 or more instances in the relevant year are included.
#' @format A data frame with 72,585 observations on six variables: \code{year}, \code{sex}, \code{name}, \code{n}, \code{rank}, \code{prop}. \describe{
#'     \item{year}{A year (1964--2020)}
#'     \item{sex}{Sex (Male or Female)}
#'     \item{name}{A name}
#'     \item{n}{Count of name within year and sex}
#'     \item{rank}{Rank of name within year and sex}
#'     \item{prop}{Proportion of name within year and sex}
#'   }
#' @details
#' The data are released by the Central Statistics Office.
#'
#' If you use the data, please also cite the CSO website: \url{https://www.cso.ie/en/interactivezone/visualisationtools/babynamesofireland/}
#' @source
#' Central Statistics Office. 2021 \href{https://www.cso.ie/en/interactivezone/visualisationtools/babynamesofireland/}{Baby Names of Ireland}.
#' @keywords data
"iebabynames"
