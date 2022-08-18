# read in matrix
"frame8_aqua_1_1"
nm <-c("Fish_1_1",
       "Fish_1_2",
       "Fish_1_3",
       "Fish_2_1",
       "Fish_2_2",
       "Fish_2_3",
       "Aqua_1_1")


nn <-3

for(nn in 1:length(nm)){
  nw <- suppressMessages( read_model (fl  = "Data/in/flow diagrams/Day5_ToolWebs.xlsx",
                         sheet_fl   = nm[nn],
                         sizeIN     = 16, 
                         NAval      = NA,
                         lkup       = "meta_data"))
  if(!dir.exists("Data/out/snakeymodels")) dir.create("Data/out/snakeymodels")
  
  eval(parse(text= paste0(nm[nn],"<-nw")))
  
  eval(parse(text= paste0("save(",nm[nn],", file = 
                                 file.path('Data/out/snakeymodels/',
                                           paste0(nm[nn],'.Rdata')))")))
}

# # Make the Network
p <- sankeyNetwork(Links = nw$links, Nodes = nw$nodes,
                   Source = "IDsource", Target = "IDdestination",
                   Value = "value", NodeID = "label",
                   fontSize = 12, unit = "Letter(s)",
                  # nodeWidth = "weight_destination",
                   NodeGroup  = 'Category',
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
