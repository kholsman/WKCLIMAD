#load_data.R
# 

# Load base files:
#----------------------
aqua_dat <- readxl::read_xlsx(file.path(data.in,"Aquaculture_impacts_due_to_Clim2021-09-23_19_36_33.xlsx"))
fish_dat <- readxl::read_xlsx(file.path(data.in,"Fisheries_impacts_due_to_Climat2021-09-23_19_35_33.xlsx"))

fsh_lkup <- read.csv(file.path(data.in,"fishery_lkup.csv"))
aqua_lkup <- read.csv(file.path(data.in,"aqua_lkup.csv"))

                     