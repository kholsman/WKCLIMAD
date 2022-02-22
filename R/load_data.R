#load_data.R
# 

# Load base files:
#----------------------
aqua_dat <- readxl::read_xlsx(file.path(data.in,"first_delphi/Aquaculture_impacts_due_to_Clim2021-09-23_19_36_33.xlsx"))
fish_dat <- readxl::read_xlsx(file.path(data.in,"first_delphi/Fisheries_impacts_due_to_Climat2021-09-23_19_35_33.xlsx"))

fsh_lkup  <- read.csv(file.path(data.in,"lkup_files/fishery_lkup.csv"))
aqua_lkup <- read.csv(file.path(data.in,"lkup_files/aqua_lkup.csv"))
adapt_aqua_lkup <- readxl::read_xlsx(file.path(data.in,"lkup_files/Adapt_lkup.xlsx"), sheet=1)
adapt_fish_lkup <- readxl::read_xlsx(file.path(data.in,"lkup_files/Adapt_lkup.xlsx"), sheet=2)

# second round:
aqua2_dat     <- readxl::read_xlsx(file.path(data.in,"second_delphi/Part_2_of_Aquaculture_impacts_d2021-12-16_17_25_36.xlsx"))
fish2_dat     <- readxl::read_xlsx(file.path(data.in,"second_delphi/Part_2_of_Fisheries_impacts_due2021-12-16_17_26_19.xlsx"))

adapt_aqua   <- readxl::read_xlsx(file.path(data.in,"second_delphi/Part_2_of_Adaptation_to_Climate2021-12-16_17_23_40.xlsx"))
adapt_fish   <- readxl::read_xlsx(file.path(data.in,"second_delphi/Part_2_of_Adaptation_to_Climate2021-12-16_17_24_16.xlsx"))
mitigat_dat  <- readxl::read_xlsx(file.path(data.in,"second_delphi/Part_2_of_Mitigation_of_Climate2021-12-16_17_25_04.xlsx"))