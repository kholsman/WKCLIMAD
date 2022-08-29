# 1. WKCLIMAD Overview

This repository contains R code and Rdata files for working with
WKCLIMAD data and responses. WKCLIMAD is an ICES workshop aimed at
exploring how can the short-, medium-, and long-term influences of
climate change on aquaculture, fisheries, and ecosystems be accounted
for in ICES Advice.

More information about WKCLIMAD can be found
here:<https://www.ices.dk/community/groups/Pages/WKCLIMAD.aspx>

# 2. Visualizing the results

The interactive shiny() is downloadable by entering the following lines
of code into R().

``` r
#'Run the WKCLIMAD results
#'
#'https://github.com/kholsman/WKCLIMAD

missing <- setdiff("shiny", installed.packages()[, 1])
if (length(missing) > 0) install.packages(missing)

# Load libraries:
for(lib in c("shiny"))
  suppressMessages(eval(parse(text=paste("library(",lib,")"))))

runGitHub( "WKCLIMAD", "kholsman")
```

<!-- ```{r sfint-shiny} -->
<!-- knitr::include_app("https://kkh2022.shinyapps.io/WKCLIMAD/",  -->
<!--   height = "900px") -->
<!-- ``` -->

## 3. Chord Diagram

<!-- ```{r showChoro1,echo=F} -->
<!-- # All defaults -->
<!-- htmltools::includeHTML("Figs/ChordPlot.html") -->
<!-- # include_graphics("Figs/ForcePlot.html") -->
<!-- ``` -->

## 4. Force Diagram

<!-- ```{r showChoro2,echo=F} -->
<!-- htmltools::includeHTML("Figs/ForcePlot.html") -->
<!-- ``` -->

## 5. Sankey Diagram

<!-- ```{r showChoro3,echo=F} -->
<!--  htmltools::includeHTML("Figs/SankeyPlot.html") -->
<!-- ``` -->
