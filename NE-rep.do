* Ozan Aksoy, prepared as a supplement to "Natural experiments"
* required packages: rdrobust, rddensity
* see https://rdpackages.github.io/rdrobust/ for installation instructions
* required package: DCdensity (https://eml.berkeley.edu/~jmccrary/DCdensity/)

version 17

cd C:\Users\aksoy\Dropbox\Data_Misc\Natural-Exp\Rep
use tr04, clear


// Figure 3
//density test:
preserve
keep if abs(winmar04)<.5
gen Z=winmar04
sort Z

DCdensity Z , breakpoint(0) generate(Xj Yj r0 fhat se_fhat)  nograph
keep Z Yj Xj r0 fhat se_fhat
gen fu=fhat+1.96*se_fhat
gen fl=fhat-1.96*se_fhat

global rvX "Xj>-.5 & Xj<.5"
global rvR "r0>-.5 & r0<.5"
global gr "gray"

local theta2: display %5.3f r(theta)
local tse: display %5.3f r(se)

twoway line fhat r0 if r0>0 & $rvR, lcolor(black) lwidth(medium) ///
	|| line fhat r0 if r0<0 & $rvR, lcolor(black) lwidth(medium) ///
	|| line fu r0 if r0<0 & $rvR, lwidth(vthin)  lcolor($gr) ///
	|| line fu r0 if r0>0 & $rvR, lwidth(vthin) lcolor($gr) ///
	|| line fl r0 if r0<0 & $rvR, lwidth(vthin)  lcolor($gr) ///
	|| line fl r0 if r0>0 & $rvR, lwidth(vthin) lcolor($gr) ///
	   legend(off) ylabel(0(1.25)2.5, nogrid) ///
	   xline(0, lwidth(medium) lpattern(shortdash) lcolor(gs6)) ///
	 graphregion(color(white) lcolor(white) lwidth(thick)) ///
	 saving(grDCall.gph, replace) ///
	 xtitle("") ytitle("McCrary density test")  xlabel(-.5(.25).5) 

graph save MCT, replace	
restore
xx
// other plots
// rdgraph2h program to automatise the figures

capture program drop rdgraph2
program rdgraph2
	args outcome  diff bin lim ytit xtit ylabel xlabel yscale title xscale bw

set level 90
#delimit ;
twoway 
	   lpolyci `outcome' `diff' if `diff'<=0 & `lim', ///
	   lpattern(solid) lwidth(vthin) lcolor(gs6) bw(`bw') ///
	   degree(1) kernel()  ciplot(rline)
	|| lpolyci `outcome'  `diff' if `diff'>0 & `lim', ///
	   lpattern(solid) lwidth(vthin) lcolor(gs6) bw(`bw') ///
	   degree(1) kernel()   ciplot(rline)
	|| lpoly `outcome' `diff' if `diff'<=0 & `lim', ///
	   lpattern(solid) lwidth(medium) lcolor(black) bw(`bw') degree(1) kernel()
	|| lpoly `outcome'  `diff' if `diff'>0 & `lim', ///
	   lpattern(solid) lwidth(medium) lcolor(black) bw(`bw') degree(1) kernel()
	   ylabel(`ylabel' nogrid labsize(3)) ///
	   xlabel(`xlabel') ytitle(`ytit') yscale(`yscale') xscale(`xscale') ///
	   graphregion(color(white) fcolor(white)) ///
	   plotregion(color(white)) title(`title') 
	   xtitle("") legend(off) xline(0, lwidth(.2) ///
	   lpattern(shortdash) lcolor(gs6));
#delimit cr


end

global blim ".1"
global gbw ".08"
global bin "50"
global lim "winmar04 <=.25 & winmar04>=-.25"
global xlabel  "-.20(.10).20,"
global ylabel  "50(10)100,"
global ylabel2 "6(2)12,"
global ylabel4 "40(10)80,"
global ylabel5 "0(5)25,"
global ylabel6 "80(5)100,"
global ylabel7 "120(2)130,"

rdgraph2 F00 winmar04 $bin ///
  "$lim" "General Fertility Rate '96-'00 avg., size(3.5) color(black)" ///
  "" "$ylabel" "$xlabel" "alt" "" "" "$gbw" 
graph save P, replace

rdgraph2 lv winmar04 $bin ///
  "$lim" "Log-regisered electorate 2004, size(3.5) color(black)" ///
  "AK Parti win margin 2004, size(3.5) color(black)" "$ylabel2" ///
  "$xlabel" "" "" "" "$gbw" 
graph save LV, replace

rdgraph2 r00 winmar04 $bin ///
 "$lim" "Percentage married 2000, size(3.5) color(black)" ///
 "AK Parti win margin 2004, size(3.5) color(black)" ///
 "$ylabel4" "$xlabel" "alt" "" "" "$gbw" 
graph save MR, replace


graph combine MCT.gph P.gph LV.gph MR.gph , col(2) ysize(8) xsize(8) ///
      imargin(1 1 1 1) graphregion(color(white) lcolor(white) lwidth(thick)) ///
	  plotregion(lpattern(solid) lcolor(white)) ///
	  b1title("AKP win/lose margin in 2004 elections", size(2.5) color(black))
graph export Fig3.pdf, as(pdf) replace


rdgraph2 F10 winmar04 $bin ///
 "$lim" "Fertility: (a-GFR 06-10 average), size(3.5) color(black)" ///
 "AK Parti win margin 2004, size(3.5) color(black)" ///
 "$ylabel4" "$xlabel" "" "" "" "$gbw", name(A)
graph save A, replace

 rdgraph2 d_rw09_3 winmar04 $bin ///
 "$lim" "Marriage: (MPR'09 Women, 25-29), size(3.5) color(black)" ///
 "AK Parti win margin 2004, size(3.5) color(black)" ///
 "$ylabel7" "$xlabel" "alt" "" "" "$gbw", name(B)
graph save B, replace
 
 rdgraph2 d_rm09_3 winmar04 $bin ///
 "$lim" "Marriage: (MPR'09 Men, 25-29), size(3.5) color(black)" ///
 "AK Parti win margin 2004, size(3.5) color(black)" ///
 "$ylabel6" "$xlabel" "" "" "" "$gbw", name(C)
graph save C, replace
 
 graph combine A.gph B.gph C.gph, col(2) ysize(8) xsize(8) ///
      imargin(1 1 1 1) graphregion(color(white) lcolor(white) lwidth(thick)) ///
	  plotregion(lpattern(solid) lcolor(white)) ///
	  b1title("AKP win/lose margin in 2004 elections", size(2.5) color(black))
graph export Fig4.pdf, as(pdf) replace

// RDD estimates
// placebo tests
rddensity winmar04
rdrobust F00 winmar04
rdrobust lv winmar04
rdrobust r00 winmar04

// "causal" effects
rdrobust F10 winmar04
rdrobust d_rw09_3 winmar04
rdrobust d_rm09_3 winmar04 
xxx
