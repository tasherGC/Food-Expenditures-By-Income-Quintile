clear

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


*******************************************************************************
*                           Compile psid database                             *
*******************************************************************************

* PSID package: varname survey-vars, using "$path", design(any) clear keepnotes
 psid use  ///
	|| hd_fam_geosta  ///
		[97]ER12221 [99]ER13004 [01]ER17004 [03]ER21003 [05]ER25003 [07]ER36003 [09]ER42003 [11]ER47303 [13]ER53003 [15]ER60003 [17]ER66003 [19]ER72003 [21]ER78003 [23]ER82003 ///
	|| hd_age_c  ///
		[97]ER10009 [99]ER13010 [01]ER17013 [03]ER21017 [05]ER25017 [07]ER36017 [09]ER42017 [11]ER47317 [13]ER53017 [15]ER60017 [17]ER66017 [19]ER72017 [21]ER78017 [23]ER82018  ///
	|| hd_marr_stat  ///
		[97]ER12223A [99]ER16423 [01]ER20369 [03]ER24150 [05]ER28049 [07]ER41039 [09]ER46983 [11]ER52407 [13]ER58225 [15]ER65461 [17]ER71540 [19]ER77601 [21]ER81928 [23]ER85782  ///
	|| hd_fam_n_c  ///
		[97]ER10008 [99]ER13009 [01]ER17012 [03]ER21016 [05]ER25016 [07]ER36016 [09]ER42016 [11]ER47316 [13]ER53016 [15]ER60016 [17]ER66016 [19]ER72016 [21]ER78016 [23]ER82017  ///	
	|| hd_home_own  ///
		[97]ER10035 [99]ER13040 [01]ER17043 [03]ER21042 [05]ER25028 [07]ER36028 [09]ER42029 [11]ER47329 [13]ER53029 [15]ER60030 [17]ER66030 [19]ER72030 [21]ER78031 [23]ER82032 ///
	|| hd_housing_cost_annual_d  /// 
		[99]ER16515A5 [01]ER20456A5 [03]ER24138A5 [05]ER28037A5 [07]ER41027A5 [09]ER46971A5 [11]ER52395A5 [13]ER58212A5 [15]ER65414 [17]ER71491 [19]ER77520 [21]ER81847 [23]ER85701 ///	
	|| hd_fam_tot_y_d  /// 
		[99]ER16462 [01]ER20456 [03]ER24099 [05]ER28037 [07]ER41027 [09]ER46935 [11]ER52343 [13]ER58152 [15]ER65349 [17]ER71426 [19]ER77448 [21]ER81775 [23]ER85629  ///
	|| hd_fam_home_food_d ///
	[97]ER11076 [99]ER14295 [01]ER18431 [03]ER21696 [05]ER25698 [07]ER36716 [09]ER42722 [11]ER48038 [13]ER53735 [15]ER60750 [17]ER66797 [19]ER72801 [21]ER78878 [23]ER82871 ///
	|| hd_fam_tot_food_d ///
	[99]ER16515A1 [01]ER20456A1 [03]ER24138A1 [05]ER28037A1 [07]ER41027A1 [09]ER46971A1 [11]ER52395A1 [13]ER58212A1 [15]ER65410 [17]ER71487 [19]ER77513 [21]ER81840 [23]ER85694 /// 
	|| long_weights ///
	[97]ER12084 [99]ER16518 [01]ER20394 [03]ER24179 [05]ER28078 [07]ER41069 [09]ER47012 [11]ER52436 [13]ER58257 [15]ER65492 [17]ER71570 [19]ER77631 [21]ER81958 [23]ER85812 ///
			using "$rawd/PSID_Direct_Download_Files" , design(any) clear keepnotes 

psid long

rename wave year

drop if x11102 ==.
drop if xsqnr ==0


*******************************************************************************
*                   Construct households with panel ID                        *
*******************************************************************************


drop if x11102 ==.
drop if xsqnr ==0


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

******* Keep SRC sample only ******************
keep if int68 < 3000 // drop low income and other non-representative samples


				
******* Drop NA values ************************
replace hd_fam_home_food_d = . if hd_fam_home_food_d>99997
drop if hd_fam_geosta == 99
drop if hd_age_c == 999
drop if hd_marr_stat == 9
replace hd_marr_stat = 0 if inlist(hd_marr_stat, 2, 3, 4, 5)
replace hd_home_own = 0 if hd_home_own == 5
replace hd_home_own = 0 if hd_home_own == 8


drop if year < 1999

gen fam_wgt2023 = long_weights if year==2023
bys panelid: egen weight = max(fam_wgt2023)

save "psid.dta", replace


*******************************************************************************
*                         Inflation adjustments                               *
*******************************************************************************
* Adjust for inflation

/*
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
	

* Adjust for inflation

	foreach dv of varlist hd*_d{
		cap drop infl_`dv'
		qui gen infl_`dv' = `dv'/inyixx
		replace infl_`dv'=. if `dv'==.
	}
	
	

*******************************************************************************
*                              Fix state codes                                *
*******************************************************************************

cap drop __00*
cap drop _merge

merge m:1 hd_fam_geosta using "PSID_state_codes.dta"
drop if _merge == 2
rename hd_fam_geosta hd_fam_stacod
rename hd_fam_geosta_full hd_fam_geosta
drop _merge

save "psid.dta", replace



