clear
/* SET PATHS BEFORE RUNNING

cap ssc install psid

******************************** SET PATHS ************************************
global download_folder "<main project file>" // set before running
			// main download location that contains project folder

global psid_file_location "<raw PSID file location" // set before running
			// location of downloaded raw PSID individual, 
			// family files for 1999-2023
******************************************************************************


	global fol "$download_folder"
	
	global db "$fol/Expenditures"
	
	cd "$db"
*/

*******************************************************************************
*                           Compile psid database                             *
*******************************************************************************

* PSID package: varname survey-vars, using "$path", design(any) clear keepnotes
 psid use  ///
	|| Household_Size  ///
		[97]ER10008 [99]ER13009 [01]ER17012 [03]ER21016 [05]ER25016 [07]ER36016 [09]ER42016 [11]ER47316 [13]ER53016 [15]ER60016 [17]ER66016 [19]ER72016 [21]ER78016 [23]ER82017  ///	
	|| Age  ///
		[97]ER10009 [99]ER13010 [01]ER17013 [03]ER21017 [05]ER25017 [07]ER36017 [09]ER42017 [11]ER47317 [13]ER53017 [15]ER60017 [17]ER66017 [19]ER72017 [21]ER78017 [23]ER82018  ///
	|| hd_home_own  ///
		[97]ER10035 [99]ER13040 [01]ER17043 [03]ER21042 [05]ER25028 [07]ER36028 [09]ER42029 [11]ER47329 [13]ER53029 [15]ER60030 [17]ER66030 [19]ER72030 [21]ER78031 [23]ER82032 ///
	|| hd_housing_cost_annual_d  /// 
		[99]ER16515A5 [01]ER20456A5 [03]ER24138A5 [05]ER28037A5 [07]ER41027A5 [09]ER46971A5 [11]ER52395A5 [13]ER58212A5 [15]ER65414 [17]ER71491 [19]ER77520 [21]ER81847 [23]ER85701 ///	
	|| hd_fam_tot_y_d  /// 
		[99]ER16462 [01]ER20456 [03]ER24099 [05]ER28037 [07]ER41027 [09]ER46935 [11]ER52343 [13]ER58152 [15]ER65349 [17]ER71426 [19]ER77448 [21]ER81775 [23]ER85629  ///
	|| hd_fam_snap_last_month_d ///
		[09]ER42709 [11]ER48025 [13]ER53722 [15]ER60737 [17]ER66784 [19]ER72788 [21]ER78865 [23]ER82858 ///
	|| long_weights ///
		[97]ER12084 [99]ER16518 [01]ER20394 [03]ER24179 [05]ER28078 [07]ER41069 [09]ER47012 [11]ER52436 [13]ER58257 [15]ER65492 [17]ER71570 [19]ER77631 [21]ER81958 [23]ER85812 ///	
	|| hd_fam_tot_food_d ///
		[99]ER16515A1 [01]ER20456A1 [03]ER24138A1 [05]ER28037A1 [07]ER41027A1 [09]ER46971A1 [11]ER52395A1 [13]ER58212A1 [15]ER65410 [17]ER71487 [19]ER77513 [21]ER81840 [23]ER85694 /// 
	|| hd_fam_ann_tot_home_food_d ///
		[99]ER16515A2 [01]ER20456A2 [03]ER24138A2 [05]ER28037A2 [07]ER41027A2 [09]ER46971A2 [11]ER52395A2 [13]ER58212A2 [15]ER65411 [17]ER71488 [19]ER77514 [21]ER81841 [23]ER85695 ///
	|| hd_fam_ann_tot_out_food_d ///
		[01]ER20456A3 [03]ER24138A3 [05]ER28037A3 [07]ER41027A3 [09]ER46971A3 [11]ER52395A3 [13]ER58212A3 [15]ER65412 [17]ER71489 [19]ER77516 [21]ER81843 [23]ER85697 ///
	|| hd_fam_snap_last_month_yn ///
		[97]ER11064 [99]ER14270 [01]ER18402 [03]ER21668 [05]ER25670 [07]ER36688 [09]ER42707 [11]ER48023 [13]ER53720 [15]ER60735 [17]ER66782 [19]ER72786 [21]ER78863 [23]ER82856 ///
	|| hd_fam_ann_tot_deliv_food_d ///
		[99]ER16515A4 [01]ER20456A4 [03]ER24138A4 [05]ER28037A4 [07]ER41027A4 [09]ER46971A4 [11]ER52395A4 [13]ER58212A4 [15]ER65413 [17]ER71490 [19]ER77518 [21]ER81845 [23]ER85699 ///
	|| ann_home_food_imputed ///
		[99]ER16515A2A [01]ER20456A2A [03]ER24138A2A [05]ER28037A2A [07]ER41027A2A [09]ER46971A2A [11]ER52395A2A [13]ER58212A2A [15]ER65411A [17]ER71488A [19]ER77515 [21]ER81842 [23]ER85696 ///
	|| hd_tot_wages_d  ///
		[99]ER16493 [01]ER20425 [03]ER24117 [05]ER27913 [07]ER40903 [09]ER46811 [11]ER52219 [13]ER58020 [15]ER65200 [17]ER71277 [19]ER77299 [21]ER81626 [23]ER85480  ///
	|| stimulus_yn ///
		[21]ER79438 ///
	|| stimulus_d ///
		[21]ER79439 ///
			using "$rawd/PSID_Direct_Download_Files" , design(any) clear keepnotes 
			
psid long

rename wave year

drop if x11102 ==.
drop if xsqnr ==0


