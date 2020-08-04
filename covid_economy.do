clear 

cd "D:\Rati\Blog\Blog 24"


use COVID-19_merged_25.06.20.dta


//// Wealth Index => utility
foreach var of varlist d3_1 d3_2 d3_3 d3_4 d3_5 d3_6 d3_7 d3_8 d3_9 d3_10 {
gen `var'r = `var' 
}

foreach var of varlist d3_1r d3_2r d3_3r d3_4r d3_5r d3_6r d3_7r d3_8r d3_9r d3_10r {
recode `var' (-9 / -1 = .)
}

gen utility = (d3_1r + d3_2r + d3_3r + d3_4r + d3_5r + d3_6r + d3_7r + d3_8r + d3_9r + d3_10r)


/// gender
/// recoding Female from 2 to 0  /// female = 0 
gen gender = sex
recode gender (2=0) 


/// education
gen education = d2
recode education (1/2 = 1) (3 = 2) (4/5 = 3) (-9 / -1 = .)


///  d6 -- Ethnicity of the respondent  => minority
/* 0 = Georgian   1 = Non-Georgian   */
gen minority = d6
recode minority (4 = 1)  (3 = 0) (2=1) (1=1) (-9 / -1 = .)

////  d1 => havejob 
/* 1 = empl 0 = no */
gen havejob =  d1
recode havejob (5/6 = 1) (1/4 = 0) (7/8 = 0) (-9 / -1 = . )



/// ============================================================================================================================///
/// Trade offs on opening versus staying closed
/// ============================================================================================================================///


//// h1_w2_1 -- It is more important to wait for COVID-19 to subside than to open up the economy
gen wait_w2 = ph1_w2_1 if  wave == 2
gen wait_w3 = ph1_w2_1 if  wave == 3


gen wait_w2_wdk = ph1_w2_1 if  wave == 2
gen wait_w3_wdk = ph1_w2_1 if  wave == 3


recode wait_w2 (-6 = .) (-9 = .) (-5 = .) (-2 = 0) (-1 = 0) (1/2 = 0) (3/4 = 1)if wave == 2
recode wait_w3 (-6 = .) (-9 = .) (-5 = .) (-2 = 0) (-1 = 0) (1/2 = 0) (3/4 = 1)if wave == 3


recode wait_w2_wdk (-6 = .) (-9 = .) (-5 = .) (-2 = .) (-1 = .) (1/2 = 0) (3/4 = 1)if wave == 2
recode wait_w3_wdk (-6 = .) (-9 = .) (-5 = .) (-2 = .) (-1 = .) (1/2 = 0) (3/4 = 1)if wave == 3


/// ph1_w2_2 -- The economic costs of COVID-19 are worse than the virus itself

gen ecost_w2 = ph1_w2_2 if  wave == 2
gen ecost_w3 = ph1_w2_2 if  wave == 3

gen ecost_w2_wdk = ph1_w2_2 if  wave == 2
gen ecost_w3_wdk = ph1_w2_2 if  wave == 3

recode ecost_w2 (-6 = .) (-9 = .) (-5 = .) (-2 = 0) (-1 = 0) (1/2 = 0) (3/4 = 1)if wave == 2
recode ecost_w3 (-6 = .) (-9 = .) (-5 = .) (-2 = 0) (-1 = 0) (1/2 = 0) (3/4 = 1)if wave == 3

recode ecost_w2_wdk (-6 = .) (-9 = .) (-5 = .) (-2 = .) (-1 = .) (1/2 = 0) (3/4 = 1)if wave == 2
recode ecost_w3_wdk (-6 = .) (-9 = .) (-5 = .) (-2 = .) (-1 = .) (1/2 = 0) (3/4 = 1)if wave == 3


//// ph5_w2 -- How long do you think the COVID-19 Crisis will last?

gen uncertaion_ph5_w2 = ph5_w2

recode uncertaion_ph5_w2 (-9 = .) (-5 = .) (-2 = 1) (-1 = 1) (-3 = .) (0/36 = 0) if wave == 2

gen uncertaion_ph5_w3 = ph5_w2

recode uncertaion_ph5_w3 (-9 = .) (-5 = .) (-2 = 1) (-1 = 1) (-3 = .) (0/36 = 0) if wave == 3

//// ph6_w2 -- How long are you prepared to wait for the COVID-19 to subside?

gen uncertaion_ph6_w2 = ph6_w2

recode uncertaion_ph6_w2 (-9 = .) (-5 = .) (-2 = 1) (-1 = 1) (-3 = .) (0/36 = 0) if wave == 2

gen uncertaion_ph6_w3 = ph6_w2

recode uncertaion_ph6_w3 (-9 = .) (-5 = .) (-2 = 1) (-1 = 1) (-3 = .) (0/36 = 0) if wave == 3



svyset [pweight=weight]


stop

/// ============================================================================================================================///
/// Trade offs on opening versus staying closed
/// ============================================================================================================================///

/////  wait

svy: logit wait_w3_wdk i.stratum age gender i.education havejob  minority  utility   if wave == 3



svy: logit wait_w3 i.stratum age gender i.education havejob  minority  utility   if wave == 3
margins, dydx(*) post
marginsplot, horizontal xline(0) yscale(reverse) recast(scatter)

svy: logit wait_w3 i.stratum age gender i.education havejob  minority  utility   if wave == 3
margins, at(stratum=( 1 2 3 ))
marginsplot

svy: logit wait_w3 i.stratum age gender i.education havejob  minority  utility   if wave == 3
margins, at(age=( 18 25 35 45 55 65 ))
marginsplot


///  uncertaion_ph5_w3

svy: logit wait_w3 uncertaion_ph5_w3 i.stratum age gender i.education havejob  minority  utility   if wave == 3

svy: logit wait_w3 uncertaion_ph6_w3 i.stratum age gender i.education havejob  minority  utility   if wave == 3


/////  ecost

svy: logit ecost_w3_wdk  i.stratum age gender i.education havejob  minority  utility   if wave == 3


svy: logit ecost_w3 i.stratum age gender i.education havejob  minority  utility   if wave == 3
margins, dydx(*) post
marginsplot, horizontal xline(0) yscale(reverse) recast(scatter)

svy: logit ecost_w3 i.stratum age gender i.education havejob  minority  utility   if wave == 3
margins, at(stratum=( 1 2 3 ))
marginsplot

svy: logit ecost_w3 uncertaion_ph5_w3 i.stratum age gender i.education havejob  minority  utility   if wave == 3
margins, at(uncertaion_ph5_w3=( 0 1 ))
marginsplot

svy: logit ecost_w3 uncertaion_ph6_w3 i.stratum age gender i.education havejob  minority  utility   if wave == 3
margins, at(uncertaion_ph6_w3=( 0 1 ))
marginsplot