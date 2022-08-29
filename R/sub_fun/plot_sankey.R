#'
#'
#'
#'plot_Sankey
#'


plot_Sankey<- function(modlistIN,sinksRightIN = F,fontSizeIN = 12){
  
  
  mm <- get_all_network(modlistIN)
  linksIN <- mm$links
  nodesIN <- mm$nodes_2
  # # Make the Network
  #p <- sankeyNetwork(Links = mod$links, Nodes = mod$nodes,
  p <- sankeyNetwork(Links = linksIN, Nodes = nodesIN,
                     Source = "IDsource", Target = "IDdestination",
                     Value = "value", NodeID = "label",
                     fontSize = fontSizeIN, unit = "Letter(s)",
                     # nodeWidth = "weight_destination",
                     NodeGroup  = "Type",
                     LinkGroup = "Category",
                     # LinkGroup = "Type",
                     sinksRight=sinksRightIN)
  
  # p+d3.selectAll(".node").filter(function(d) { return d.name == "B3" }).attr("transform", function(d) { return "translate(" + (d.x - 300) + "," + d.y + ")"; }
  
  p
}
