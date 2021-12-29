library (netmeta)
library("tidyverse")

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

NMAsummary <- function(NMAobj, refname = "Untreated (SOC/Placebo)", xlim = NULL, HiddenParameter = NULL) {

  if (NMAobj$comb.random == TRUE) modelname <- "Random Effects Model"
  else modelname <- "Fixed Effects Model"

  netgraph(NMAobj, cex = 0.9, multiarm=TRUE, start.layout = "circle", offset = 0.035)

  if (!is.null(xlim)){
  forest(NMAobj,
         fontsize=10,
         leftcols = c("studlab", "Pscore", "effect", "ci"),
         leftlabs = c("Treatment Arms"),
         xlim=xlim,
         sortvar = -Pscore,
         plotwidth = "8cm",
         spacing = 1.25,
         just = "center",
         col.square.lines = "black",
         col.square = "grey",
         col.inside = "black",
         lwd = 1,
         colgap.forest = "0.5cm",
         smlab = paste ("Intervention vs", refname,HiddenParameter,"\n",modelname),
         layout="JAMA")
  } else {
    forest(NMAobj,
           fontsize=10,
           leftcols = c("studlab", "Pscore", "effect", "ci"),
           leftlabs = c("Treatment Arms"),
           sortvar = -Pscore,
           plotwidth = "8cm",
           spacing = 1.25,
           just = "center",
           col.square.lines = "black",
           col.square = "grey",
           col.inside = "black",
           lwd = 1,
           colgap.forest = "0.5cm",
           smlab = paste ("Intervention vs", refname,HiddenParameter,"\n",modelname),
           layout="JAMA")
  }


  print (ref = NMAobj$reference.group, NMAobj)

}

CAfunnel <- function(NMAobj, rank) {

  j_rank <- netrank(NMAobj)

  treatment_names <- j_rank$Pscore.random
  treatment_names <- data.frame(trt = names(treatment_names), score = unname(treatment_names))
  f <- c(treatment_names$trt)

  # Import funnel plot ranking data
  p_rank<-rank

  # Sort treatment names based on funnel plot ranking data
  f<-f[order(match(f,p_rank))]

  # Generate funnel plot (parameter col= is a really disgusting workaround to get the number of total comparisons)
  funnel <- funnel.netmeta(NMAobj, order = f, legend = FALSE, pch = c(16), col = c(1:NROW(result.bin$Q.decomp$treat1)), linreg = TRUE, rank = FALSE, mm = FALSE)

}

subgroupNMA.bin <- function(NMAobj, data, byvar, specvar = NULL, refname = "Untreated (SOC/Placebo)", xlim = NULL) {

  if (!is.null(specvar)) {tempvar = specvar} else tempvar = data$byvar

  x<-split(data, data[byvar])

  for (v in tempvar) {

    hp = paste("(",v," Subgroup)", sep="")

    tempdata <- x[v]
    tempdata <- tempdata[[v]]
    tempNMAobj <- simpleNMA.bin (data = tempdata, measure = NMAobj$sm, correction = NMAobj[["data"]][["allstudies"]][1], random = NMAobj$comb.random,
                                 ref = NMAobj[["reference.group"]], sm.val = NMAobj[["small.values"]])

    NMAsummary (tempNMAobj, refname = refname, xlim = xlim, HiddenParameter = hp)

  }
}
