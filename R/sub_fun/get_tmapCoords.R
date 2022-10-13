#'
#'get_tmapCoords.R
#'


tmapCoords <- function(modlistIN,fontSizeIN = 5,minSize=1,labW= 40) {
  mm <- suppressMessages(get_all_network(modlistIN))
  linksIN <- mm$links
  nodesIN <- mm$nodes%>%mutate(fontSize=fontSizeIN*freq,frequency=freq)%>%filter(freq>minSize)
  edgesIN <- mm$edges
  nodes2IN<- mm$nodes_2
  nodesIN$plotLab <- str_wrap(nodesIN$plotID, width = labW)
  
  
  treemapify(nodesIN, area = "freq", fill = "freq", label = "plotLab", xlim = c(0, 1),
             ylim = c(0, 1))
}
