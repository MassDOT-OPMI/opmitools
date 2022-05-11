#' Create Plot Month
#'
#' @param month_field Date field in data frame
#'
#' @return Factor field in data frame
#' @export
#'
plot_month <- function(month_field) {
  forcats::fct_reorder(format(month_field, "%b '%y"), month_field)
}
