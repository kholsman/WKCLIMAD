# read in matrix
# loads packages, data, setup, etc.
suppressWarnings(source("R/make.R"))
nn <-3


# create combined network:
mod <-models[5]

plot_Sankey(mod)
# install.packages("remotes")
# remotes::install_github("davidsjoberg/ggsankey")
library(ggsankey)

df <- mod$df


df<- mod$nodes%>%select(Type,label,id)%>%
  pivot_wider(names_from = Type, values_from = id, values_fill =NA)
eval(parse(text = paste0("df<- df%>%make_long(",paste0("'",unique(na.omit(mod$nodes$Type)),"'",collapse=","),")")))
coll <- mod$nodes$Type[df$node]

df<- mod$nodes%>%select(Type,label,id)%>%
  pivot_wider(names_from = Type, values_from = id, values_fill = 0)
eval(parse(text = paste0("df<- df%>%make_long(",paste0("'",unique(na.omit(mod$nodes$Type)),"'",collapse=","),")")))


# df <- mtcars %>%
#   make_long(cyl, vs, am, gear, carb)
# 
p2<- ggplot(df, aes(x = x, 
               next_x = next_x, 
               node = node, 
               next_node = next_node,
               fill = factor(coll),
               label = node)) +
  geom_sankey(flow.alpha = 0.5, node.color = 1) +
  geom_sankey_label(size = 3.5, color = 1, fill = "white") +
  scale_fill_viridis_d() +
  theme_sankey(base_size = 16) +
  guides(fill = guide_legend(title = "Title"))

# # interactive network
# network_force <- forceNetwork(Links = nw$edges_d3, 
#                               Nodes = nw$nodes_d3, 
#                               Source = "from", Target = "to", 
#                               NodeID = "label", Group = "id", 
#                               Value = "weight", 
#                               opacity = 1, fontSize = 16, zoom = TRUE)
# 
#https://www.data-to-viz.com/graph/edge_bundling.html
ggraph(mygraph, layout = 'dendrogram', circular = TRUE) + 
  geom_conn_bundle(data = get_con(from = from, to = to), alpha = 0.1, colour="#69b3a2") + 
  geom_node_text(aes(x = x*1.01, y=y*1.01, filter = leaf, label=shortName, angle = angle, hjust=hjust), size=1.5, alpha=1) +
  coord_fixed() +
  theme_void() +
  theme(
    legend.position="none",
    plot.margin=unit(c(0,0,0,0),"cm"),
  ) +
  expand_limits(x = c(-1.2, 1.2), y = c(-1.2, 1.2))


graph <- graph %>% 
  activate(edges) %>% 
  filter(weight > 0.05)



# https://aurelien-goutsmedt.com/fr/post/extracting-biblio-data-2/#ref-smets2007a
ggraph(graph, "manual", x = x, y = y) + 
  geom_edge_arc0(aes(color = color_edges, width = weight), alpha = 0.4, strength = 0.2, show.legend = FALSE) +
  scale_edge_width_continuous(range = c(0.1,2)) +
  scale_edge_colour_identity() +
  geom_node_point(aes(x=x, y=y, size = size, fill = color), pch = 21, alpha = 0.7, show.legend = FALSE) +
  scale_size_continuous(range = c(0.3,16)) +
  scale_fill_identity() +
  ggnewscale::new_scale("size") +
  ggrepel::geom_text_repel(data = top_nodes, aes(x=x, y=y, label = Label), size = 2, fontface="bold", alpha = 1, point.padding=NA, show.legend = FALSE) +
  ggrepel::geom_label_repel(data = community_labels, aes(x=x, y=y, label = Community_name, fill = color), size = 6, fontface="bold", alpha = 0.9, point.padding=NA, show.legend = FALSE) +
  scale_size_continuous(range = c(0.5,5)) +
  theme_void()