#install.packages("networkD3")
#install.packages("curl")

# Load package
library(networkD3)
library(curl)
library(networkD3)

seaweed_links = seaweed_links_v2
seaweed_names= seaweed_names_v2

#seaweed sankey
seaweed_links$Source = as.integer(seaweed_links$Source)
seaweed_links$Target = as.integer(seaweed_links$Target)
seaweed_links$Value = as.numeric(seaweed_links$Value)

seaweed_links$Source=seaweed_links$Source-1
seaweed_links$Target=seaweed_links$Target-1

g = sankeyNetwork(Links = seaweed_links, Nodes = seaweed_names, Source = "Source",
                  Target = "Target", Value = "Value", NodeID = "name",
                  units = "Count", fontSize = 12, nodeWidth = 30, NodeGroup = 0, iterations = 0)
g                   

#finfish sankey
finfish_links$Source = as.integer(finfish_links$Source)
finfish_links$Target = as.integer(finfish_links$Target)
finfish_links$Value = as.numeric(finfish_links$Value)

finfish_links$Source=finfish_links$Source-1
finfish_links$Target=finfish_links$Target-1

h = sankeyNetwork(Links = finfish_links, Nodes = finfish_names, Source = "Source",
                  Target = "Target", Value = "Value", NodeID = "name",
                  units = "Count", fontSize = 12, nodeWidth = 30, NodeGroup = 0, iterations = 0)
h 

#shellfish sankey
shellfish_links$Source = as.integer(shellfish_links$Source)
shellfish_links$Target = as.integer(shellfish_links$Target)
shellfish_links$Value = as.numeric(shellfish_links$Value)

shellfish_links$Source=shellfish_links$Source-1
shellfish_links$Target=shellfish_links$Target-1

j = sankeyNetwork(Links = shellfish_links, Nodes = shellfish_names, Source = "Source",
                  Target = "Target", Value = "Value", NodeID = "name",
                  units = "Count", fontSize = 12, nodeWidth = 30, NodeGroup = 0, iterations = 0)
j 
