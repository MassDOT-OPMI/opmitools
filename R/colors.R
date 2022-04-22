opmi_colors <-
  c(opmi_orange = "#FEA83D",
    opmi_petrolblue = "#246D77",
    opmi_coralred = "#FF5244",
    opmi_seafoam = "#62BDAF",
    opmi_skyblue = "#258EBA",
    opmi_deeppurple = "#432533",
    opmi_cream = "#FFFCF0",
    opmi_midgrey = "#E6E9EB",
    opmi_rl = "#DA291C",
    opmi_ol = "#ED8B00",
    opmi_gl = "#00843D",
    opmi_bl = "#003DA5",
    opmi_bus = "#FFC72C",
    opmi_ferry = "#008EAA",
    opmi_cr = "#80276C",
    opmi_sl = "#7C878E",
    opmi_ride = "#52BBc5")

#' OPMI Colors
#'
#' A function to provide hex values for colors in the OPMI color palette
#' or colors of MBTA services.
#'
#' @param ... One or multiple colors from the OPMI color palette
#' ("orange", "petrolblue", "coralred", "seafoam", "skyblue", "deeppurple",
#' "cream", or "midgrey")
#' or MBTA color scheme
#' ("rl", "ol", "gl", "bl", "bus", "ferry", "cr", "sl", "ride").
#' If no colors are provided, the entire list of colors will be returned.
#'
#'
#' @return One or multiple color hex values
#' @export
#'
#' @examples
#' opmi_cols()
#' opmi_cols("coralred")
#' opmi_cols("rl", "ol")
opmi_cols <-
  function(...) {
    cols <- c(...)
    if (is.null(cols)) {
      return (opmi_colors)
    } else {
      opmi_colors[paste0("opmi_", cols)]
    }
}

opmi_palettes <-
  list(main = opmi_cols("orange", "petrolblue", "coralred", "seafoam", "skyblue", "deeppurple"),
       diverging = opmi_cols("petrolblue", "orange"),
       diverging2 = opmi_cols("seafoam", "coralred"),
       rt = opmi_cols("rl", "ol", "gl", "bl"))




#' OPMI Palette Chooser
#'
#' Creates a function that can be used by `scale_fill_opmi` and `scale_color_opmi`.
#' Can also be used to create manual color/fill palettes for `scale_color_manual`
#' and `scale_fill_manual`.
#'
#' @param palette One of "main", "diverging", "diverging2", or "rt"
#' @param reverse Logical, whether to reverse palette
#' @param discrete Logical, whether palette is for discrete scale
#' @param mono Logical, whether to use a single-color palette
#' @param monocol If `mono` = TRUE, which color to use for palette
#' @param ... Additional arguments passed to `colorRampPalette`
#'
#' @importFrom methods as
#' @importFrom grDevices colorRampPalette
#' @return A function that can be used by `scale_fill_opmi` and `scale_color_opmi`
#' @export
#'
opmi_pal <-
  function(palette = "main",
           reverse = FALSE,
           discrete = TRUE,
           mono = FALSE,
           monocol = "orange",
           ...) {

    diverging <- palette %in% c("diverging", "diverging2")


    if(!palette %in% names(opmi_palettes)) {
      stop(paste0("Must select one of '",
                  paste(names(opmi_palettes), collapse = "', '"),
                  "'."))
    }

    stopifnot(diverging == FALSE | mono == FALSE)
    stopifnot(mono == FALSE | discrete == TRUE)

    if (mono & !discrete) {
      stop("Mono-color continuous palettes are not currently enabled.")
    }

    if (mono) {
      newcol <- as(colorspace::hex2RGB(opmi_cols(monocol)), "polarLUV")
      hue <- newcol@coords[3]
      chr <- newcol@coords[2]
      lux <- newcol@coords[1]
    }

    pal <- opmi_palettes[[palette]]

    if (reverse) pal <- rev(pal)

    if (discrete & !diverging & !mono) {
      function(n = 6) {
        if (n > length(pal)) {warning(paste0("Selected palette has fewer than ", n, " colors\n * Try using non-discrete palette"))}

        unlist(unname(pal[1:n]))
      }
    } else if (!discrete & !diverging & !mono) {
      colorRampPalette(pal, space = "Lab", ...)
    } else if (diverging & !mono) {
      colorRampPalette(c(pal[1],
                         opmi_cols("midgrey"),
                         pal[2]), space = "Lab", ...)
    } else if (discrete & mono) {
      function(n  = 5) {
        colorspace::sequential_hcl(n, h1 = hue, cmax = chr, l1 = lux, rev = reverse)
      }
    }
  }




#' OPMI Color Scales
#'
#' @inheritParams opmi_pal
#' @param diverging Does not need to be specified, inherits from `palette`
#'
#' @return A scale that can be used in ggplots
#' @export
#'
#' @name scale_fill_opmi
#' @importFrom ggplot2 discrete_scale scale_color_gradientn scale_color_gradient2
scale_fill_opmi <- function(palette = "main", discrete = TRUE, reverse = FALSE,
                            diverging = (palette %in% c("diverging", "diverging2")),
                            mono = FALSE, monocol = "orange",
                            ...) {

  pal <- opmi_pal(palette = palette, reverse = reverse, discrete = discrete, diverging = diverging, mono = mono, monocol = monocol)

  if (discrete & !diverging & !mono) {
    discrete_scale("fill", paste0("opmi_", palette),  palette = pal, ...)
  } else if (!discrete & !diverging & !mono) {
    scale_fill_gradientn(colors = pal(256), ...)
  } else if (discrete & diverging & !mono) {
    discrete_scale("fill", paste0("opmi_", palette),  palette = pal, ...)
  } else if (!discrete & diverging & !mono) {
    div_cols <- pal(2)
    scale_fill_gradient2(aesthetics = "fill",
                         low = div_cols[1], high = div_cols[2], mid = opmi_cols("midgrey"),
                         ...)
  } else if (discrete & mono) {
    discrete_scale("fill", paste0("opmi_", palette), palette = pal)
  }

}


#' @rdname scale_fill_opmi
scale_color_opmi <- function(palette = "main", discrete = TRUE, reverse = FALSE,
                             diverging = (palette %in% c("diverging", "diverging2")),
                             mono = FALSE, monocol = "orange",
                             ...) {

  pal <- opmi_pal(palette = palette, reverse = reverse, discrete = discrete, diverging = diverging, mono = mono, monocol = monocol)

  if (discrete & !diverging & !mono) {
    discrete_scale("color", paste0("opmi_", palette),  palette = pal, ...)
  } else if (!discrete & !diverging & !mono) {
    scale_fill_gradientn(colors = pal(256), ...)
  } else if (discrete & diverging & !mono) {
    discrete_scale("color", paste0("opmi_", palette),  palette = pal, ...)
  } else if (!discrete & diverging & !mono) {
    div_cols <- pal(2)
    scale_fill_gradient2(aesthetics = "color",
                         low = div_cols[1], high = div_cols[2], mid = opmi_cols("midgrey"),
                         ...)
  } else if (discrete & mono) {
    discrete_scale("color", paste0("opmi_", palette), palette = pal)
  }

}
