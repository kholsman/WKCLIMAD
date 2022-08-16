# read in matrix
"frame8_aqua_1_1"
nm <-c("Fish_1_1",
       "Fish_1_2",
       "Fish_1_3",
       "Fish_2_1",
       "Aqua_1_1")


nn <-1


nw <- read_model (fl  = "Data/in/flow diagrams/frame 8_aquacultre_1_1.xlsx",
                       sheet_fl   = nm[nn],
                       sizeIN     = 16, 
                       NAval      = NA,
                       lkup       = "meta_data")



# # Make the Network
p <- sankeyNetwork(Links = nw$links, Nodes = nw$nodes,
                   Source = "IDsource", Target = "IDdestination",
                   Value = "value", NodeID = "label",
                   fontSize = 12, unit = "Letter(s)",
                  # nodeWidth = "weight_destination",
                   NodeGroup  = 'Type',
                   LinkGroup = "Type",
                  # LinkGroup = "Type",
                   sinksRight=FALSE)

p


# # interactive network
# network_force <- forceNetwork(Links = nw$edges_d3, 
#                               Nodes = nw$nodes_d3, 
#                               Source = "from", Target = "to", 
#                               NodeID = "label", Group = "id", 
#                               Value = "weight", 
#                               opacity = 1, fontSize = 16, zoom = TRUE)
# 
