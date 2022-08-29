
#'Run the WKCLIMAD results
#'
#'https://github.com/kholsman/WKCLIMAD

missing <- setdiff("shiny", installed.packages()[, 1])
if (length(missing) > 0) install.packages(missing)

# Load libraries:
for(lib in c("shiny"))
  suppressMessages(eval(parse(text=paste("library(",lib,")"))))

runGitHub( "WKCLIMAD", "kholsman")
