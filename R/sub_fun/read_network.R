#'
#'
#'read_network.R
#'
#'

#'
#'
#' read_network.R
#'
#' csv_file <- "data/shiny/01_CCTF_KKH.csv"
#' csv_file <- file.path("data/shiny",modlist[1])
#' 
read_network <- function(csv_file,sizeIN=16, NAval = NA,
                         lkup = "data/shiny/Network_metadata.xlsx"){
  
  names <- scan(csv_file,nlines=1,what=character(),sep=",")
  links <- read.csv(csv_file,header=T)
  
  colnames(links)     <- names
  links[is.na(links)] <- NAval
  colnames(links)[1]  <- "ID"
  
  links               <- reshape2::melt(links, na.rm = TRUE,id.vars="ID")
  names(links)        <- c("source","destination","value")
  links$source        <- as.character(links$source)
  links$destination   <- as.character(links$destination)
  links$value[which(links$value==0)] <-0.1
  #links               <- links[-which(links$value==0),]
  #links               <- links[-is.na(links$value),]
  
  
  
  # create links and nodes:
  sources <- links %>%
    distinct(source) %>%
    rename(label = source)
  
  destinations <- links %>%
    distinct(destination) %>%
    rename(label = destination)
  
  nodes <- full_join(sources, destinations, by = "label")
  nodes <- nodes %>% rowid_to_column("id")
  
  if(!is.null(lkup)){
    ttt <- (strsplit(csv_file,"/"))[[1]]
    ttt <- rev(ttt)[1]
    group_lkup <- readxl::read_xlsx(lkup, sheet = substr(ttt,1,nchar(ttt)-4),skip=1)
    tbl <- readxl::read_xlsx(lkup, sheet = "lookup tables")[1:11,1:3]
    names(tbl)[1] <- "group"
    
    names(group_lkup)[2] <- "group"
    #group_lkup$group <- factor(group_lkup$group,levels = tbl$group[as.numeric(tbl$Level)])
    nodes <-  merge(nodes,group_lkup[,1:3], by.x = "label",by.y ="Name",all.x = T)
    nodes$icon <-NULL
    
  }else{
    nodes$group <- "id"
    nodes$levels <- 1
    nodes$icon <-NULL
  }
  
  # binary where weights are the number of links:
  per_route <- links %>%  
    group_by(source, destination) %>%
    summarise(weight = n()) %>% 
    ungroup()
  
  #value (where negative or positive connections are the weights)
  per_route <- links %>% 
    group_by(source, destination) %>%
    summarise(weight = abs(value)) %>% 
    ungroup()
  
  edges <- per_route %>% 
    left_join(nodes, by = c("source" = "label")) %>% 
    rename(from = id)
  
  edges <- edges %>% 
    left_join(nodes, by = c("destination" = "label")) %>% 
    rename(to = id)
  
  edges     <- select(edges, from, to, weight)
  edges2    <- mutate(edges, width = weight/5 + 1)
  nodes_d3 <- nodes
  #nodes_d3 <- mutate(nodes, id = id - 1)
  edges_d3 <- mutate(edges2, from = from - 1, to = to - 1)
  nodesVis <- nodes%>%mutate(font.size = sizeIN*3)
  
  
  out_network <- network(edges, vertex.attr = nodes, matrix.type = "edgelist", ignore.eval = FALSE)
  
  return(list(
    network= out_network, 
    edges=edges, 
    links=links,
    edges2= edges2,
    edges_d3 = edges_d3,
    per_route = per_route, 
    nodes = nodes, 
    nodesVis = nodesVis,
    nodes_d3 = nodes_d3,
    destinations = destinations, 
    sources =sources ))
  
}