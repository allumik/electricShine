
#' Install from isolated lib
#'
#' @return na
#' @export
#'

install_package_new <- function(arguments){
  remotes_code <- arguments$ESHINE_remotes_code
  return_file_path <-  arguments$ESHINE_package_return
  passthr <- arguments$passthr
  require(remotes, lib.loc = arguments$remotes_location)
  # getFromNamespace should not be used in production code...
  remotes_code <- getFromNamespace(remotes_code,
                                   ns = "remotes")
  
  if(!is.null(arguments$dependency_install_opts))
    do.call(remotes::install_deps, arguments$dependency_install_opts)
  z <- do.call(remotes_code, passthr)
  # the remotes package returns the name of the installed package
  # but when called from system2, at least on mac,
  # this results in a lot of kerfuffle so here we return
  # a string that will we can regex for
  writeLines(z, con=return_file_path)

}
