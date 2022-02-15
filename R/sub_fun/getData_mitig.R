#'
#' getData_mitig.R
#' 
#' This script converts the survey data into a R 
#' data.frame for plotting and analysis
#' 

getData_mitig <- function(datIN,adjIN = 4){
  peeps    <- datIN$Email
  np       <- length(peeps)
  cca      <- grep(" >> ",as.character(colnames(datIN)))
  timeframe<- grep(">> Time Frame",as.character(colnames(datIN)))
  conf     <- grep(">> Confidence",as.character(colnames(datIN)))
  tmp      <- strsplit(colnames(datIN)[cca]," >> ")
  types    <- c(1:10,"Confidence", "Other Thoughts")
  lab_c    <- match(c('Submission Date', "Email",'First Name', 'Last Name'), colnames(datIN))
  rmtime   <- grep( "Time Frame", colnames(datIN))
  rmcc     <- grep( "Confidence", colnames(datIN))
  rmcc_n   <- grep( "Other Thoughts", colnames(datIN))
  
  rmcc_a     <- grep("Please", colnames(datIN))
  rmcc_b     <- grep("No Label", colnames(datIN))
  rmcc_byu   <- grep("Review Before Submit", colnames(datIN))
  rmcc_last  <- grep("or make any comments below:", colnames(datIN))
  
  # convert wide format to long for values:
  long_dat   <- melt(datIN[,-c(rmtime,rmcc,rmcc_n,rmcc_a,rmcc_b,rmcc_byu,rmcc_last)], 
                     id.vars=c('Submission Date', "Email",'First Name', 'Last Name'))
  long_dat$value    <- as.numeric(long_dat$value)
  tmp               <- strsplit(as.character(long_dat$variable), split = ">>")
  long_dat$category <- sapply(tmp, "[[", 1)
  long_dat$category <- substr(long_dat$category , start =1,stop = nchar(long_dat$category)-adjIN)
  cats     <- long_dat$category
  catgry   <- unique(cats)
  nc       <- length(catgry)
  
  long_dat$type <-
    c(rep("likelihood",(length(types)-2)*length(catgry)*length(peeps)),
      rep("magnitude",(length(types)-2)*length(catgry)*length(peeps)))
  
  long_dat2   <- long_dat[which(!is.na(long_dat$value)),]
  
  
  # convert confidence wide format to long:
  long_conf  <- melt(datIN[,c(lab_c,rmcc)], 
                     id.vars=c('Submission Date', "Email",'First Name', 'Last Name'))
  tmp        <- strsplit(as.character(long_conf$variable), split = ">>")
  long_conf$category <- sapply(tmp, "[[", 1)
  long_conf$category <- substr(long_conf$category, start =1,stop = nchar(long_conf$category)-adjIN)
  long_conf$type <-
    c(rep("likelihood",length(catgry)*length(peeps)),
      rep("magnitude",length(catgry)*length(peeps)))
  
  # merge values and confidence into one dataframe:
  long <- merge(long_dat2,long_conf,by=c('Submission Date', "Email",
                                         'First Name', 'Last Name',
                                         "category","type"))
  
  lvls <- c("Low  - My opinion",
            "Medium low - My opinion and some data",
            "Medium - Some data and publications by others",
            "Medium High - My own data, and publications by others",
            "High - My own data and publications")            
  long$value.y <- factor(long$value.y, levels = lvls)
  long$conf_n <- as.numeric(long$value.y)
  
  # convert timeperiod wide format to long:
  long_time  <- melt(datIN[,c(lab_c,rmtime)], 
                     id.vars=c('Submission Date', "Email",'First Name', 'Last Name'))
  tmp        <- strsplit(as.character(long_time$variable), split = ">>")
  long_time$category <- sapply(tmp, "[[", 1)
  long_time$category <- substr(long_time$category, start =1,stop = nchar(long_time$category)-adjIN)
  long_time$type <-
    c(rep("likelihood",length(catgry)*length(peeps)),
      rep("magnitude",length(catgry)*length(peeps)))
  
  # merge values and confidence into one dataframe:
  long <- merge(long,long_time,by=c('Submission Date', "Email",
                                    'First Name', 'Last Name',
                                    "category","type"))
  
  
  lvls <- c("Now",
            "In the next 20 years",
            "After 2041 but before 2060",
            "After 2061")            
  long$value <- factor(long$value, levels = lvls)
  long$timeframe_n <- as.numeric(long$value.y)
  
  
  return(long)
}

# 
# FUN <- function(x){
#   out <- lapply(1:length(x), function(i) {
#    length(which(long_dat$category==x[i]))
#   })
#   unlist(out)
# }
# 
# Z <- unlist(sapply(catgry, FUN))
# 
# 
# sapply(Z, `[[`, "count")
# 
# FUN <- function(x){
#   count.occurances <- 0
#   lapply(1:length(x), function(i) {
#     y <- x[i]
#     if (y %% 2 == 0){
#       count.occurances <<- count.occurances + 1
#     }
#     print("do something")
#   })
#   list(guy="x", count=count.occurances)
# }
# 
# Z <- lapply(list(1:10, 1:3, 11:16, 9), FUN) 
# 
