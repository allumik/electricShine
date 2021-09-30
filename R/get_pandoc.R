# Modified from RInno, https://github.com/ficonsulting/RInno/blob/master/R/get_pandoc.R
#' Downloads Pandoc
#'
#' Downloads Pandoc in \code{app_dir}. If Pandoc has already been downloaded, \code{get_Pandoc} will use that file. If the download fails it will stop.
#'
#' If \code{\link{create_app}(include_Pandoc = TRUE)}, then \code{get_Pandoc}.
#'
#' @param app_dir The application directory
#' @param Pandoc_version Pandoc version to use, defaults to: \link[rmarkdown]{pandoc_available}. This ensures that the same version of Pandoc used during development is installed on users' computers.
#'
#'
#' @author Jonathan M. Hill and Hanjo Odendaal
#' @export

get_Pandoc <- function(app_dir, Pandoc_version = as.character(rmarkdown::pandoc_version())) {
  Pandoc_url <- sprintf("https://github.com/jgm/pandoc/releases/download/%s/pandoc-%s-windows-x86_64.zip", Pandoc_version, Pandoc_version)
  tf <- tempfile()
  filename <- file.path(app_dir, "app", "pandoc")

  cat(sprintf("Downloading Pandoc-%s ...\n", Pandoc_version))
  
  curl::curl_download(Pandoc_url, tf)
  
  if (!file.exists(tf)) stop(glue::glue("{filename} failed to download."))
  zip::unzip(tf, exdir = filename, junkpaths = T)
  unlink(tf)
  NULL
}

#' Add `RSTUDIO_PANDOC` environment variable to Rprofile.site
#' 
#' Adds the `RSTUDIO_PANDOC` environment variable to Rprofile.site so rmarkdown/htmlwidgets/etc know where to find pandoc
#'
#' @param app_dir The application directory
#'
#' @return
#' @export
#'
#' @examples
add_rstudio_pandoc_to_rprofile_site <- function(app_dir){
   rprofile_path <- file.path(app_dir, "app", "r_lang", "etc", "Rprofile.site")
   cat(
     'Sys.setenv(RSTUDIO_PANDOC = normalizePath(file.path(R.home(), "..", "pandoc"), mustWork = F))',
     sep = "\n",
     file = rprofile_path,
     append = T
   )
}