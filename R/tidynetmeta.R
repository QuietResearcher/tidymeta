library (netmeta)

# Hello, world!
#
# This is an example function named 'hello'
# which prints 'Hello, world!'.
#
# You can learn more about package authoring with RStudio at:
#
#   http://r-pkgs.had.co.nz/
#
# Some useful keyboard shortcuts for package authoring:
#
#   Install Package:           'Ctrl + Shift + B'
#   Check Package:             'Ctrl + Shift + E'
#   Test Package:              'Ctrl + Shift + T'

simpleNMA.bin <- function(data, n=NULL, r=NULL, measure = "OR", correction = FALSE, random = TRUE, ref = "Untreated", sm.val = "good") {

  if (!is.null(n) && !is.null(r)) {
    transformed_data <- pairwise(treat = treatment, event = data$r, studlab = study, n = data$n, data = data, sm = measure, allstudies = correction)
  } else if(!is.null(n)) {
    transformed_data <- pairwise(treat = treatment, event = responders, studlab = study, n = data$n, data = data, sm = measure, allstudies = correction)
  } else if (!is.null(r)) {
    transformed_data <- pairwise(treat = treatment, event = data$r, studlab = study, n = sampleSize, data = data, sm = measure, allstudies = correction)
  } else {
    transformed_data <- pairwise(treat = treatment, event = responders, studlab = study, n = sampleSize, data = data, sm = measure, allstudies = correction)
  }


  c.random <- random
  c.fixed <- !random

  NMAobject <- netmeta(TE, seTE, treat1, treat2, studlab, data = transformed_data, sm = measure, comb.fixed = c.fixed, comb.random = c.random,
                       prediction = FALSE, reference.group = ref, small.values = sm.val)

  return (NMAobject)

}

NMAsummary <- function(NMAobj) {

  forest(result.bin, leftcols = c("studlab", "Pscore"),xlim=c(0.01,100), sortvar = -Pscore, plotwidth="10cm", layout = "JAMA")
  print (ref = NMAobj$reference.group, NMAobj)

}
