#'
#'
#'
#' plot_tree.R



plot_tree<-function(modlistIN,saveIT = F,minSize=1,labW= 10,width = 10, height =4, dpi=400,
                    file_name = "Figs/tree.jpg",
                           fontSizeIN = 5){
  
  require(stringr)
  mm              <- suppressMessages(get_all_network(modlistIN))
  linksIN         <- mm$links
  nodesIN         <- mm$nodes%>%mutate(fontSize=fontSizeIN*freq)%>%filter(freq>minSize)
  edgesIN         <- mm$edges
  nodes2IN        <- mm$nodes_2
  nodesIN$plotLab <- str_wrap(nodesIN$plotID, width = labW)
  
  p<-ggplot(nodesIN,aes(area = freq, fill = freq, label=plotLab)) +
    geom_treemap() +
    geom_treemap_text(colour = c(rep("blue4",dim(nodesIN)[1])),
                      place = "centre",
                      size = nodesIN$fontSize) +
    scale_fill_distiller(palette = "Spectral",direction = -1)
  p
  if(saveIT){
    if(!dir.exists("Figs/Final")) 
    dir.create("Figs/Final")
    ggsave(plot=p,filename=file_name, scale=2,width = width, height = height, units="in", 
           dpi = dpi)}
  
   return(p)
}

