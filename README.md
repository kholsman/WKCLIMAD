# 1. WKCLIMAD Overview

This repository contains R code and Rdata files for working with
WKCLIMAD data and responses. WKCLIMAD is an ICES workshop aimed at
exploring how can the short-, medium-, and long-term influences of
climate change on aquaculture, fisheries, and ecosystems be accounted
for in ICES Advice.

The workshop is chaired by: Mark Dickey-Collas, Kirstin Kari Holsman,
and Michael Rust. More information can be found
here:<https://www.ices.dk/community/groups/Pages/WKCLIMAD.aspx>

## Summary:

As managers, policy-makers, and other stakeholders become increasingly
aware of the need to consider climate impacts, this workshop will
develop a proposal for an operational climate-aware advisory framework.
Experts are invited to join WKCLIMAD to review the recent and emergent
analyses of key climate hazards to aquaculture, fisheries, and
ecosystems.

The workshop will outline actionable strategies and approaches that can
be taken to promote resiliency in fisheries, aquaculture, and
ecosystems. It will scope the next steps for an operational approach,
expanding the relevant aspects of climate change that impact management
decisions in fisheries, aquaculture and ecosystems.

The kick off meeting will take place on the 21 June 2021, and
participants will work via correspondence prior to the online meetings
taking place 29–30 September and 18–20 October 2021.

Registration is now closed. Selected participants will be announced by
15 June 2021.

We expect this to be a popular workshop and therefore may have to limit
the number of participants. If the workshop is oversubscribed, ICES
reserves the right, in consultation with the workshop chairs, to select
the final workshop participants based on their expertise, and equitable
makeup of the workshop.

# 2. Code overview

In August 2021 multiple experts provided a rapid assessment of climate
impacts via a Delphi approach. The code below analyses the output from
that activity and produces the plots and results summarized in the
WKCLIMAD report. The code below will generate the following plot:

<figure>
<img src="Figs/Fig1.png" style="width:65.0%" alt="Results of the first round of Delphi surveys." /><figcaption aria-hidden="true">Results of the first round of Delphi surveys.</figcaption>
</figure>

``` r
   # loads packages, data, setup, etc.
    suppressWarnings(source("R/make.R"))
    
    # reshape the data into long-format:
    # --------------------------------------
    long_a <- getData(aqua_dat)
    long_f <- getData(fish_dat)
    long_a$focus <- "aquaculture"
    long_f$focus <- "fisheries"
    
    # combine into single long format:
    long <- rbind(long_a,long_f)
    
    # summarize across participants:
    smry <- long%>%group_by(focus,category,time_period,type)%>%summarise(
      mn = mean(value.x,na.rm=T),
      sd = sd (value.x,na.rm=T),
      n  = length(value.x),
      median = median(value.x,na.rm=T),
      mn_conf = mean(conf_n,na.rm=T),
      sd_conf = sd(conf_n,na.rm=T),
      median_conf = median(conf_n,na.rm=T))
    smry$type <- factor(smry$type)
    
    # split mag and likelihood into columns:
    smry_w    <- tidyr::spread(smry%>%
                                 select(focus,time_period,category,type, mn), 
                               key = type, value = mn)
    smry_conf <- tidyr::spread(smry%>%
                                 select(focus,time_period,category,type, mn_conf), 
                               key = type, value = mn_conf)
    smry_conf$mnConf <- apply(smry_conf[,c("likelihood","magnitude")],1,mean)
    
    smry_w <- merge(smry_w, smry_conf%>%
                      select(focus,time_period,category, mnConf),
                    by=c("focus","time_period","category"))

   p <-  ggplot()+geom_point(data=smry_w,aes(x     = magnitude,
                                             y     = likelihood,
                                             color = mnConf,
                                             shape = focus))+
      scale_color_viridis_c()+
      facet_grid(focus~time_period)+theme_minimal()
     
    # geom_text(data=smry_w,aes(x=magnitude,y=likelihood,color=mnConf,shape=focus)
    sclr <-.75
    png("Figs/Fig1.png", width = 8*sclr, height = 4.5*sclr, units = "in",res = 350)
    print(p)
    dev.off()
    
  p2 <- ggplot()+geom_point(data=smry_w,
                            aes(x=magnitude,y=likelihood,color=mnConf,shape=focus))+
      scale_color_viridis_c()+
      facet_wrap(focus~category)+theme_minimal()
       
    png("Figs/Fig2.png", width = 8, height =8, units = "in",res = 350)
    print(p2)
    dev.off()
   
    datIN      <- aqua_dat
   # add type (and range)
```
