#'
#'
#'
#'plot_Sankey
#'


plot_Sankey<- function(modlistIN,sinksRightIN = F,fontSizeIN = 12,labW=15){
  
  
  mm <- get_all_network(modlistIN)
  linksIN <- mm$links
  nodesIN <- mm$nodes_2
  nodesIN$plotLab <- str_wrap(nodesIN$plotID, width = labW)
  # 
  # linksIN <- links_all%>%filter(model%in%modlistIN)
  # nodesIN <- nodes_all%>%filter(model%in%modlistIN)
  # 
  linksIN$IDsource2 <- linksIN$IDsource+1
  linksIN$IDdestination2 <- linksIN$IDdestination+1
  # # Make the Network
  #p <- sankeyNetwork(Links = mod$links, Nodes = mod$nodes,
  p <- sankeyNetwork(Links = linksIN, Nodes = nodesIN,
                     Source = "IDsource", Target = "IDdestination",
                     Value = "value", NodeID = "plotLab",
                     fontSize = fontSizeIN, unit = "Letter(s)",
                     # nodeWidth = "weight_destination",
                     NodeGroup  = "Type",
                     LinkGroup = "lab",
                     # LinkGroup = "Type",
                     sinksRight=sinksRightIN)
  
  # p+d3.selectAll(".node").filter(function(d) { return d.name == "B3" }).attr("transform", function(d) { return "translate(" + (d.x - 300) + "," + d.y + ")"; }
  
  p
}
