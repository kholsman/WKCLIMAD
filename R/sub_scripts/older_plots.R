# old plots



# # all points together for fisheries
# p_fish<-  ggplot()+geom_point(data=smry_w%>%filter(focus=="fisheries"),
#                                aes(x     = magnitude,
#                                          y     = likelihood,
#                                          color = confidence),shape=16)+
#   scale_color_viridis_c()+
#   facet_grid(focus~time_period)+theme_minimal()
# 
# p_aqua <-  ggplot()+geom_point(data=smry_w%>%filter(focus=="aquaculture"),
#                                aes(x     = magnitude,
#                                          y     = likelihood,
#                                          color = confidence),shape=17)+
#   scale_color_viridis_c()+
#
# Now the top set for each focus:
#-------------------------------------------------
sub <- smry_i%>%filter(focus=="Aquaculture",time_period=="2060 - 2100")
cc  <- which(sub$likelihood>quantile(sub$likelihood)[4]&
               sub$magnitude>quantile(sub$magnitude)[4])
highest_aqua <- long_a[which(long_a$Category%in%sub[cc,]$Category_long),]
highest_aqua2 <- long_a2[which(long_a2$Category%in%sub[cc,]$Category_long),]

sub  <- smry_i%>%filter(focus=="Fisheries",time_period=="2060 - 2100")
cc   <- which(sub$likelihood>quantile(sub$likelihood)[4]&
                sub$magnitude>quantile(sub$magnitude)[4])
highest_fish  <- sub[cc,]

p_top_fish <- ggplot()+geom_point(data=smry_i%>%filter(focus=="Fisheries"),
                                  aes(x=magnitude,
                                      y=likelihood,
                                      color=confidence,
                                      shape=time_period))+
  scale_color_viridis_c()+
  facet_wrap(.~cat_wrap,nrow=4)+
  theme_minimal()+ 
  theme(strip.text = element_text(size = 5))+
  xlim(0, 10) +ylim(0,10)+ 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

sclr <-1
png("Figs/top_fish.png", 
    width = 6*sclr, height = 3*sclr, units = "in",res = 350)
print(p_top_fish)
dev.off()

p_top_aqua <- ggplot()+geom_point(data=highest_aqua,
                                  aes(x=magnitude,
                                      y=likelihood,
                                      color=confidence,
                                      shape=time_period))+
  scale_color_viridis_c()+
  facet_wrap(.~cat_wrap,nrow=2)+
  theme_minimal()+ 
  theme(strip.text = element_text(size = 5))+
  xlim(0, 10) +ylim(0,10)+ 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

png("Figs/top_aqua.png", width = 4.5*sclr, height = 3*sclr, units = "in",res = 350)
print(p_top_aqua)
dev.off()


# now plot the top five most variable (based on SE)
#-------------------------------------------------
sub <- aqua #%>%filter(time_period=="long-term")
cc  <- which(sub$likelihoodCV>quantile(sub$likelihoodCV)[4]&
               sub$magnitudeCV>quantile(sub$magnitudeCV)[4])
highest_aquaSE <- aqua[which(aqua$category%in%sub[cc,]$category),]

sub  <- fish#%>%filter(time_period=="long-term")
cc  <- which(sub$likelihoodCV>quantile(sub$likelihoodCV)[4]&
               sub$magnitudeCV>quantile(sub$magnitudeCV)[4])
highest_fishSE <- fish[which(fish$category%in%sub[cc,]$category),]

# plot the top set of fisheries 
p_top_fishSE <- ggplot(data=highest_fishSE)+
  geom_point(aes(x=magnitude,y=likelihood,
                 color=confidence,shape=time_period))+
  geom_linerange(aes(x=magnitude,y=likelihood,
                     color=confidence,ymin = ylower, ymax = yupper))+
  geom_errorbarh(aes(x=magnitude,y=likelihood,
                     color=confidence,xmin = xlower,xmax = xupper))+
  scale_color_viridis_c()+
  facet_wrap(.~cat_wrap,nrow=2)+
  theme_minimal()+ 
  theme(strip.text = element_text(size = 5))+
  xlim(0, 10) +ylim(0,10)+ 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

sclr <-1
png("Figs/top_fish_var.png",
    width = 6*sclr, height = 3*sclr, units = "in",res = 350)
