#'
#'
#'updateNeworks.R
#'
#'
# loads packages, data, setup, etc.
# suppressWarnings(source("R/make.R"))
for(nn in 1:length(models)){
  nw <- suppressMessages( read_model (fl  = "Data/in/flow diagrams/mentalmodels",
                                      model   = models[nn],
                                      sizeIN     = 16, 
                                      NAval      = NA,
                                      lkup       = "../Day5_MetaData.xlsx",
                                      lkup_Sheet_adapt ="meta_data"))
  
  nw$nodes$model <- models[nn]
  nw$links$model <- models[nn]
  nw$edges$model <- models[nn]
  if(nn ==1){
    edges_all <- nw$edges
    links_all <- nw$links
    nodes_all <- nw$nodes
  }else{
    edges_all <- rbind(edges_all,nw$edges)
    links_all <- rbind(links_all,nw$links)
    nodes_all <- rbind(nodes_all,nw$nodes)
  }
  
  eval(parse(text= paste0(models[nn],"<-nw")))
  eval(parse(text= paste0("save(",models[nn],", file =
                          file.path(data.models,paste0(models[nn],'.Rdata')))")))

  rm(nw)
}
save(links_all, file = file.path(data.models,'links_all.Rdata'))
save(nodes_all, file = file.path(data.models,'nodes_all.Rdata'))
save(edges_all, file = file.path(data.models,'edges_all.Rdata'))
mod      <- Fish_2_3
tbl      <- mod$tbl
tbl_meta <- mod$tbl_meta
save(tbl_meta, file = file.path(data.models,'tbl_meta.Rdata'))
save(tbl, file = file.path(data.models,'/tbl.Rdata'))
