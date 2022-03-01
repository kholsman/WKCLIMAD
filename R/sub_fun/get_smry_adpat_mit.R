

# summarize across participants:

get_smry_adapt_mit <- function(dat = long_f2,focus="",Sector2 = "Fisheries", mult = 1.95){
  
  smry <- dat%>%group_by(Group, Label,Category,category,LM)%>%summarise(
    mn = mean(value,na.rm=T),
    sd = sd (value,na.rm=T),
    n  = length(value),
    median = median(value,na.rm=T),
    mn_conf = mean(conf_n,na.rm=T),
    sd_conf = sd(conf_n,na.rm=T),
    median_conf = median(conf_n,na.rm=T),
    mn_timeframe = mean(timeframe_n,na.rm=T),
    sd_timeframe = sd(timeframe_n,na.rm=T),
    median_timeframe = median(timeframe_n,na.rm=T)
    )
  
  smry<-smry%>%mutate(se = sd/sqrt(n))
  smry$LM <- factor(smry$LM)
  
  # split mag and likelihood into columns:
  smry_w    <- tidyr::spread(smry%>%
                               select(Group, Label,Category,category,LM, mn), 
                             key = LM, value = mn)
  smry_wse    <- tidyr::spread(smry%>%
                                 select(Group, Label,Category,category,LM, se), 
                               key = LM, value = se)
  smry_wse    <- smry_wse%>%rename(likelihoodSE=likelihood,magnitudeSE=magnitude)
  smry_wsd    <- tidyr::spread(smry%>%
                                 select(Group, Label,Category,category,LM, sd), 
                               key = LM, value = sd)
  smry_wsd    <- smry_wsd%>%rename(likelihoodSD=likelihood,magnitudeSD=magnitude)
  smry_w <- merge(smry_w,smry_wse,
                  by=c("Group", "Label","Category","category"))
  smry_w <- merge(smry_w,smry_wsd,
                  by=c("Group","Label","Category","category"))
  smry_conf <- tidyr::spread(smry%>%
                               select(Group, Label,Category,category,LM, mn_conf), 
                             key = LM, value = mn_conf)
  smry_conf$mnConf <- apply(smry_conf[,c("likelihood","magnitude")],1,mean)
  
  smry_w <- merge(smry_w, smry_conf%>%
                    select(Group, Label,Category,category, mnConf),
                  by=c("Group","Label","Category","category"))
  
  
  smry_timeframe <- tidyr::spread(smry%>%
                               select(Group, Label,Category,category,LM, mn_timeframe), 
                             key = LM, value = mn_timeframe)
  smry_timeframe$mntimeframe <- apply(smry_timeframe[,c("likelihood","magnitude")],1,mean)
  
  smry_w <- merge(smry_w, smry_timeframe%>%
                    select(Group, Label,Category,category, mntimeframe),
                  by=c("Group","Label","Category","category"))
  
  smry_w$likelihoodCV <- 100*smry_w$likelihoodSD/smry_w$likelihood
  smry_w$magnitudeCV  <- 100*smry_w$magnitudeSD/smry_w$magnitude
  smry_w$Category <- gsub("Change in ", "", smry_w$Category)
  smry_w$Category <- gsub("Changes in ", "", smry_w$Category)
  smry_w$Category <- gsub("Changes to ", "", smry_w$Category)
  smry_w$cat_wrap <- stringr::str_wrap(smry_w$category, width=30)
  
  smry_w$ylower <- smry_w$likelihood-mult*smry_w$likelihoodSE
  smry_w$yupper <- smry_w$likelihood+mult*smry_w$likelihoodSE
  smry_w$xlower <- smry_w$magnitude-mult*smry_w$magnitudeSE
  smry_w$xupper <- smry_w$magnitude+mult*smry_w$magnitudeSE
  
  
  smry_w$confidence   <- smry_w$mnConf
  smry_w$uncertainty  <- smry_w$mnConf^-1
  smry_w$Label        <- factor(smry_w$Label)
  smry_w$Group        <- factor(smry_w$Group)
  smry_w$Sector2      <- Sector2
  smry_w$focus        <- focus
  
  return(smry_w = smry_w)
}

