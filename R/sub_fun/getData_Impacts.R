#'
#'getData_Impacts.R
#' 
#' This script converts the survey data into a R 
#' data.frame for plotting and analysis
#' 

getData_Impacts <- function(datIN,
                    LM  = c("likelihood","magnitude"),
                    time_period  = c("2021 - 2040", "2041 - 2060", "2060 - 2100"),
                    Sector  = c("Aquaculture"),
                    lvls  = c("Low  - My opinion",
                              "Medium low - My opinion and some data",
                              "Medium - Some data and publications by others",
                              "Medium High - My own data, and publications by others",
                              "High - My own data and publications"),
                    rmMeanScore = F, 
                    splitIN = "\t",
                    adjIN = 0){
  
  
    datIN$ID <- 1:dim(datIN)[1]
    peeps    <- datIN$Email
    np       <- length(peeps)
    cca      <- grep(" >> ",as.character(colnames(datIN)))
    conf     <- grep(">> Confidence",as.character(colnames(datIN)))
    tmp      <- strsplit(colnames(datIN)[cca]," >> ")
    types    <- c(1:10,"Confidence", "Other Thoughts")
    lab_c    <- match(c('ID','Submission Date', "Email",'First Name', 'Last Name'), colnames(datIN))
    rmcc     <- grep( " >> Confidence", colnames(datIN))
    rmcc_n   <- grep( " >> Other Thoughts", colnames(datIN))
    
    rmcc_a     <- grep("Please", colnames(datIN))
    rmcc_b     <- grep("No Label", colnames(datIN))
    rmcc_byu   <- grep("Review Before Submit", colnames(datIN))
    
    # convert wide format to long for values:
    long_dat   <- melt(datIN[,-c(rmcc,rmcc_n,rmcc_a,rmcc_b,rmcc_byu)], 
                       id.vars=c('ID','Submission Date', "Email",'First Name', 'Last Name'))
    long_dat$value    <- as.numeric(long_dat$value)
    tmp               <- strsplit(as.character(long_dat$variable), split = " >> ")
    long_dat$category <- sapply(tmp, "[[", 1)
    
    # remove the "mean score text"
    if(rmMeanScore){
      subtmp            <- grep(splitIN,as.character(long_dat$variable) )
      tmp               <- strsplit(as.character(long_dat$variable), split = splitIN)
      tmp               <- sapply(tmp, "[[", 1)
      long_dat$category <- tmp
    }
    long_dat$category <- substr(long_dat$category , start =1,stop = nchar(long_dat$category)-adjIN)
    cats     <- long_dat$category
    catgry   <- unique(cats)
    nc       <- length(catgry)
    
    mat         <- expand.grid(email2   = peeps,
                               type     = 1:10,
                               Category = catgry,
                               time_period = time_period,
                               LM       = LM, 
                               Sector   = Sector)
    long_dat2   <- cbind(long_dat,mat)
    long_dat2   <- long_dat2[which(!is.na(long_dat2$value)),]
    # long_dat$time_period <-factor(
    #   rep(c(rep("short-term",(length(types)-2)*length(catgry)*length(peeps)),
    #         rep("medium-term",(length(types)-2)*length(catgry)*length(peeps)),
    #         rep("long-term",(length(types)-2)*length(catgry)*length(peeps))),2),levels = c("short-term","medium-term","long-term"))
    # long_dat$type <-
    #   c(rep("likelihood",(length(types)-2)*length(catgry)*length(peeps)*3),
    #     rep("magnitude",(length(types)-2)*length(catgry)*length(peeps)*3))
    # 
   
    
    # convert confidence wide format to long:
    long_conf  <- melt(datIN[,c(lab_c,rmcc)], 
                       id.vars=c('ID','Submission Date', "Email",'First Name', 'Last Name'))
    tmp        <- strsplit(as.character(long_conf$variable), split = " >>")
    long_conf$category <- sapply(tmp, "[[", 1)
    if(rmMeanScore){
      subtmp            <- grep(splitIN,as.character(long_conf$variable) )
      tmp               <- strsplit(as.character(long_conf$variable), split = splitIN)
      tmp               <- sapply(tmp, "[[", 1)
      long_conf$category <- tmp
    }
    long_conf$category <- substr(long_conf$category, start =1,stop = nchar(long_conf$category)-adjIN)

    cats     <- long_conf$category
    catgry   <- unique(cats)
    nc       <- length(catgry)

    mat         <- expand.grid(email2   = peeps,
                               Category = catgry,
                               time_period = time_period,
                               LM       = LM, 
                               Sector   = Sector)
    long_conf2   <- cbind(long_conf,mat)
    #long_conf2   <- long_conf2[which(!is.na(long_conf2$value)),]

    # long_conf$time_period <-factor(
    #   rep(c(rep("short-term",length(catgry)*length(peeps)),
    #         rep("medium-term",length(catgry)*length(peeps)),
    #         rep("long-term",length(catgry)*length(peeps))),2),levels = c("short-term","medium-term","long-term"))
    # long_conf$type <-
    #   c(rep("likelihood",length(catgry)*length(peeps)*3),
    #     rep("magnitude",length(catgry)*length(peeps)*3))
    
    # merge values and confidence into one dataframe:
    long <- merge(long_dat2,long_conf2,by=c("ID","Submission Date","Email","First Name","Last Name",
                                            "category","email2",       
                                            "Category","Sector","LM","time_period"    ))
    
    long$value.y <- factor(long$value.y, levels = lvls)
    long$conf_n <- as.numeric(long$value.y)
    return(long)
}