print(p_top_fishSE)
dev.off()

# plot the top set of aquaculture 
p_top_aquaSE <- ggplot(data=highest_aquaSE)+
  geom_point(aes(x=magnitude,y=likelihood,
                 color=confidence,shape=time_period))+
  geom_linerange(aes(x=magnitude,y=likelihood,
                     color=confidence,ymin = ylower, ymax = yupper))+
  geom_errorbarh(aes(x=magnitude,y=likelihood,
                     color=confidence,xmin = xlower,xmax = xupper))+
  scale_color_viridis_c()+
  facet_wrap(.~cat_wrap,nrow=2)+
  theme_minimal()+ 
  theme(strip.text = element_text(size = 5))+
  xlim(0, 10) +ylim(0,10)+ 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))

png("Figs/top_aqua_var.png", width = 7*sclr, height = 3*sclr, units = "in",res = 350)
print(p_top_aquaSE)
dev.off()



# p_aqua_txt <- p_aqua + geom_text(data=sub,aes(x = magnitude,
#                                          y     = likelihood,
#                                          label = cat_wrap,
#                                          color = confidence))
# geom_text(data=smry_w,aes(x=magnitude,y=likelihood,color=mnConf,shape=focus)
sclr <-.75
png("Figs/Fig1a_aqua_byTimeFrame.png", 
    width = 8*sclr, height = 3*sclr, units = "in",res = 350)
print(p_aqua)
dev.off()
png("Figs/Fig1b_fish_byTimeFrame.png", 
    width = 8*sclr, height = 3*sclr, units = "in",res = 350)
print(p_fish)
dev.off()

p2_aqua <- ggplot()+
  geom_point(data=smry_w%>%filter(focus=="aquaculture"),
             aes(x     = magnitude,
                 y     = likelihood,
                 color = confidence,
                 shape = time_period))+
  scale_color_viridis_c()+
  facet_wrap(.~cat_wrap)+theme_minimal()+ 
  theme(strip.text = element_text(size = 5))

png("Figs/plot_all_aqua.png", 
    width = 8, height =8, units = "in",res = 350)
print(p2_aqua)
dev.off()

p2_fish <- ggplot()+geom_point(data=smry_w%>%filter(focus=="fisheries"),
                               aes(x     = magnitude,
                                   y     = likelihood,
                                   color = confidence,
                                   shape = time_period))+
  scale_color_viridis_c()+
  facet_wrap(.~cat_wrap)+theme_minimal()+
  theme(strip.text = element_text(size = 5))
png("Figs/plot_all_fish.png", 
    width = 8, height =8, units = "in",res = 350)
print(p2_fish)
dev.off()


#same plot with confidence as size of "+"
p2_fish_SD<- ggplot(data=smry_w%>%
                      filter(focus=="fisheries"))+
  geom_point(aes(x=magnitude,y=likelihood,
                 color=confidence,shape=time_period))+
  geom_linerange(aes(x=magnitude,y=likelihood,
                     color=confidence,ymin = ylower, ymax = yupper))+
  geom_errorbarh(aes(x=magnitude,y=likelihood,
                     color=confidence,xmin = xlower,xmax = xupper))+
  scale_color_viridis_c()+
  facet_wrap(.~cat_wrap)+theme_minimal()+ 
  theme(strip.text = element_text(size = 5))
png("Figs/plot_all_fish_SE.png", 
    width = 8, height =8, units = "in",res = 350)
print(p2_fish_SD)
dev.off()

#same plot with confidence as size of "+"
p2_aqua_SD<- ggplot(data=smry_w%>%
                      filter(focus=="aquaculture"))+
  geom_point(aes(x=magnitude,y=likelihood,
                 color=confidence,shape=time_period))+
  geom_linerange(aes(x=magnitude,y=likelihood,
                     color=confidence,ymin = ylower, ymax = yupper))+
  geom_errorbarh(aes(x=magnitude,y=likelihood,
                     color=confidence,xmin = xlower,xmax = xupper))+
  scale_color_viridis_c()+
  facet_wrap(.~cat_wrap)+theme_minimal()+ 
  theme(strip.text = element_text(size = 5))
png("Figs/plot_all_aqua_SE.png", 
    width = 8, height =8, units = "in",res = 350)
print(p2_aqua_SD)
dev.off()