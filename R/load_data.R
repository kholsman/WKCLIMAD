#load_data.R
# 

# Load base files:
#----------------------
load(file.path(data.in,"SPECIES.Rdata"))
load(file.path(data.in,"surveys.Rdata"))
load(file.path(data.in,"STATION_LKUP_noObs.Rdata"))
load(file.path(data.in,"LWA_srvy.Rdata"))
load(file.path(data.in,"NODC.Rdata"))

sub_surveys     <- surveys%>%filter(SURVEY_DEFINITION_ID%in%c(98,47,52))
# region          <-  as.character(surveys[surveys$SURVEY_DEFINITION_ID==survey,][1,]$REGION[1])
# survey_name     <-  as.character(surveys[surveys$SURVEY_DEFINITION_ID==survey,][1,]$SURVEY_NAME[1])

if(  update.species_lkup) source("R/sub_scripts/make_species_lkup.R")
load(file.path(data.in,"../","species_lkup.Rdata"))
# source("R/sub_scripts/make_species_lkup.R")

# # load predator lookup table:
# load(file.path(data.in,"PREDLEN_LKUP.Rdata"))
# load(file.path(data.in,"SPECIES.Rdata"))
# load(file.path(data.in,"NODC.Rdata"))
# 
# # load mapping data:
# ebsshelf    <-  sf::st_read(file.path(MAPdata.in,"ebsshelf_all_polygon/ebsshelf_all_polygon.shp"))
# bsierp      <-  sf::st_read(file.path(MAPdata.in,"bsierp_regions/BSIERP_regions.shp"))
# limit       <-  sf::st_read(file.path(MAPdata.in,"CNTR_RG_03M_2014/CNTR_RG_03M_2014.shp"))
# world 		  <-  rnaturalearth::ne_countries(scale = "medium", returnclass = "sf") ; class(world)
# states 		  <-  rnaturalearth::ne_states(country = 'United States of America', returnclass = "sf" ) ; class(states)

# load LW data and regressions:
# load(file = file.path(data.out,"LW_SmryTable.Rdata"))
# load(file = file.path(data.out,LWname))
# load(file = file.path(data.out,LWsubname))
# 
# # load ration data:
# load(file=file.path(data.out,flname_ration))
# load(file=file.path(data.out,flsubRationname))
# 
# # load agg.prey data:
# load(file=file.path(data.out,flname))
# 
# # load bioE parms:
# load(file=file.path(data.out,"parUSE.Rdata"))
# 
# # load prey names/list
# load(file=file.path(data.out,"prey_list.Rdata"))
# 
# # load survey area:
# load(file=file.path(data.out,"area.Rdata"))
# 
# #load prey energy:agg.preyED            <-  data.frame(aggpreyWT_IN)
# PreyE  <-  read.csv(file.path(data.path,"02_Food_habits_data/../LookUpTables/PreyED_2020_USE.csv"),
#                              sep=",", header=T)
# PreyE$Prey3     <-  gsub(" ",".",PreyE$PreyE)
# PreyE$Prey2     <-  PreyE$PreyE
# 
# #load BSIERP strata lookup:
# bsierp_strata  <-  read.csv(file.path(data.path,"02_Food_habits_data/../LookUpTables/Kerim_strata.csv"),
#                     sep=",", header=T)
# # load bioenergetic parms
# par      <-  data.frame(read.csv(file.path(data.path,"02_Food_habits_data/parmsNew.csv")))
# parUSE   <-  par[match(parsp$sp,par[,1]),]
# parsp$N  <-  match(parsp$sp,parUSE$X)


