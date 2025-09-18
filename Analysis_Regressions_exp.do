/********************************************************************
  EXACT-MATCH MASTER DO-FILE
  --------------------------
  • Three samples  :  NR  SR  SRO
  • Two outcomes   :  HF (log_home_food_w_notsnap) ,
                      TF (Log_Total_Food)
  • Three models   :  hard-coded commands (see below)
  • Snap variable  :  local snapvar = "Log_SNAP_Benefits_USD"
                      for SR & SRO, blank for NR
  • Output names   :  identical to your originals
********************************************************************/
//do "Code/Analysis.do"
use "psid2.dta", clear

keep if year>=2019

xtset panelid year

/* ----------------------------- */
/* 1. loop over the three samples */
/* ----------------------------- */
foreach sample in T C NR SRO SR R { // C pp1020 pp010
use "psid2.dta", clear
    /* 1a.  pick snapvar and output stub */
    if "`sample'" == "NR" {

    }
    else if "`sample'" == "SR" {

    }
    else if "`sample'" == "SRO" {

    }

    /* ------------------------------------ */
    /* 2.  loop over the two dependent vars */
    /* ------------------------------------ */
    foreach grp in NH HF TF {
		
		di "check `sample' `depvar'"

        if "`grp'" == "HF" {
            local depvar   "log_home_food_w_notsnap"
			local incvar   "Log_Income"
			local inc2s    "Log_Income_Squared"
			local depvar2  "Log_Home_Income_Stimulus"
			local incvar2  "Log_Income_and_Stimulus"
            local inc2s2   "Log_Income_and_Stimulus_Squared"  
			local filesuf   "" // no _tot
        }
        else if  "`grp'" == "NH"  {
            local depvar   "Log_Non_Home_Food"
			local depvar2  "Log_Non_Home_Income_Stimulus"
            local filesuf  "_out"
        }
		else {
            local depvar   "Log_Total_Food"
			local depvar2  "Log_Total_Income_Stimulus"
            local filesuf  "_tot"
        }
foreach n of numlist 1 2 4 5 6 7 8 9 10 {

	use "psid2.dta", clear

	
	if `n'==1 { // Plain

		use "psid2.dta", clear
	
		local rob ""
		di "check n1 `sample' `depvar'"
	} // Plain
	else if `n'==3 { // WB/IMF inflation // SUFFIX 2
		use "psid2.dta", clear 
		

		drop ln_tot_y Log_Housing_Cost Log_Income  Log_Stimulus_Payments Log_SNAP_Amount_in_Prev_Month home_food_w_notsnap all_home_food Stimulus_Payments_USD  Income_USD Housing_Expenditure_USD log_home_food_w_notsnap Log_SNAP_Benefits_USD Log_Total_Food Income_and_Stimulus Log_Income_and_Stimulus   Total_Non_Home_Food_USD Log_Non_Home_Food Total_Non_Home_Div_Income Income_USD
		
		
		//di "`n'"
		local rob "_2"
		//di "`rob'"
		cap drop infl_*_d

			foreach dv of varlist *_d{
				cap drop infl_`dv'
				qui gen infl_`dv' = `dv'/inyixx
				replace infl_`dv'=. if `dv'==.
			}
			
			
			di
			
			


		cap drop Log_Income_and_Stimulus_Squared
di "check `n' `sample' `type'"
			*** Adjust values as needed  ***
			gen ln_tot_y = ln(infl_hd_fam_tot_y_d)	
			gen Log_Housing_Cost = ln(infl_hd_housing_cost_annual_d)
			gen Log_Income = ln(infl_hd_fam_tot_y_d)
			
			gen Log_Stimulus_Payments = ln(infl_stimulus_d)
			gen Log_SNAP_Amount_in_Prev_Month = ln(infl_hd_fam_snap_last_month_d)
			********************************
			gen Total_Non_Home_Food_USD = infl_hd_fam_ann_tot_out_food_d + infl_hd_fam_ann_tot_deliv_food_d
			gen Total_Non_Home_Div_Income = Total_Non_Home_Food_USD/infl_hd_fam_tot_y_d
			gen Log_Non_Home_Food = ln(Total_Non_Home_Div_Income)
			
			


			*** Adjust food values to annual or logs, combine non-SNAP and SNAP ***
			// Combine SNAP (not snap benefits) and non-SNAP weekly at-home food

			gen home_food_w_notsnap = infl_hd_fam_ann_tot_home_food_d/infl_hd_fam_tot_y_d // as a proportion of income
			
			// Log of values
			gen log_home_food_w_notsnap = ln(home_food_w_notsnap)
			

			gen Log_Total_Food = ln(infl_hd_fam_tot_food_d/infl_hd_fam_tot_y_d)
			
			gen Income_and_Stimulus = infl_hd_fam_tot_y_d+infl_stimulus_d
			gen Log_Income_and_Stimulus = ln(Income_and_Stimulus)
			
			gen Log_Income_Squared = ln(infl_hd_fam_tot_y_d)^2

			gen Log_Income_and_Stimulus_Squared = ln(Log_Income_and_Stimulus)^2
			gen Log_SNAP_Benefits_USD = ln(infl_hd_fam_snap_last_month_d)
			***********************************************************************
			
			
			*** Rename for easier understanding, values in Thousands ***
			rename infl_stimulus_d Stimulus_Payments_USD
			rename infl_hd_fam_snap_last_month_d SNAP_Benefits_USD
			
			rename infl_hd_fam_tot_y_d Income_USD
			rename infl_hd_housing_cost_annual_d Housing_Expenditure_USD

			label var Household_Size "Household Size"
			label var Housing_Expenditure_USD "Annual Housing Costs"
			label var hd_home_own "Home Owner"
			label var Age "Age"
			label var Log_Stimulus_Payments "Log Stimulus Payments (2023 USD)"
			label var Log_SNAP_Amount_in_Prev_Month "Log SNAP Benefits"
			label var Log_Income "Log Income"
			label var Log_Housing_Cost "Log Housing Cost"
			label var Income_USD "Annual Income"	
			label var Household_Size "Household Size"
			label var Housing_Expenditure_USD "Housing Cost"
			label var Log_SNAP_Benefits_USD "SNAP Benefits (Previous Month)"
			label var Log_SNAP_Benefits_USD "Log SNAP Benefits"

	} // WB/IMF inflation
	else if `n'==2 {  // at least 0% and at most 100% of (prev. year's) income on total food
		use "psid2.dta", clear 
		
		local rob "_3"
		drop if Total_Food_Div_Income >=1
		drop if Total_Food_Div_Income <0
		//drop if home_food_w_notsnap>=1
		//drop if home_food_w_notsnap<0
		
	} // at least 0% and at most 100% of (prev. year's) income on total food
	
	else if `n'==4 {  // at least 0% and at most 120% of (prev. year's) income on total food
		use "psid2.dta", clear 
		
		local rob "_4"
		drop if Total_Food_Div_Income >=1.2
		drop if Total_Food_Div_Income <0

		
	}  // at least 0% and at most 120% of (prev. year's) income on total food
	
	else if `n'==5 { // at least 0% and at most 80% of (prev. year's) income on total food
		use "psid2.dta", clear 
		
		local rob "_5"
		drop if Total_Food_Div_Income >=.8
		drop if Total_Food_Div_Income <0
		//drop if home_food_w_notsnap>=1
		//drop if home_food_w_notsnap<.05
		
	}
	else if `n' == 6{ // CPI food inflation
	
		use "psid2.dta", clear 
		
		
		
		di "check 0 `sample' `depvar' `n'"
			drop Log_SNAP_Amount_in_Prev_Month home_food_w_notsnap all_home_food  log_home_food_w_notsnap Log_SNAP_Benefits_USD Log_Total_Food Total_Non_Home_Food_USD Log_Non_Home_Food Total_Non_Home_Div_Income infl_hd_fam_tot_food_d infl_hd_fam_ann_tot_home_food_d infl_hd_fam_ann_tot_out_food_d infl_hd_fam_ann_tot_deliv_food_d
	
		//di "`n'"
		local rob "_6"
		di "check `sample' `depvar'"
		//di "`rob'"
		cap drop infl*food*_d
		cap drop infl*snap*_d
		//di "check `sample' `depvar'"
		
		di "check 2 `sample' `depvar'"
		*** Adjust for inflation *** CPI values for 2019 and 2021
		foreach dv of varlist   hd_fam_ann_tot_home_food_d {
		qui gen infl_`dv' = `dv'/${fi_home2021} if year == 2021
		replace infl_`dv'=. if `dv'==.
		
		qui replace infl_`dv' = `dv'/${fi_home2019} if year == 2019
		replace infl_`dv'=. if `dv'==.
		
		qui replace infl_`dv' = `dv' if year == 2023
		replace infl_`dv'=. if `dv'==.
		
		//qui replace infl_`dv' = `dv'/0.783 if year == 2017
		//replace infl_`dv'=. if `dv'==.
	}
	
	
	foreach dv of varlist  hd_fam_ann_tot_out_food_d hd_fam_ann_tot_deliv_food_d {
		qui gen infl_`dv' = `dv'/${fi_out2021} if year == 2021
		replace infl_`dv'=. if `dv'==.
		
		qui replace infl_`dv' = `dv'/${fi_out2019} if year == 2019
		replace infl_`dv'=. if `dv'==.
		
		qui replace infl_`dv' = `dv' if year == 2023
		replace infl_`dv'=. if `dv'==.
		
		//qui replace infl_`dv' = `dv'/0.783 if year == 2017
		//replace infl_`dv'=. if `dv'==.
	}
	
		foreach dv of varlist hd_fam_tot_food_d hd_fam_snap_last_month_d {
		qui gen infl_`dv' = `dv'/${fi2021} if year == 2021
		replace infl_`dv'=. if `dv'==.
		
		qui replace infl_`dv' = `dv'/${fi2019} if year == 2019
		replace infl_`dv'=. if `dv'==.
		
		qui replace infl_`dv' = `dv' if year == 2023
		replace infl_`dv'=. if `dv'==.
		
		//qui replace infl_`dv' = `dv'/0.783 if year == 2017
		//replace infl_`dv'=. if `dv'==.
	}
	
	drop infl_hd_fam_tot_food_d 
	gen infl_hd_fam_tot_food_d = infl_hd_fam_ann_tot_home_food_d + infl_hd_fam_ann_tot_out_food_d + infl_hd_fam_ann_tot_deliv_food_d

			di "check 3 `sample' `depvar'"
			di "check `n' `sample' `type'"
			*** Adjust values as needed  ***

			gen Log_SNAP_Amount_in_Prev_Month = ln(infl_hd_fam_snap_last_month_d)
			********************************
			gen Total_Non_Home_Food_USD = infl_hd_fam_ann_tot_out_food_d + infl_hd_fam_ann_tot_deliv_food_d
			gen Total_Non_Home_Div_Income = Total_Non_Home_Food_USD/Income_USD
			gen Log_Non_Home_Food = ln(Total_Non_Home_Div_Income)


			*** Adjust food values to annual or logs, combine non-SNAP and SNAP ***
			// Combine SNAP (not snap benefits) and non-SNAP weekly at-home food
			gen home_food_w_notsnap = infl_hd_fam_ann_tot_home_food_d/Income_USD // as a proportion of income
			
			// Log of values
			gen log_home_food_w_notsnap = ln(home_food_w_notsnap)
			

			gen Log_Total_Food = ln(infl_hd_fam_tot_food_d/Income_USD)

			gen Log_SNAP_Benefits_USD = ln(infl_hd_fam_snap_last_month_d)
			***********************************************************************
			
			
			*** Rename for easier understanding, values in Thousands ***
			rename infl_hd_fam_snap_last_month_d SNAP_Benefits_USD
			

			label var Household_Size "Household Size"
			label var Housing_Expenditure_USD "Annual Housing Costs"
			label var hd_home_own "Home Owner"
			label var Age "Age"
			label var Log_Stimulus_Payments "Log Stimulus Payments (2023 USD)"
			label var Log_SNAP_Amount_in_Prev_Month "Log SNAP Benefits"
			label var Log_Income "Log Income"
			label var Log_Housing_Cost "Log Housing Cost"
			label var Income_USD "Annual Income"	
			label var Household_Size "Household Size"
			label var Housing_Expenditure_USD "Housing Cost"
			
			label var Log_SNAP_Benefits_USD "Log SNAP Benefits"

	}

	else if `n'==7 { // Plain + drops

		use "psid2.dta", clear

				
				// Calculate 1st and 99th percentiles
				summarize `depvar', detail
				local p1 = r(p1)
				local p99 = r(p99)

				// Drop outliers
				drop if `depvar' < `p1' | `depvar' > `p99'

		local rob "_d"
		di "check n1 `sample' `depvar'"
	} // Plain
	else if `n' == 8{ // CPI food inflation + drops "_6_d"
	
		use "psid2.dta", clear 
		

				
				// Calculate 1st and 99th percentiles
				summarize `depvar', detail
				local p1 = r(p1)
				local p99 = r(p99)

		
		
		di "check 0 `sample' `depvar' `n'"
			drop Log_SNAP_Amount_in_Prev_Month home_food_w_notsnap all_home_food  log_home_food_w_notsnap Log_SNAP_Benefits_USD Log_Total_Food Total_Non_Home_Food_USD Log_Non_Home_Food Total_Non_Home_Div_Income infl_hd_fam_tot_food_d infl_hd_fam_ann_tot_home_food_d infl_hd_fam_ann_tot_out_food_d infl_hd_fam_ann_tot_deliv_food_d
	
		//di "`n'"
		local rob "_6_d"
		di "check `sample' `depvar'"
		//di "`rob'"
		cap drop infl*food*_d
		cap drop infl*snap*_d
		//di "check `sample' `depvar'"
		
		di "check 2 `sample' `depvar'"
		*** Adjust for inflation *** CPI values for 2019 and 2021
		foreach dv of varlist   hd_fam_ann_tot_home_food_d {
		qui gen infl_`dv' = `dv'/${fi_home2021} if year == 2021
		replace infl_`dv'=. if `dv'==.
		
		qui replace infl_`dv' = `dv'/${fi_home2019} if year == 2019
		replace infl_`dv'=. if `dv'==.
		
		qui replace infl_`dv' = `dv' if year == 2023
		replace infl_`dv'=. if `dv'==.
		
		//qui replace infl_`dv' = `dv'/0.783 if year == 2017
		//replace infl_`dv'=. if `dv'==.
	}
	
	
	foreach dv of varlist  hd_fam_ann_tot_out_food_d hd_fam_ann_tot_deliv_food_d {
		qui gen infl_`dv' = `dv'/${fi_out2021} if year == 2021
		replace infl_`dv'=. if `dv'==.
		
		qui replace infl_`dv' = `dv'/${fi_out2019} if year == 2019
		replace infl_`dv'=. if `dv'==.
		
		qui replace infl_`dv' = `dv' if year == 2023
		replace infl_`dv'=. if `dv'==.
		
		//qui replace infl_`dv' = `dv'/0.783 if year == 2017
		//replace infl_`dv'=. if `dv'==.
	}
	
		foreach dv of varlist hd_fam_tot_food_d hd_fam_snap_last_month_d {
		qui gen infl_`dv' = `dv'/${fi2021} if year == 2021
		replace infl_`dv'=. if `dv'==.
		
		qui replace infl_`dv' = `dv'/${fi2019} if year == 2019
		replace infl_`dv'=. if `dv'==.
		
		qui replace infl_`dv' = `dv' if year == 2023
		replace infl_`dv'=. if `dv'==.
		
		//qui replace infl_`dv' = `dv'/0.783 if year == 2017
		//replace infl_`dv'=. if `dv'==.
	}
	
	drop infl_hd_fam_tot_food_d 
	gen infl_hd_fam_tot_food_d = infl_hd_fam_ann_tot_home_food_d + infl_hd_fam_ann_tot_out_food_d + infl_hd_fam_ann_tot_deliv_food_d

			di "check 3 `sample' `depvar'"
			di "check `n' `sample' `type'"
			*** Adjust values as needed  ***

			gen Log_SNAP_Amount_in_Prev_Month = ln(infl_hd_fam_snap_last_month_d)
			********************************
			gen Total_Non_Home_Food_USD = infl_hd_fam_ann_tot_out_food_d + infl_hd_fam_ann_tot_deliv_food_d
			gen Total_Non_Home_Div_Income = Total_Non_Home_Food_USD/Income_USD
			gen Log_Non_Home_Food = ln(Total_Non_Home_Div_Income)


			*** Adjust food values to annual or logs, combine non-SNAP and SNAP ***
			// Combine SNAP (not snap benefits) and non-SNAP weekly at-home food
			gen home_food_w_notsnap = infl_hd_fam_ann_tot_home_food_d/Income_USD // as a proportion of income
			
			// Log of values
			gen log_home_food_w_notsnap = ln(home_food_w_notsnap)
			

			gen Log_Total_Food = ln(infl_hd_fam_tot_food_d/Income_USD)

			gen Log_SNAP_Benefits_USD = ln(infl_hd_fam_snap_last_month_d)
			***********************************************************************
			
			
			*** Rename for easier understanding, values in Thousands ***
			rename infl_hd_fam_snap_last_month_d SNAP_Benefits_USD
			

			label var Household_Size "Household Size"
			label var Housing_Expenditure_USD "Annual Housing Costs"
			label var hd_home_own "Home Owner"
			label var Age "Age"
			label var Log_Stimulus_Payments "Log Stimulus Payments (2023 USD)"
			label var Log_SNAP_Amount_in_Prev_Month "Log SNAP Benefits"
			label var Log_Income "Log Income"
			label var Log_Housing_Cost "Log Housing Cost"
			label var Income_USD "Annual Income"	
			label var Household_Size "Household Size"
			label var Housing_Expenditure_USD "Housing Cost"
			
			label var Log_SNAP_Benefits_USD "Log SNAP Benefits"

	}
	
	else if `n' == 9{ // CPI food inflation + 0_120 "_6_0120"
	
		use "psid2.dta", clear 
		

				drop if Total_Food_Div_Income >=1.2
				drop if Total_Food_Div_Income <0


		
		
		di "check 0 `sample' `depvar' `n'"
			drop Log_SNAP_Amount_in_Prev_Month home_food_w_notsnap all_home_food  log_home_food_w_notsnap Log_SNAP_Benefits_USD Log_Total_Food Total_Non_Home_Food_USD Log_Non_Home_Food Total_Non_Home_Div_Income infl_hd_fam_tot_food_d infl_hd_fam_ann_tot_home_food_d infl_hd_fam_ann_tot_out_food_d infl_hd_fam_ann_tot_deliv_food_d
	
		//di "`n'"
		local rob "_6_0120"
		di "check `sample' `depvar'"
		//di "`rob'"
		cap drop infl*food*_d
		cap drop infl*snap*_d
		//di "check `sample' `depvar'"
		
		di "check 2 `sample' `depvar'"
		*** Adjust for inflation *** CPI values for 2019 and 2021
		foreach dv of varlist   hd_fam_ann_tot_home_food_d {
		qui gen infl_`dv' = `dv'/${fi_home2021} if year == 2021
		replace infl_`dv'=. if `dv'==.
		
		qui replace infl_`dv' = `dv'/${fi_home2019} if year == 2019
		replace infl_`dv'=. if `dv'==.
		
		qui replace infl_`dv' = `dv' if year == 2023
		replace infl_`dv'=. if `dv'==.
		
		//qui replace infl_`dv' = `dv'/0.783 if year == 2017
		//replace infl_`dv'=. if `dv'==.
	}
	
	
	foreach dv of varlist  hd_fam_ann_tot_out_food_d hd_fam_ann_tot_deliv_food_d {
		qui gen infl_`dv' = `dv'/${fi_out2021} if year == 2021
		replace infl_`dv'=. if `dv'==.
		
		qui replace infl_`dv' = `dv'/${fi_out2019} if year == 2019
		replace infl_`dv'=. if `dv'==.
		
		qui replace infl_`dv' = `dv' if year == 2023
		replace infl_`dv'=. if `dv'==.
		
		//qui replace infl_`dv' = `dv'/0.783 if year == 2017
		//replace infl_`dv'=. if `dv'==.
	}
	
		foreach dv of varlist hd_fam_tot_food_d hd_fam_snap_last_month_d {
		qui gen infl_`dv' = `dv'/${fi2021} if year == 2021
		replace infl_`dv'=. if `dv'==.
		
		qui replace infl_`dv' = `dv'/${fi2019} if year == 2019
		replace infl_`dv'=. if `dv'==.
		
		qui replace infl_`dv' = `dv' if year == 2023
		replace infl_`dv'=. if `dv'==.
		
		//qui replace infl_`dv' = `dv'/0.783 if year == 2017
		//replace infl_`dv'=. if `dv'==.
	}
	
	drop infl_hd_fam_tot_food_d 
	gen infl_hd_fam_tot_food_d = infl_hd_fam_ann_tot_home_food_d + infl_hd_fam_ann_tot_out_food_d + infl_hd_fam_ann_tot_deliv_food_d

			di "check 3 `sample' `depvar'"
			di "check `n' `sample' `type'"
			*** Adjust values as needed  ***

			gen Log_SNAP_Amount_in_Prev_Month = ln(infl_hd_fam_snap_last_month_d)
			********************************
			gen Total_Non_Home_Food_USD = infl_hd_fam_ann_tot_out_food_d + infl_hd_fam_ann_tot_deliv_food_d
			gen Total_Non_Home_Div_Income = Total_Non_Home_Food_USD/Income_USD
			gen Log_Non_Home_Food = ln(Total_Non_Home_Div_Income)


			*** Adjust food values to annual or logs, combine non-SNAP and SNAP ***
			// Combine SNAP (not snap benefits) and non-SNAP weekly at-home food
			gen home_food_w_notsnap = infl_hd_fam_ann_tot_home_food_d/Income_USD // as a proportion of income
			
			// Log of values
			gen log_home_food_w_notsnap = ln(home_food_w_notsnap)
			

			gen Log_Total_Food = ln(infl_hd_fam_tot_food_d/Income_USD)

			gen Log_SNAP_Benefits_USD = ln(infl_hd_fam_snap_last_month_d)
			***********************************************************************
			
			
			*** Rename for easier understanding, values in Thousands ***
			rename infl_hd_fam_snap_last_month_d SNAP_Benefits_USD
			

			label var Household_Size "Household Size"
			label var Housing_Expenditure_USD "Annual Housing Costs"
			label var hd_home_own "Home Owner"
			label var Age "Age"
			label var Log_Stimulus_Payments "Log Stimulus Payments (2023 USD)"
			label var Log_SNAP_Amount_in_Prev_Month "Log SNAP Benefits"
			label var Log_Income "Log Income"
			label var Log_Housing_Cost "Log Housing Cost"
			label var Income_USD "Annual Income"	
			label var Household_Size "Household Size"
			label var Housing_Expenditure_USD "Housing Cost"
			
			label var Log_SNAP_Benefits_USD "Log SNAP Benefits"

	}
	

	else if `n' == 10{ // CPI food inflation + 0_80 "_6_080"
	
		use "psid2.dta", clear 
		

				
				drop if Total_Food_Div_Income >=.8
				drop if Total_Food_Div_Income <0

		
		
		di "check 0 `sample' `depvar' `n'"
			drop Log_SNAP_Amount_in_Prev_Month home_food_w_notsnap all_home_food  log_home_food_w_notsnap Log_SNAP_Benefits_USD Log_Total_Food Total_Non_Home_Food_USD Log_Non_Home_Food Total_Non_Home_Div_Income infl_hd_fam_tot_food_d infl_hd_fam_ann_tot_home_food_d infl_hd_fam_ann_tot_out_food_d infl_hd_fam_ann_tot_deliv_food_d
	
		//di "`n'"
		local rob "_6_080"
		di "check `sample' `depvar'"
		//di "`rob'"
		cap drop infl*food*_d
		cap drop infl*snap*_d
		//di "check `sample' `depvar'"
		
		di "check 2 `sample' `depvar'"
		*** Adjust for inflation *** CPI values for 2019 and 2021
		foreach dv of varlist   hd_fam_ann_tot_home_food_d {
		qui gen infl_`dv' = `dv'/${fi_home2021} if year == 2021
		replace infl_`dv'=. if `dv'==.
		
		qui replace infl_`dv' = `dv'/${fi_home2019} if year == 2019
		replace infl_`dv'=. if `dv'==.
		
		qui replace infl_`dv' = `dv' if year == 2023
		replace infl_`dv'=. if `dv'==.
		
		//qui replace infl_`dv' = `dv'/0.783 if year == 2017
		//replace infl_`dv'=. if `dv'==.
	}
	
	
	foreach dv of varlist  hd_fam_ann_tot_out_food_d hd_fam_ann_tot_deliv_food_d {
		qui gen infl_`dv' = `dv'/${fi_out2021} if year == 2021
		replace infl_`dv'=. if `dv'==.
		
		qui replace infl_`dv' = `dv'/${fi_out2019} if year == 2019
		replace infl_`dv'=. if `dv'==.
		
		qui replace infl_`dv' = `dv' if year == 2023
		replace infl_`dv'=. if `dv'==.
		
		//qui replace infl_`dv' = `dv'/0.783 if year == 2017
		//replace infl_`dv'=. if `dv'==.
	}
	
		foreach dv of varlist hd_fam_tot_food_d hd_fam_snap_last_month_d {
		qui gen infl_`dv' = `dv'/${fi2021} if year == 2021
		replace infl_`dv'=. if `dv'==.
		
		qui replace infl_`dv' = `dv'/${fi2019} if year == 2019
		replace infl_`dv'=. if `dv'==.
		
		qui replace infl_`dv' = `dv' if year == 2023
		replace infl_`dv'=. if `dv'==.
		
		//qui replace infl_`dv' = `dv'/0.783 if year == 2017
		//replace infl_`dv'=. if `dv'==.
	}
	
	drop infl_hd_fam_tot_food_d 
	gen infl_hd_fam_tot_food_d = infl_hd_fam_ann_tot_home_food_d + infl_hd_fam_ann_tot_out_food_d + infl_hd_fam_ann_tot_deliv_food_d

			di "check 3 `sample' `depvar'"
			di "check `n' `sample' `type'"
			*** Adjust values as needed  ***

			gen Log_SNAP_Amount_in_Prev_Month = ln(infl_hd_fam_snap_last_month_d)
			********************************
			gen Total_Non_Home_Food_USD = infl_hd_fam_ann_tot_out_food_d + infl_hd_fam_ann_tot_deliv_food_d
			gen Total_Non_Home_Div_Income = Total_Non_Home_Food_USD/Income_USD
			gen Log_Non_Home_Food = ln(Total_Non_Home_Div_Income)


			*** Adjust food values to annual or logs, combine non-SNAP and SNAP ***
			// Combine SNAP (not snap benefits) and non-SNAP weekly at-home food
			gen home_food_w_notsnap = infl_hd_fam_ann_tot_home_food_d/Income_USD // as a proportion of income
			
			// Log of values
			gen log_home_food_w_notsnap = ln(home_food_w_notsnap)
			

			gen Log_Total_Food = ln(infl_hd_fam_tot_food_d/Income_USD)

			gen Log_SNAP_Benefits_USD = ln(infl_hd_fam_snap_last_month_d)
			***********************************************************************
			
			
			*** Rename for easier understanding, values in Thousands ***
			rename infl_hd_fam_snap_last_month_d SNAP_Benefits_USD
			

			label var Household_Size "Household Size"
			label var Housing_Expenditure_USD "Annual Housing Costs"
			label var hd_home_own "Home Owner"
			label var Age "Age"
			label var Log_Stimulus_Payments "Log Stimulus Payments (2023 USD)"
			label var Log_SNAP_Amount_in_Prev_Month "Log SNAP Benefits"
			label var Log_Income "Log Income"
			label var Log_Housing_Cost "Log Housing Cost"
			label var Income_USD "Annual Income"	
			label var Household_Size "Household Size"
			label var Housing_Expenditure_USD "Housing Cost"
			
			label var Log_SNAP_Benefits_USD "Log SNAP Benefits"

	}
	

    

            /****************************************************
               3.   SAMPLE-SPECIFIC FILTERS  (verbatim copies)
            ****************************************************/
			
			preserve
            /* --- NR filters (work for HF & TF) --- */
            if "`sample'" == "NR" { // 0 to 20 percentile; ""
				
				di "check `sample' `depvar'"
				
				local inc_sq "`inc2s'"
				local inc_sq2 "`inc2s2'"
				
				//local depvar "Log_Home_Food_Inc_USD"
				//local depvar2 "Log_Home_Food_IncS_USD"
				
				local snapvar ""
				local snapvar ""
				local snapvar ""
				local outstub ""
				
				di "check 1"
				keep if Income_USD <=p20_income
				
				keep if year>=2019
				
                cap drop snap snap_by_panel
                gen snap = 0
                replace snap = 1 if hd_fam_snap_last_month_yn == 1
				di "check 2"
				tab snap
                bys panelid: egen snap_by_panel = max(snap)
				di "check `sample' `depvar'"
                keep if snap_by_panel == 0
				di "check `sample' `depvar'"

                drop in_* panel_in_*
                drop if Log_Income == .
                drop if Household_Size == .
                //drop if Stimulus_Payments_YN == .
                drop if `depvar' == .
				
				
				keep if year>=2019


                forval y=2021(2)2023 {
                    gen in_`y' = 0
                    replace in_`y' = 1 if year==`y'
                    bys panelid: egen panel_in_`y' = max(in_`y')
                    drop if panel_in_`y'==0
                }
            }

            /* --- SR filters --- */
            if "`sample'" == "SR" { // 40 to 80 percentile; "_wsnap"
				
				di "check `sample' `depvar' `n'"
				
				//local depvar "Log_Home_Food_Inc_USD"
				//local depvar2 "Log_Home_Food_IncS_USD"
				
				local inc_sq "`inc2s'"
				local inc_sq2 "`inc2s2'"
				
				local snapvar ""
				local outstub "_wsnap"	
				
				di "check 1"
				keep if Income_USD > p40_income
				keep if Income_USD <=p60_income
				
				keep if year>=2019
				
                cap drop snap snap_by_panel
                gen snap = 0
                replace snap = 1 if hd_fam_snap_last_month_yn == 1
				tab snap
				di "check 2"
				tab snap
                bys panelid: egen snap_by_panel = max(snap)
				di "check `sample' `depvar' `n'"
                keep if snap_by_panel == 0
				di "check `sample' `depvar' `n'"

                drop in_* panel_in_*
                drop if Log_Income == .
                drop if Household_Size == .
                //drop if Stimulus_Payments_YN == .
                drop if `depvar' == .
				
								keep if year>=2019

                forval y=2021(2)2023 {
                    gen in_`y' = 0
                    replace in_`y' = 1 if year==`y'
                    bys panelid: egen panel_in_`y' = max(in_`y')
                    drop if panel_in_`y'==0
                }
            }
			if "`sample'" == "C" { // 60 to 80 percentile; "_6080"
				
				di "check `sample' `depvar' `n'"
				
				//local depvar "Log_Home_Food_Inc_USD"
				//local depvar2 "Log_Home_Food_IncS_USD"
				
				local inc_sq "`inc2s'"
				local inc_sq2 "`inc2s2'"
				
				local snapvar ""
				local outstub "_6080"	
				
				di "check 1"
				keep if Income_USD > p60_income
				keep if Income_USD <=p80_income
				
				keep if year>=2019
				
                cap drop snap snap_by_panel
                gen snap = 0
                replace snap = 1 if hd_fam_snap_last_month_yn == 1
				tab snap
				di "check 2"
				tab snap
                bys panelid: egen snap_by_panel = max(snap)
				di "check `sample' `depvar' `n'"
                keep if snap_by_panel == 0
				di "check `sample' `depvar' `n'"

                drop in_* panel_in_*
                drop if Log_Income == .
                drop if Household_Size == .
                //drop if Stimulus_Payments_YN == .
                drop if `depvar' == .
				
								keep if year>=2019

                forval y=2021(2)2023 {
                    gen in_`y' = 0
                    replace in_`y' = 1 if year==`y'
                    bys panelid: egen panel_in_`y' = max(in_`y')
                    drop if panel_in_`y'==0
                }
            }
			 /* --- R filters --- */
            if "`sample'" == "R" { // 80 to 100 percentile; "_otr"
				
				di "check `sample' `depvar'"
				
				//local depvar "Log_Home_Food_Inc_USD"
				//local depvar2 "Log_Home_Food_IncS_USD"
				
				local inc_sq "`inc2s'"
				local inc_sq2 "`inc2s2'"
				
				local snapvar ""
				local outstub "_otr"	
				
				di "check 1"
				keep if Income_USD > p80_income
				//keep if Income_USD <=p40_income
				
				keep if year>=2019
				
                cap drop snap snap_by_panel
                gen snap = 0
                replace snap = 1 if hd_fam_snap_last_month_yn == 1
				di "check 2"
				
                bys panelid: egen snap_by_panel = max(snap)
				di "check `sample' `depvar'"
                keep if snap_by_panel == 0
				di "check `sample' `depvar'"

                drop in_* panel_in_*
                drop if Log_Income == .
                drop if Household_Size == .
                //drop if Stimulus_Payments_YN == .
                drop if `depvar' == .
				
								keep if year>=2019

                forval y=2021(2)2023 {
                    gen in_`y' = 0
                    replace in_`y' = 1 if year==`y'
                    bys panelid: egen panel_in_`y' = max(in_`y')
                    drop if panel_in_`y'==0
                }
            }
			 /* --- T filters --- */
            if "`sample'" == "T" { // 20 to 40 percentile; "_try"
				
				di "check `sample' `depvar'"
				
				//local depvar "Log_Home_Food_Inc_USD"
				//local depvar2 "Log_Home_Food_IncS_USD"
				
				local inc_sq "`inc2s'"
				local inc_sq2 "`inc2s2'"
				
				local snapvar ""
				local outstub "_try"	
				
				di "check 1"
				keep if Income_USD > p20_income
				keep if Income_USD <=p40_income
				
				keep if year>=2019
				
                cap drop snap snap_by_panel
                gen snap = 0
                replace snap = 1 if hd_fam_snap_last_month_yn == 1
				di "check 2"
				
                bys panelid: egen snap_by_panel = max(snap)
				di "check `sample' `depvar'"
                keep if snap_by_panel == 0
				di "check `sample' `depvar'"

                drop in_* panel_in_*
                drop if Log_Income == .
                drop if Household_Size == .
                //drop if Stimulus_Payments_YN == .
                drop if `depvar' == .
				
								keep if year>=2019

                forval y=2021(2)2023 {
                    gen in_`y' = 0
                    replace in_`y' = 1 if year==`y'
                    bys panelid: egen panel_in_`y' = max(in_`y')
                    drop if panel_in_`y'==0
                }
            }
            /* --- SRO filters --- */
            if "`sample'" == "SRO" { // snap; "_wsnapo"
				//keep if Income_USD <=p20_income
				
				//local depvar "Log_SNAP_Home_Food_Inc_USD"
				//local depvar2 "Log_SNAP_Home_Food_IncS_USD"
				di "check A `sample' `depvar'"
				local inc_sq "`inc2s'"
				local inc_sq2 "`inc2s2'"
				
				local snapvar "Log_SNAP_Benefits_USD"
				local outstub "_wsnapo"		
				
				di "check B `sample' `depvar'"
				
				keep if year>=2019
				
                cap drop snap snap_by_panel
                gen snap = 0
                replace snap = 1 if hd_fam_snap_last_month_yn==1
                bys panelid: egen snap_by_panel = min(snap)
                keep if snap_by_panel == 1
				
				di "check C `sample' `depvar'"

                drop in_* panel_in_*
                drop if Log_Income == .
                //drop if Stimulus_Payments_YN == .
                drop if Log_SNAP_Benefits_USD == .
                drop if Household_Size == .
                drop if `depvar' == .
				
				tab year 
				
				di "check D `sample' `depvar'"

                forval y=2021(2)2023 {
                    gen in_`y' = 0
                    replace in_`y' = 1 if year==`y'
                    bys panelid: egen panel_in_`y' = max(in_`y')
                    drop if panel_in_`y'==0
                }
            }
			if "`sample'" == "pp1020" { // 20 to 40 percentile; "_try"
				
				di "check `sample' `depvar'"
				
				//local depvar "Log_Home_Food_Inc_USD"
				//local depvar2 "Log_Home_Food_IncS_USD"
				
				local inc_sq "`inc2s'"
				local inc_sq2 "`inc2s2'"
				
				local snapvar ""
				local outstub "_pp1020"	
				
				di "check 1"
				keep if Income_USD > p10_income
				keep if Income_USD <=p20_income
				
				keep if year>=2019
				
                cap drop snap snap_by_panel
                gen snap = 0
                replace snap = 1 if hd_fam_snap_last_month_yn == 1
				di "check 2"
				
                bys panelid: egen snap_by_panel = max(snap)
				di "check `sample' `depvar'"
                keep if snap_by_panel == 0
				di "check `sample' `depvar'"

                drop in_* panel_in_*
                drop if Log_Income == .
                drop if Household_Size == .
                //drop if Stimulus_Payments_YN == .
                drop if `depvar' == .
				
								keep if year>=2019

                forval y=2021(2)2023 {
                    gen in_`y' = 0
                    replace in_`y' = 1 if year==`y'
                    bys panelid: egen panel_in_`y' = max(in_`y')
                    drop if panel_in_`y'==0
                }
            }
			
			if "`sample'" == "pp010" { // 20 to 40 percentile; "_try"
				
				di "check `sample' `depvar'"
				
				//local depvar "Log_Home_Food_Inc_USD"
				//local depvar2 "Log_Home_Food_IncS_USD"
				
				local inc_sq "`inc2s'"
				local inc_sq2 "`inc2s2'"
				
				local snapvar ""
				local outstub "_pp010"	
				
				di "check 1"
				//keep if Income_USD > p0_income
				keep if Income_USD <=p10_income
				
				keep if year>=2019
				
                cap drop snap snap_by_panel
                gen snap = 0
                replace snap = 1 if hd_fam_snap_last_month_yn == 1
				di "check 2"
				
                bys panelid: egen snap_by_panel = max(snap)
				di "check `sample' `depvar'"
                keep if snap_by_panel == 0
				di "check `sample' `depvar'"

                drop in_* panel_in_*
                drop if Log_Income == .
                drop if Household_Size == .
                //drop if Stimulus_Payments_YN == .
                drop if `depvar' == .
				
								keep if year>=2019

                forval y=2021(2)2023 {
                    gen in_`y' = 0
                    replace in_`y' = 1 if year==`y'
                    bys panelid: egen panel_in_`y' = max(in_`y')
                    drop if panel_in_`y'==0
                }
            }
            
			

            /****************************************************
               4.  THREE MODELS  (exact commands)
            ****************************************************/
				/* --------- MODEL 1 ------------------------------------------- */
				xtreg `depvar' i.year Log_Income Household_Size `snapvar' ///
					  [pw=weight], fe vce(cluster panelid)
				eststo model1`outstub'`filesuf'`rob'


				/* --------- MODEL 2 ------------------------------------------- */
				xtreg `depvar' i.year Log_Income Log_Housing_Cost  ///
					  Household_Size `snapvar' ///
					  [pw=weight], fe vce(cluster panelid)
				eststo model2`outstub'`filesuf'`rob'


				/* --------- MODEL 3 ------------------------------------------- */
				xtreg `depvar' Log_Income Stimulus_Payments_YN i.year Household_Size ///
					     Log_Housing_Cost  `snapvar' ///
					  [pw=weight], fe vce(cluster panelid)
				eststo model3`outstub'`filesuf'`rob'
				

				
			/****************************************************
               5.  Export with the ORIGINAL file name
            ****************************************************/
			local name "output`outstub'`filesuf'`rob'_exp"
            esttab model1`outstub'`filesuf'`rob' model2`outstub'`filesuf'`rob' model3`outstub'`filesuf'`rob' using "`name'.csv", replace ///
                  label se star(* 0.1 ** 0.05 *** 0.01)                      ///
                  stats(N N_g r2_w r2_o, fmt(0 0 3)                          ///
                        labels("Observations" "Households"                   ///
                               "R-Squared (Within)" "R-Squared (Overall)")) ///
                  b(4) se(4)
				  

			restore 
			
			}



    }   /* end grp loop */
}       /* end sample loop */


