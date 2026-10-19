# Sourced by the setup chunk of every chapter. Paths are relative to the book
# root because _quarto.yml sets execute-dir: project.

suppressMessages(library(easyRasch2))
library(knitr)

# One line for the chapter's "About this chapter" box, recording what the
# chapter was computed with. Pass the packages the chapter's results rest on.
computed_with <- function(pkgs = "easyRasch2") {
  v <- vapply(pkgs, function(p) as.character(utils::packageVersion(p)),
              character(1L))
  paste(c(paste(pkgs, v), paste("R", getRversion())), collapse = ", ")
}

# " (last modified <date>)" for the "Cite as" line, or nothing when the chapter
# has not been modified since it was first published. Reads date and
# date-modified from the chapter's front matter.
modified_note <- function() {
  meta <- rmarkdown::metadata
  if (is.null(meta[["date-modified"]])) return("")
  published <- as.Date(meta[["date"]])
  modified  <- as.Date(meta[["date-modified"]])
  if (modified <= published) return("")
  # month.name keeps English month names whatever the system locale
  sprintf(" (last modified %s %d, %s)", month.name[as.integer(format(modified, "%m"))],
          as.integer(format(modified, "%d")), format(modified, "%Y"))
}

# House ggplot theme, as in easyRasch2: theme_bw() with room between the axis
# titles and the tick labels (er2_axis_margins()) and between facet panels.
# Set as the default for every chapter, so chapters add only plot-specific
# tweaks such as legend position.
theme_book <- function(base_size = 12) {
  ggplot2::theme_bw(base_size = base_size) +
    ggplot2::theme(
      axis.title.x = ggplot2::element_text(margin = ggplot2::margin(t = 12)),
      axis.title.y = ggplot2::element_text(margin = ggplot2::margin(r = 12)),
      panel.spacing = ggplot2::unit(0.7, "cm")
    )
}
ggplot2::theme_set(theme_book())
