% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/colors.R
\name{scale_fill_opmi}
\alias{scale_fill_opmi}
\alias{scale_color_opmi}
\title{OPMI Color Scales}
\usage{
scale_fill_opmi(
  palette = "main",
  discrete = TRUE,
  reverse = FALSE,
  diverging = (palette \%in\% c("diverging", "diverging2")),
  mono = FALSE,
  monocol = "orange",
  ...
)

scale_color_opmi(
  palette = "main",
  discrete = TRUE,
  reverse = FALSE,
  diverging = (palette \%in\% c("diverging", "diverging2")),
  mono = FALSE,
  monocol = "orange",
  ...
)
}
\arguments{
\item{palette}{One of "main", "massdot", "diverging", "diverging2", or "rt"}

\item{discrete}{Logical, whether palette is for discrete scale}

\item{reverse}{Logical, whether to reverse palette}

\item{diverging}{Does not need to be specified, inherits from \code{palette}}

\item{mono}{Logical, whether to use a single-color palette}

\item{monocol}{If \code{mono} = TRUE, which color to use for palette}

\item{...}{Additional arguments passed to \code{colorRampPalette}}
}
\value{
A scale that can be used in ggplots
}
\description{
OPMI Color Scales
}
