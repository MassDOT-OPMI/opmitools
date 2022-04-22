#' OPMI Theme
#'
#' Provides a ggplot2 theme that is consistent with the OPMI MS Office theme.
#'
#' @param base_size Numeric font size
#' @param base_font Name of font to use (only need to specify if you would like
#'  a font that is not included in base R and not included in the OPMI theme)
#' @param base_family Name of font family to use (only need to specify if you
#' would like a font that is not included in base R and not included in the
#' OPMI theme). For a base R font, use "sans", "serif", or "mono".
#'
#' @return A theme that can be used in ggplots.
#' @export
#' @import ggplot2
theme_opmi  <- function(base_size = 12,
                        base_font = "Open Sans",
                        base_family = "opensans") {

  if (base_family %in% (sysfonts::font_families()) & !(base_family %in% c("sans", "serif", "mono"))) {
    # if font already loaded, just enable calling it to create theme
    showtext::showtext_auto(enable = TRUE)
  } else if (!(base_family %in% c("sans", "serif", "mono"))) {
    # otherwise, load font
    sysfonts::font_add_google(base_font, base_family)
    # and enable calling font for duration of theme call
    showtext::showtext_auto(enable = TRUE)
  }

  theme(rect = element_rect(color = opmi_cols("cream")),
        text = element_text(size = base_size, family = base_family),
        title = element_text(hjust = 0.5),
        panel.grid.major.y = element_line(color = opmi_cols("midgrey")),
        panel.grid.minor.y = element_blank(),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        panel.border = element_blank(),
        legend.position = "bottom",
        plot.title = element_text(hjust = 0.5, margin = margin(t = 10)),
        axis.title.y = element_text(angle = 0,
                                    size = rel(0.95),
                                    margin = margin(l = 2.5, r = 10),
                                    vjust = 0.5),
        axis.text.y = element_text(size = rel(0.85)),
        axis.title.x = element_text(size = rel(0.95),
                                    margin = margin(t = 10, b = 0),
                                    hjust = 0.5),
        axis.text.x = element_text(size = rel(0.85)),
        legend.title = element_blank(),
        legend.key = element_rect(fill = opmi_cols("cream")),
        plot.margin = unit(c(5.5, 10, 5.5, 5.5), units = "points"),
        panel.background = element_rect(fill = opmi_cols("cream")),
        plot.background = element_rect(fill = opmi_cols("cream")),
        legend.background = element_rect(fill = opmi_cols("cream")),
        axis.ticks = element_blank())
}



#' Save OPMI-themed ggplots
#'
#' The default \code{\link[ggplot2]{ggsave}} options do not work well with the
#' `showtext` package, which is used to get the correct fonts. This changes
#' the resolution settings.
#'
#' @inheritParams ggplot2::ggsave
#' @param ... Arguments passed to `ggplot2:ggsave()`
#'
#' @return Saves a plot to a file.
#' @export
#'
opmi_ggsave <- function(filename, plot = ggplot2::last_plot(), device = NULL,
                        path = NULL, scale = 1, width = NA, height = NA,
                        units = c("in", "cm", "mm", "px"), dpi = 96,
                        limitsize = TRUE, bg = NULL,
                        ...) {
  ggplot2::ggsave(filename = filename, plot = plot, device = device,
                  path = path, scale = scale, width = width, height = height,
                  units = units, dpi = dpi, limitsize = limitsize, bg = bg,
                  ...)
}
