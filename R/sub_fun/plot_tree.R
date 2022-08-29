#'
#'
#'
#' plot_tree.R



plot_tree<-function(modlistIN,saveIT = F,minSize=1,
                           fontSizeIN = 5){
  
  
  mm <- suppressMessages(get_all_network(modlistIN))
  linksIN <- mm$links
  nodesIN <- mm$nodes%>%mutate(fontSize=fontSizeIN*freq)%>%filter(freq>minSize)
  edgesIN <- mm$edges
  nodes2IN<- mm$nodes_2

  
  p<-ggplot(nodesIN,aes(area = freq, fill = freq, label = plotID)) +
    geom_treemap() +
    geom_treemap_text(colour = c(rep("blue4",dim(nodesIN)[1])),
                      place = "centre",
                      size = nodesIN$fontSize) +
    scale_fill_distiller(palette = "Spectral",direction = -1)
  p
  if(saveIT){
    if(!dir.exists("Figs/Final")) 
    dir.create("Figs/Final")
    ggsave(plot=p,filename="Figs/tree.jpg", scale=2,width = 8, height = 4, units="in", dpi = 400)}
  
   return(p)
}
tmapCoords <- function(modlistIN,fontSizeIN = 5,minSize=1) {
  mm <- suppressMessages(get_all_network(modlistIN))
  linksIN <- mm$links
  nodesIN <- mm$nodes%>%mutate(fontSize=fontSizeIN*freq,frequency=freq)%>%filter(freq>minSize)
  edgesIN <- mm$edges
  nodes2IN<- mm$nodes_2
  
  treemapify(nodesIN, area = "freq", fill = "freq", label = "plotID", xlim = c(0, 1),
             ylim = c(0, 1))
}

