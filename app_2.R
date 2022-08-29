#'This shiny app is based on code by S. Giachas and others at the NEFSC
#'https://github.com/NEFSC/READ-SSB-DePiper_Summer_Flounder_Conceptual_Models/blob/master/BuildConsMod/app.R
#'
# Find out more about building applications with Shiny here:
#'
#    http://shiny.rstudio.com/
#

# library(shiny)
# library(RColorBrewer)
# library(QPress)
# library(chorddiag)
# library(shinyWidgets)
# 

# Define conceptual model

#assumes this is a project and .dia file is in local directory
edges <- model.dia("Summer_Flounder_July22_2019.dia")

## Examine unweighted adjacency matrix
FLUKE <- adjacency.matrix(edges, labels=TRUE)

FLUKE_Drivers <- c("Economic Drivers","Temperature","Shifts in Preferences","Community Vulnerability","Freshwater Influx","Nutrient Influx","Ocean Acidification",
                   "Ocean Features","Oceanographic Transport","Dissolved Oxygen","Water Diversion")
FLUKE_Habitat <- c("Estuarine Habitat","Food Web Changes","Offshore Habitat","Habitat Alteration","Habitat Disturbance","Loose Inert Substrate","Salinity","Water Clarity",
                   "Aquatic Vegetation")
FLUKE_Biota <- c("Fluke Distributional Shift","Fluke Recruitment","Fluke SSB","Adults & Spawners","Age & Size Structure",
                 "Growth","Maturation","Natural Mortality","Sex Ratio")
FLUKE_Species <- c("Other Species Distributional Shifts","Protected Species")
FLUKE_Management <- c("Allocation","Communication","Enforcement","Management Control","Other Regulations",
                      "Permit Access","Regulatory Complexity","Risk Buffering")
FLUKE_Benefits <- c("Commercial Profits","Consumer Surplus","Recreational Value","Seafood","Recreational Profits")
FLUKE_Science <- c("Assessment Process","Data Quality","Predictability of Recreational Fishing","Stock Assessment")
FLUKE_Fishery <- c("Compliance","Discards","Fishery Distributional Shift","Fishery Resilience",
                   "Fleet Diversity","Landings","Perceived Inequity","Technical Interactions")

FLUKE_C <- brewer.pal(8,"Dark2")

FLUKE_Colors <- data.frame(row.names(FLUKE))
colnames(FLUKE_Colors) <- "Focus"

FLUKE_Colors$Color <- FLUKE_C[1]
FLUKE_Colors$Color[FLUKE_Colors$Focus%in%FLUKE_Habitat] <- FLUKE_C[2]
FLUKE_Colors$Color[FLUKE_Colors$Focus%in%FLUKE_Biota] <- FLUKE_C[3]
FLUKE_Colors$Color[FLUKE_Colors$Focus%in%FLUKE_Species] <- FLUKE_C[4]
FLUKE_Colors$Color[FLUKE_Colors$Focus%in%FLUKE_Management] <- FLUKE_C[5]
FLUKE_Colors$Color[FLUKE_Colors$Focus%in%FLUKE_Benefits] <- FLUKE_C[6]
FLUKE_Colors$Color[FLUKE_Colors$Focus%in%FLUKE_Science] <- FLUKE_C[7]
FLUKE_Colors$Color[FLUKE_Colors$Focus%in%FLUKE_Fishery] <- FLUKE_C[8]

FLUKE_edges <- cbind(FLUKE,FLUKE_Colors)
FLUKE_Colors <- FLUKE_Colors[order(FLUKE_Colors$Color,FLUKE_Colors$Focus),]
FLUKE_Colors <- matrix(FLUKE_Colors$Color,dimnames=list(FLUKE_Colors$Focus,"Color"))
FLUKE_edges <-  FLUKE_edges[order( FLUKE_edges$Color,FLUKE_edges$Focus),]

FLUKE_edges$Color <- NULL
FLUKE_edges$Focus <- NULL

rn <- row.names(FLUKE_edges)
FLUKE_edges2 <- FLUKE_edges[rn]

FLUKE_edges <- data.matrix(FLUKE_edges)
FLUKE_edges2 <- data.matrix(FLUKE_edges2)
FLUKE_edges2 <- t(FLUKE_edges2)
FLUKE_edges2 <- abs(FLUKE_edges2)

#########Submodels functions
Submodel_edges <- function (y) {
  New_edges <- FLUKE_edges2[,colnames(FLUKE_edges2)%in%y]
  New_edges <- New_edges[rownames(New_edges)%in%y,]
  return(New_edges)
}

Submodel_color <- function (y) {
  New_colors <-  as.vector(FLUKE_Colors[rownames(FLUKE_Colors)%in%y,])
  return(New_colors)
}

New_Figure <- function (x) {
  
  New_edges  <- Submodel_edges(x)
  New_colors <- Submodel_color(x)
  
  chorddiag(New_edges, 
            type = "directional",
            width = 900,
            height = 900,
            margin = 120,
            groupColors = New_colors,
            groupedgeColor = New_colors,
            chordedgeColor = New_colors,
            groupPadding = 1, groupThickness = 0.1,
            showTicks = F, groupnameFontsize = 12, groupnamePadding = 10
  )
}



#shinyApp(

ui = fluidPage(
  helpText("Please select at least two elements for plotting"),
  pickerInput("plotGroups", label = h3("Select elements to plot"), 
              choices = c(row.names(FLUKE_edges2)), selected = c(row.names(FLUKE_edges2)),
              multiple = TRUE, options = list(`actions-box` = TRUE), choicesOpt = NULL,
              width = NULL, inline = FALSE),
  chorddiagOutput("consmodPlot", height = 900)
)#,

server = function(input, output) {
  
  # validate(
  #      need(input$plotGroups != "", "Please select at least two groups for plotting")
  # )
  # 
  
  output$consmodPlot = renderChorddiag({
    New_Figure(input$plotGroups)
  })
}#,

#  options = list(height = 900)
#)


# Run the application 
shinyApp(ui = ui, server = server)