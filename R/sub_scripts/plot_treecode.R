# plot_treediag.R

# # library# install.packages("treemapify")
library(treemapify)
library(treemap)
# library(d3treeR)
# 
# library(plotly)
# 
# library(viridis)

# create a df from the meta data
cc <- tbl%>%distinct(plotID,Category,Type)
df <- tbl%>%group_by(plotID,Category)%>%summarise(freq=length(plotID))%>%
  arrange(desc(freq))

#%>%mutate(plotID=factor(plotID,plotID))


# ggplot(data=df,aes(x=plotID,y= freq,fill=factor(freq)))+
#   geom_bar(stat = "identity")
# 
# 
# 
# basic treemap

labels  = c("Eve", "Cain", "Seth", "Enos", "Noam", "Abel", "Awan", "Enoch", "Azura")
parents = c("", "Eve", "Eve", "Seth", "Seth", "Eve", "Eve", "Awan", "Eve")
values  = c(10, 14, 12, 10, 2, 6, 6, 1, 4)
fig <- plot_ly(
  type='treemap',
  labels=labels,
  parents=parents,
  values= values,
  textinfo="label+value+percent parent+percent entry+percent root",
  domain=list(column=0))
fig

df2     <-data.frame(df%>%filter(freq>1))
values  <- as.numeric(df2$freq)
labels  <- as.character(df2$plotID)
parents <- as.character(df2$Category)


fig <- plot_ly(
  type='treemap',
  labels=labels,
  parents=parents,
  values= values,
  textinfo="label+value+percent parent+percent entry+percent root",
  domain=list(column=0))
fig

p <- treemap(df%>%filter(freq>1),
             index=c("plotID"),
             vSize="freq",
             type="index",
             palette = "Set3",
             bg.labels=c("white"),
             align.labels=list(
               c("center", "center"), 
               c("right", "bottom")
             ))            
sizes <- data.frame(df%>%filter(freq>1))$freq
#display.brewer.all()
p<-ggplot(df%>%filter(freq>1),aes(area = freq, fill = freq, label = plotID)) +
  geom_treemap() +
  geom_treemap_text(colour = c("white",rep("blue4",dim(df%>%filter(freq>1))[1]-1)),
                    place = "centre",
                    size = 15) +
  scale_fill_distiller(palette = "Spectral",direction = -1)
p
if(!dir.exists("Figs/Final")) dir.create("Figs/Final")
ggsave(plot=p,filename="Figs/Final/tree.jpg", scale=2,width = 8, height = 4, units="in", dpi = 400)

# 
#  # make it interactive ("rootname" becomes the title of the plot):
# inter <- d3tree2( p ,  rootname = "General" )
# 
