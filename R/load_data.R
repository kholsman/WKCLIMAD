#load_data.R
# 
source("R/packages.R")       # loads packages
source("R/setup.R")          # load other switches and controls
source("R/load_functions.R") # defines the create_plot() function

# Load base files:
#----------------------
aqua_dat <- suppressMessages(readxl::read_xlsx(file.path(data.in,"first_delphi/Aquaculture_impacts_due_to_Clim2021-09-23_19_36_33.xlsx")))
fish_dat <- suppressMessages(readxl::read_xlsx(file.path(data.in,"first_delphi/Fisheries_impacts_due_to_Climat2021-09-23_19_35_33.xlsx")))

fsh_lkup  <- suppressMessages(read.csv(file.path(data.in,"lkup_files/fishery_lkup.csv")))
aqua_lkup <- suppressMessages(read.csv(file.path(data.in,"lkup_files/aqua_lkup.csv")))
adapt_aqua_lkup <-suppressMessages(readxl::read_xlsx(file.path(data.in,"lkup_files/Adapt_lkup.xlsx"), sheet=1))
adapt_fish_lkup <- suppressMessages(readxl::read_xlsx(file.path(data.in,"lkup_files/Adapt_lkup.xlsx"), sheet=2))
mitigat_lkup <- suppressMessages(readxl::read_xlsx(file.path(data.in,"lkup_files/Mitigat_lkup.xlsx"), sheet=1))

# second round:
aqua2_dat     <- suppressMessages(readxl::read_xlsx(file.path(data.in,"second_delphi/Part_2_of_Aquaculture_impacts_d2021-12-16_17_25_36.xlsx")))
fish2_dat     <- suppressMessages(readxl::read_xlsx(file.path(data.in,"second_delphi/Part_2_of_Fisheries_impacts_due2021-12-16_17_26_19.xlsx")))

adapt_aqua   <- suppressMessages(readxl::read_xlsx(file.path(data.in,"second_delphi/Part_2_of_Adaptation_to_Climate2021-12-16_17_23_40.xlsx")))
adapt_fish   <- suppressMessages(readxl::read_xlsx(file.path(data.in,"second_delphi/Part_2_of_Adaptation_to_Climate2021-12-16_17_24_16.xlsx")))
mitigat_dat  <- suppressMessages(readxl::read_xlsx(file.path(data.in,"second_delphi/fixed_Part_2_of_Mitigation_of_Climate2021-12-16_17_25_04.xlsx")))

# update newtwork models Rdata

if(update.network.data)
  source("R/sub_scripts/updateNetworks.R")

#----------------------
load(file = file.path(data.models,'links_all.Rdata'))
load(file = file.path(data.models,'nodes_all.Rdata'))
load(file = file.path(data.models,'edges_all.Rdata'))
load(file = file.path(data.models,'tbl_meta.Rdata'))
load(file = file.path(data.models,'/tbl.Rdata'))

