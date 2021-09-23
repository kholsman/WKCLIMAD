#'
#' getData.R
#' 
#' This script converts the survey data into a R 
#' data.frame for plotting and analysis
#' 

getData <- function(datIN){
    peeps    <- datIN$Email
    np       <- length(peeps)
    cca      <- grep(" >> ",as.character(colnames(datIN)))
    conf     <- grep(">> Confidence",as.character(colnames(datIN)))
    tmp      <- strsplit(colnames(datIN)[cca]," >> ")
    cats     <- unlist(tmp)[seq(1,length(tmp),2)]
    cat      <- unique(cats)
    nc       <- length(cat)
    types    <- c(1:10,"Confidence", "Other Thoughts")
    rmcc       <- grep( " >> Confidence", colnames(datIN))
    rmcc_n     <- grep( " >> Other Thoughts", colnames(datIN))
    rmcc_a     <- grep("Please", colnames(datIN))
    rmcc_b     <- grep("No Label", colnames(datIN))
    
    # convert wide format to long for values:
    long_dat   <- melt(datIN[,-c(rmcc,rmcc_n,rmcc_a,rmcc_b)], 
                       id.vars=c('Submission Date', "Email",'First Name', 'Last Name'))
    long_dat$value    <- as.numeric(long_dat$value)
    tmp               <- strsplit(as.character(long_dat$variable), split = " >> ")
    long_dat$category <- sapply(tmp, "[[", 1)
    long_dat$time_period <-factor(
      rep(c(rep("short-term",(length(types)-2)*length(cat)*length(peeps)),
            rep("medium-term",(length(types)-2)*length(cat)*length(peeps)),
            rep("long-term",(length(types)-2)*length(cat)*length(peeps))),2),levels = c("short-term","medium-term","long-term"))
    long_dat$type <-
      c(rep("likelihood",(length(types)-2)*length(cat)*length(peeps)*3),
        rep("magnitude",(length(types)-2)*length(cat)*length(peeps)*3))
    
    long_dat2   <- long_dat[which(!is.na(long_dat$value)),]
    
    # convert confidence wide format to long:
    long_conf  <- melt(datIN[,c(1:4,rmcc)], 
                       id.vars=c('Submission Date', "Email",'First Name', 'Last Name'))
    tmp        <- strsplit(as.character(long_conf$variable), split = " >>")
    long_conf$category <- sapply(tmp, "[[", 1)
    long_conf$time_period <-factor(
      rep(c(rep("short-term",length(cat)*length(peeps)),
            rep("medium-term",length(cat)*length(peeps)),
            rep("long-term",length(cat)*length(peeps))),2),levels = c("short-term","medium-term","long-term"))
    long_conf$type <-
      c(rep("likelihood",length(cat)*length(peeps)*3),
        rep("magnitude",length(cat)*length(peeps)*3))
    
    # merge values and confidence into one dataframe:
    long <- merge(long_dat2,long_conf,by=c('Submission Date', "Email",
                                           'First Name', 'Last Name',
                                           "category","time_period","type"))
    
    lvls <- c("Low  - My opinion",
              "Medium low - My opinion and some data",
              "Medium - Some data and publications by others",
              "Medium High - My own data, and publications by others",
              "High - My own data and publications")            
    long$value.y <- factor(long$value.y, levels = lvls)
    long$conf_n <- as.numeric(long$value.y)
    return(long)
}