

******************************** SET PATHS ************************************
global download_folder <path1> // set before running
			// main download location that contains project folder

******************************************************************************

	global fol "$download_folder"
	
	global db "$fol/Expenditures"
	
	cd "$db"
		
	use "psid.dta", clear // or other cleaned file name
	
	
	xtset panelid year
	
	*** Nominal values for expenditure as a % of income graph
	gen home_food_d = (hd_fam_ann_tot_home_food_d) 
	*********************************************************
	
*** Export for plot ***
	export delimited using "Expen0.csv", replace


*** Percentile calculations

drop if hd_fam_tot_y_d <=0 //drop zero and negative values

	gen p60_income = .

	levelsof year, local(yrs)
	foreach y of local yrs {
		quietly {
			_pctile Income_USD if year == `y' [pw=weight], percentiles(60)
			replace p60_income = r(r1) if year == `y'
		}
	}
	
	gen p40_income = .

	levelsof year, local(yrs)
	foreach y of local yrs {
		quietly {
			_pctile Income_USD if year == `y' [pw=weight], percentiles(40)
			replace p40_income = r(r1) if year == `y'
		}
	}
	
	
	gen p80_income = .
	levelsof year, local(yrs)
	foreach y of local yrs {
		quietly {
			_pctile Income_USD if year == `y' [pw=weight], percentiles(80)
			replace p80_income = r(r1) if year == `y'
		}
	}
	
	
	gen p20_income = .

	levelsof year, local(yrs)
	foreach y of local yrs {
		quietly {
			_pctile Income_USD if year == `y' [pw=weight], percentiles(20)
			replace p20_income = r(r1) if year == `y'
		}
	}
	

	
****** Define quintiles and indicate percent change for robustness checks ******
	
// Quintile indicators
gen byte q1 = Income_USD <= p20_income
gen byte q2 = Income_USD > p20_income & Income_USD <= p40_income
gen byte q3 = Income_USD > p40_income & Income_USD <= p60_income
gen byte q4 = Income_USD > p60_income & Income_USD <= p80_income
gen byte q5 = Income_USD > p80_income



// Define quintiles 1–5 per household-year
gen byte quint = .
replace quint = 1 if Income_USD <= p20_income
replace quint = 2 if Income_USD > p20_income   & Income_USD <= p40_income
replace quint = 3 if Income_USD > p40_income   & Income_USD <= p60_income
replace quint = 4 if Income_USD > p60_income   & Income_USD <= p80_income
replace quint = 5 if Income_USD > p80_income



// Compute number of distinct quintiles each household appears in
egen byte distinct_quints = nvals(quint), by(panelid)


// Compute first and last year income per household
bysort panelid (year): gen double income_first = Income_USD[1]
bysort panelid (year): gen double income_last  = Income_USD[_N]

// Calculate percentage change
gen double pct_change = ((income_last - income_first) / income_first) * 100

// Summarize percentage change for these households
summarize pct_change if distinct_quints==2 & year==2023, det
summarize pct_change if distinct_quints==1 & year==2023, det

gen ok_change = (distinct_quints==1)
replace ok_change = 1 if distinct_quints==2 & (abs(pct_change)<=25)
	
********************************************************************************
	


*** Drop invalid households ***
drop if Age<18
keep if year >= 2019



**** Only households in both 2021 and 2023 *****
forval i = 2021(2)2023 {
	gen in_`i' = 0
	replace in_`i' = 1 if year == `i'
	bys panelid: egen panel_in_`i' = max(in_`i')
	drop if panel_in_`i' == 0
}
************************************************



		
*********************** Calculate outcome variables ****************************
gen Total_Food_Div_Income = infl_hd_fam_tot_food_d/Income_USD if ///
							ann_home_food_imputed == 0
gen Log_Total_Food = ln(infl_hd_fam_tot_food_d/Income_USD)
gen Total_Out_Div_Income = infl_hd_fam_ann_tot_out_food_d/Income_USD
gen Log_Out_Food = ln(Total_Out_Div_Income)
gen Total_Non_Home_Div_Income = Total_Non_Home_Food_USD/Income_USD
gen Log_Non_Home_Food = ln(Total_Non_Home_Div_Income)


cap drop Log_Stimulus_USD

gen Log_Stimulus_USD = ln(Stimulus_Payments_USD+1)

gen Stimulus_Payments_YN = 1 if Stimulus_Payments_USD>0
replace Stimulus_Payments_YN = 0 if Stimulus_Payments_USD == 0
replace Stimulus_Payments_YN = . if Stimulus_Payments_USD == .
replace Stimulus_Payments_YN = 0 if inlist(year, 2019, 2023)

********************************************************************************

* -----------------------------------------
* Define variable labels for independent vars
* -----------------------------------------
label var Household_Size "Household Size"
label var Housing_Expenditure_USD "Annual Housing Costs"
label var Log_Stimulus_Payments "Log Stimulus Payments (2023 USD)"
label var Log_SNAP_Amount_in_Prev_Month "Log SNAP Amount (2023 USD)"
label var Log_Income "Log Income"
label var Log_Housing_Cost "Log Housing Cost"
label var Income_USD "Annual Income"
label var Housing_Expenditure_USD "Housing Cost"
label define year_lbl 2019 "2019" 2021 "2021" 2023 "2023"
label values year year_lbl
label var Log_SNAP_Benefits_USD "Log SNAP Benefits"
label var Stimulus_Payments_YN "Stimulus Payments (Y/N)"


* --------------------------------
* Globals for Food Infl Deflators
* --------------------------------
	// All food
	global fi2021 = 0.863725456
	global fi2019 = 0.805063323

	// Out
	global fi_out2021 = 0.867441546
	global fi_out2019 = 0.80283731
	
	//Home
	global fi_home2021 = 0.854628712
	global fi_home2019 = 0.798122882



save "psid2.dta", replace

