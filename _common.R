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
