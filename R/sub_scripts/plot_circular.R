# plot circular

# Libraries
library(tidyverse)
library(viridis)
library(patchwork)
library(hrbrthemes)
library(ggraph)
library(igraph)


# # The flare dataset is provided in ggraph
# edges       <- flare$edges
# vertices    <- flare$vertices %>% arrange(name) %>% mutate(name=factor(name, name))
# connections <- flare$imports
#

edges    <- na.omit(mod$edges)%>%select(source,destination)%>%rename(from=source,to=destination)
vertices <- mod$nodes%>%arrange(Type,label)%>%select(name=label,Type,Category,plotID,label)#%>%mutate(name=factor(label, mod$nodes$label))
connections <- mod$links%>%select(source,destination)%>%rename(from=source,to=destination)
vertices$shortName<-vertices$plotID

# mutate(source=factor(source, mod$nodes$label),
#        destination=factor(destination, mod$nodes$label))%>%
#   
#   

# Preparation to draw labels properly:
 vertices$id=NA
 myleaves=which(is.na( match(vertices$name, edges$from) ))
 nleaves=length(myleaves)
 vertices$id[ myleaves ] = seq(1:nleaves)
 vertices<- vertices%>%filter(!is.na(id),!is.na(name))

vertices$angle= 90 - 360 * vertices$id / nleaves
vertices$hjust<-ifelse( vertices$angle < -90, 1, 0)
vertices$angle<-ifelse(vertices$angle < -90, vertices$angle+180, vertices$angle)

# Build a network object from this dataset:
mygraph <- graph_from_data_frame(edges, vertices = vertices)

# The connection object must refer to the ids of the leaves:
from = match( connections$from, vertices$name)
to = match( connections$to, vertices$name)

# Basic dendrogram
ggraph(mygraph, layout = 'dendrogram', circular = TRUE) + 
  geom_edge_link(size=0.9, alpha=0.1) +
  geom_node_text(aes(x = x*1.01, y=y*1.01, filter = leaf, 
                     label=shortName, 
                     angle = angle, hjust=hjust), size=1.5, alpha=1) +
  coord_fixed() +
  theme_void() +
  theme(
    legend.position="none",
    plot.margin=unit(c(0,0,0,0),"cm"),
  ) +
  expand_limits(x = c(-1.2, 1.2), y = c(-1.2, 1.2))




# Just one connection:
from_head = match( connections$from, vertices$name) %>% head(1)
to_head = match( connections$to, vertices$name) %>% head(1)

# Basic dendrogram
p1 <- ggraph(mygraph, layout = 'dendrogram', circular = TRUE) + 
  geom_edge_link(size=0.4, alpha=0.1) +
  geom_conn_bundle(data = get_con(from = from_head, to = to_head), alpha = 1, colour="#69b3a2", width=2, tension=0) + 
  geom_node_text(aes(x = x*1.01, y=y*1.01, filter = leaf, label=shortName, angle = angle, hjust=hjust), size=1.5, alpha=1) +
  coord_fixed() +
  theme_void() +
  theme(
    legend.position="none",
    plot.margin=unit(c(0,0,0,0),"cm"),
  ) +
  expand_limits(x = c(-1.2, 1.2), y = c(-1.2, 1.2))

p2 <- ggraph(mygraph, layout = 'dendrogram', circular = TRUE) + 
  geom_edge_link(size=0.4, alpha=0.1) +
  geom_conn_bundle(data = get_con(from = from_head, to = to_head), alpha = 1, colour="#69b3a2", width=2, tension=0.9) + 
  geom_node_text(aes(x = x*1.01, y=y*1.01, filter = leaf, label=shortName, angle = angle, hjust=hjust), size=1.5, alpha=1) +
  coord_fixed() +
  theme_void() +
  theme(
    legend.position="none",
    plot.margin=unit(c(0,0,0,0),"cm"),
  ) +
  expand_limits(x = c(-1.2, 1.2), y = c(-1.2, 1.2))

p1 + p2

# Just one connection:
from_head = match( connections$from, vertices$name) %>% head(1)
to_head = match( connections$to, vertices$name) %>% head(1)

# Make the plot
ggraph(mygraph, layout = 'dendrogram', circular = TRUE) + 
  geom_conn_bundle(data = get_con(from = from, to = to), alpha = 0.1, colour="#69b3a2") + 
  geom_node_text(aes(x = x*1.01, y=y*1.01, filter = leaf, label=shortName, 
                     angle = angle, hjust=hjust), size=1.5, alpha=1) +
  coord_fixed() +
  theme_void() +
  theme(
    legend.position="none",
    plot.margin=unit(c(0,0,0,0),"cm"),
  ) +
  expand_limits(x = c(-1.2, 1.2), y = c(-1.2, 1.2))

