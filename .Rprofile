## Print this on start so I know it's loaded.
# cat("Loading custom .Rprofile\n")
## A little gem from Hadley Wickam that will set your CRAN mirror and automatically load devtools in interactive sessions.
.First <- function() {
  options(
    repos = c(CRAN = "https://cran.rstudio.com/"),
    # setwd("~/R"),
    deparse.max.lines = 2)
}
# if (interactive()) {
#   suppressMessages(require(devtools))
# }
## Nice option for local work. I keep it commented out so my code can remain portable.
## options(stringsAsFactors=FALSE)
## Increase the size of my Rhistory file, because I like to use the up arrow!
Sys.setenv(R_HISTSIZE='100000')
## Create invisible environment ot hold all your custom functions
.env <- new.env()
## Single character shortcuts for summary() and head().
.env$s <- base::summary
.env$h <- utils::head
#ht==headtail, i.e., show the first and last 10 items of an object.
.env$ht <- function(d) rbind(head(d,10),tail(d,10))
## Read data on clipboard.
.env$read.cb <- function(...) {
  ismac <- Sys.info()[1]=="Darwin"
  if (!ismac) read.table(file="clipboard", ...)
  else read.table(pipe("pbpaste"), ...)
}
## List objects and classes.
.env$lsa <- function() {
    obj_type <- function(x) class(get(x, envir = .GlobalEnv)) # define environment
    foo = data.frame(sapply(ls(envir = .GlobalEnv), obj_type))
    foo$object_name = rownames(foo)
    names(foo)[1] = "class"
    names(foo)[2] = "object"
    return(unrowname(foo))
}
## List all functions in a package.
.env$lsp <-function(package, all.names = FALSE, pattern) {
    package <- deparse(substitute(package))
    ls(
        pos = paste("package", package, sep = ":"),
        all.names = all.names,
        pattern = pattern
    )
}
## Open Finder to the current directory. Mac Only!
.env$macopen <- function(...) if(Sys.info()[1]=="Darwin") system("open .")
.env$o       <- function(...) if(Sys.info()[1]=="Darwin") system("open .")
## Attach all the variables above
attach(.env)
## Finally, a function to print out all the functions you have defined in the .Rprofile.
print.functions <- function() {
    cat("s() - shortcut for summaryn",sep="")
    cat("h() - shortcut for headn",sep="")
    cat("read.cb() - read from clipboardn",sep="")
    cat("lsa() - list objects and classesn",sep="")
    cat("lsp() - list all functions in a packagen",sep="")
    cat("macopen() - open finder to current working directory",sep="")
}

suppressMessages(library(dplyr))
suppressMessages(require(colorout))
