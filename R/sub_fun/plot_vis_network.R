#'
#'
#'
#'plot_vis_network.R
#'
#'
#'
#'
plot_vis_network<-function(modlistIN,sinksRightIN = F,
                           fontSizeIN = 12,
                           align_hierIN="no",
                           distIN =.3,
                           layoutIN ="layout_with_sugiyama",
                           dirIN ="LR"){
    
  
    mm <- suppressMessages(get_all_network(modlistIN))
    linksIN <- mm$links
    nodesIN <- mm$nodes%>%mutate(font.size = fontSizeIN*3)
    edgesIN <- mm$edges
    nodes2IN<- mm$nodes_2
    
    nodesIN  <- nodesIN%>%left_join(nodes2IN%>%group_by(plotID)%>%summarize(level = mean(level)), by = c("plotID"="plotID"))
    v <- visNetwork(nodes=nodesIN, edges=edgesIN) %>% 
      visEdges(arrows = "middle")%>%
      visNodes(color = list(hover = "green")) %>%
      visNodes(shadow = list(enabled = TRUE, size = 50))
    
  #https://datastorm-open.github.io/visNetwork/options.html
  network_vis <- visNetwork(nodesIN, edgesIN)%>% 
    visIgraphLayout(layout = layoutIN)
  
  if(layoutIN =="layout_with_sugiyama")
    network_vis <- visNetwork(nodesIN, edgesIN)%>% 
    visIgraphLayout(layout = layoutIN,layers =nodesIN$level)
  
  network_vis <- network_vis%>%
    visOptions(highlightNearest = TRUE)%>%
    visEdges(arrows = "middle")%>%visExport()%>%
    visLegend(useGroups = TRUE)
  
  if(align_hierIN=="yes")
    network_vis <- network_vis%>%
    visHierarchicalLayout(levelSeparation = distIN, 
                          #nodeSpacing = input$nodeSpacing,
                          direction=dirIN)
  
  
  links2 <-linksIN%>%select(IDsource,IDdestination,value)%>%mutate(value=value*10)
  nodes2 <- nodesIN%>%select(label,group,freq)%>%rename(size=freq)
  
 
  # Create graph with legend and varying node radius
  network_force <- forceNetwork(Links = links2, Nodes = nodes2, Source = "IDsource",
               Target = "IDdestination", Value = "value", NodeID = "label",
               Nodesize = "size",fontSize = fontSizeIN, zoom = TRUE,
               radiusCalculation = "Math.sqrt(d.nodesize)+6",arrows = TRUE,
               Group = "group", opacity = 1, legend = TRUE)
  
  
  return(list(v=v,vis=network_vis,force=network_force,mod=mm))
}
