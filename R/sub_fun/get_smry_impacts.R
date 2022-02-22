

# summarize across participants:

get_smry_impacts <- function(dat = long_f2,Sector2 = "Fisheries", mult = 1.95){
  
  smry <- dat%>%group_by(Sector,Category,LM,time_period)%>%summarise(
    mn = mean(value.x,na.rm=T),
    sd = sd (value.x,na.rm=T),
    n  = length(value.x),
    median = median(value.x,na.rm=T),
    mn_conf = mean(conf_n,na.rm=T),
    sd_conf = sd(conf_n,na.rm=T),
    median_conf = median(conf_n,na.rm=T))
  
  smry<-smry%>%mutate(se = sd/sqrt(n))
  smry$LM <- factor(smry$LM)
  
  # split mag and likelihood into columns:
  smry_w    <- tidyr::spread(smry%>%
                               select(Sector,time_period,Category,LM, mn), 
                             key = LM, value = mn)
  smry_wse    <- tidyr::spread(smry%>%
                                 select(Sector,time_period,Category,LM, se), 
                               key = LM, value = se)
  smry_wse    <- smry_wse%>%rename(likelihoodSE=likelihood,magnitudeSE=magnitude)
  smry_wsd    <- tidyr::spread(smry%>%
                                 select(Sector,time_period,Category,LM, sd), 
                               key = LM, value = sd)
  smry_wsd    <- smry_wsd%>%rename(likelihoodSD=likelihood,magnitudeSD=magnitude)
  smry_w <- merge(smry_w,smry_wse,
                  by=c("Sector","time_period","Category"))
  smry_w <- merge(smry_w,smry_wsd,
                  by=c("Sector","time_period","Category"))
  smry_conf <- tidyr::spread(smry%>%
                               select(Sector,time_period,Category,LM, mn_conf), 
                             key = LM, value = mn_conf)
  smry_conf$mnConf <- apply(smry_conf[,c("likelihood","magnitude")],1,mean)
  
  smry_w <- merge(smry_w, smry_conf%>%
                    select(Sector,time_period,Category, mnConf),
                  by=c("Sector","time_period","Category"))
  smry_w$likelihoodCV <- 100*smry_w$likelihoodSD/smry_w$likelihood
  smry_w$magnitudeCV  <- 100*smry_w$magnitudeSD/smry_w$magnitude
  smry_w$Category <- gsub("Change in ", "", smry_w$Category)
  smry_w$Category <- gsub("Changes in ", "", smry_w$Category)
  smry_w$Category <- gsub("Changes to ", "", smry_w$Category)
  smry_w$cat_wrap <- stringr::str_wrap(smry_w$Category, width=30)
  
  smry_w$ylower <- smry_w$likelihood-mult*smry_w$likelihoodSE
  smry_w$yupper <- smry_w$likelihood+mult*smry_w$likelihoodSE
  smry_w$xlower <- smry_w$magnitude-mult*smry_w$magnitudeSE
  smry_w$xupper <- smry_w$magnitude+mult*smry_w$magnitudeSE
  
  
  smry_w$confidence   <- smry_w$mnConf
  smry_w$uncertainty  <- smry_w$mnConf^-1
  smry_w$Sector       <- factor(smry_w$Sector)
  smry_w$Sector2      <- Sector2
  
  return(smry_w = smry_w)
}