*******************************************************************************
*                   Construct households with panel ID                        *
*******************************************************************************

	gen ind_seq_n = xsqnr
	gen fam_int_n = x11102 
	rename x11101ll panelid
	gen panelid_s = panelid

	******** Panel ID *****************************
	tostring panelid_s, replace
	gen ER30002 = substr(panelid_s, -3, 3)
	destring ER30002, replace
	gen ER30001 =  (panelid - ER30002)/1000
				
	cap drop _rep
	cap drop _merge
				 
	rename ER30001 int68 // 1968 interview number
	rename ER30002 seq_no68 // 1968 sequence number both numbers together 
	
	
	replace xsqnr = 1 if seq_no68==1 & year==1968
				// sync sequence number variables

*******************************************************************************
*                       Final Cleaning for output                             *
*******************************************************************************

keep if xsqnr == 1 // heads of households only
				
****************************** NA values *********************************

replace hd_fam_snap_last_month_yn = 0 if hd_fam_snap_last_month_yn ==5
replace hd_fam_snap_last_month_yn = . if inlist(hd_fam_snap_last_month_yn, 8, 9) 

replace hd_fam_snap_last_month_d = . if inlist(hd_fam_snap_last_month_d, 999998, 999999)
replace hd_fam_snap_last_month_d = . if inlist(hd_fam_snap_last_month_d, 99998, 99999)

replace stimulus_d = . if inlist(stimulus_d, 99998, 99999)
replace stimulus_d = 0 if inlist(year, 2017, 2019, 2023)


gen fam_wgt2023 = long_weights if year==2023
bys panelid: egen weight = max(fam_wgt2023)

save "psid.dta", replace


*******************************************************************************
*                         Inflation adjustments                               *
*******************************************************************************
* Inflation variables for robustness checks

/* Run if needed to download inflation index from WID
clear

qui wid, indicators(inyixx) ages(999) pop(i) clear

keep if country=="US"
keep year value
rename value inyixx

save "infl.dta", replace
*/
	
	use "psid.dta", clear

cap drop __00*
cap drop _merge
	
	qui merge m:1 year using "infl.dta"
	qui drop if _merge==2
	

*******************************************************************

*** Adjust for inflation *** CPI values for all items (CUUR0000SA0)
	foreach dv of varlist *_d{
		qui gen infl_`dv' = `dv'/0.88929551 if year == 2021
		replace infl_`dv'=. if `dv'==.
		
		qui replace infl_`dv' = `dv'/0.83904197 if year == 2019
		replace infl_`dv'=. if `dv'==.
		
		qui replace infl_`dv' = `dv' if year == 2023
		replace infl_`dv'=. if `dv'==.
		
		qui replace infl_`dv' = `dv'/0.804457859 if year == 2017
		replace infl_`dv'=. if `dv'==.
		
		qui replace infl_`dv' = `dv'/0.777865994 if year == 2015
		replace infl_`dv'=. if `dv'==.
		
		qui replace infl_`dv' = `dv'/0.764541755 if year == 2013
		replace infl_`dv'=. if `dv'==.
		
		qui replace infl_`dv' = `dv'/0.738227758 if year == 2011
		replace infl_`dv'=. if `dv'==.
		
		qui replace infl_`dv' = `dv'/0.704088891 if year == 2009
		replace infl_`dv'=. if `dv'==.
		
		qui replace infl_`dv' = `dv'/0.680476991 if year == 2007
		replace infl_`dv'=. if `dv'==.
		
		qui replace infl_`dv' = `dv'/0.64092764 if year == 2005
		replace infl_`dv'=. if `dv'==.
		
		qui replace infl_`dv' = `dv'/0.603732778 if year == 2003
		replace infl_`dv'=. if `dv'==.
		
		qui replace infl_`dv' = `dv'/0.58111502 if year == 2001
		replace infl_`dv'=. if `dv'==.
	}
	

	***************************************************************
	
*******************************************************************************
*                            Value adjustments                                *
*******************************************************************************
	
	*** Log values  *****************
	gen ln_tot_y = ln(infl_hd_fam_tot_y_d)	
	gen Log_Housing_Cost = ln(infl_hd_housing_cost_annual_d)
	gen Log_Income = ln(infl_hd_fam_tot_y_d)
	
	gen Log_Stimulus_Payments = ln(infl_stimulus_d)
	gen Log_SNAP_Amount_in_Prev_Month = ln(infl_hd_fam_snap_last_month_d)
	********************************

	*** Adjust food values to logs, divide by income **********************
	gen all_home_food = infl_hd_fam_ann_tot_home_food_d // annual
	gen home_food_w_notsnap = infl_hd_fam_ann_tot_home_food_d/infl_hd_fam_tot_y_d 
	

	// Log of values
	gen log_home_food_w_notsnap = ln(home_food_w_notsnap)
	gen Non_Home_Food_USD = infl_hd_fam_ann_tot_deliv_food_d+infl_hd_fam_ann_tot_out_food_d
	gen Total_Non_Home_Food_USD = infl_hd_fam_ann_tot_deliv_food_d+infl_hd_fam_ann_tot_out_food_d
	***********************************************************************
	
*******************************************************************************
*                            Final adjustments                                *
*******************************************************************************
	
	*** Rename for easier understanding, values in Thousands ***
	rename infl_stimulus_d Stimulus_Payments_USD
	
	rename infl_hd_fam_snap_last_month_d SNAP_Amount_in_Prev_Month_USD

	gen Log_SNAP_Benefits_USD = ln(SNAP_Amount_in_Prev_Month_USD)
	
	rename infl_hd_fam_tot_y_d Income_USD
	
	rename infl_hd_housing_cost_annual_d Housing_Expenditure_USD
	*************************************************************
	
	drop if year < 2001
	gen snap = 0
	replace snap = 1 if hd_fam_snap_last_month_yn == 1 //& inrange(year, 2019, 2023)
	bys panelid: egen snap_by_panel = max(snap)



save "psid.dta", replace



