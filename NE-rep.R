# Ozan Aksoy, prepared as a supplement to 
# Aksoy (2023) "Natural experiments for sociological research"

D <- haven::read_dta("tr04.dta")

library('rddensity')
library('lpdensity')
library('tidyverse')
library('rdrobust')

#Table 2: RDD point estimates
#placebo outcomes
summary(rdrobust(D$F00, D$winmar04))
summary(rdrobust(D$r00, D$winmar04))
summary(rdrobust(D$lv, D$winmar04))
#main outcomes
summary(rdrobust(D$F10, D$winmar04))
summary(rdrobust(D$d_rw09_3, D$winmar04))
summary(rdrobust(D$d_rm09_3, D$winmar04))


#Some variant of figure 3's panels
#McCrary density plot (Fig3-A):
density <- rdplotdensity(rddensity(X = D$winmar04), X = D$winmar04)
print(density$Estplot)

#Placebo tests, rest of the panels in Figure 3:
D$T <- ifelse(D$winmar04 > 0, 1, 0)
D2 <- D |>
  filter( abs(winmar04)<0.15 )

  rd1 <- rddapp::rd_est(F00 ~ winmar04 + T, data = D2, cutpoint = 0, t.design = "geq") 
  rd2 <- rddapp::rd_est(lv ~ winmar04 + T, data = D2, cutpoint = 0, t.design = "geq") 
  rd3 <- rddapp::rd_est(r00 ~ winmar04 + T, data = D2, cutpoint = 0, t.design = "geq") 
  
  plot(rd1, fit_line = "quadratic")
  title("a-GFR 96-00 avg")
  plot(rd2, fit_line = "quadratic")
  title("log-registered electorate")
  plot(rd3, fit_line = "quadratic")
  title("% married in 2000")

#Some variant of figure 4's panels:

  rd5 <- rddapp::rd_est(F10 ~ winmar04 + T, data = D2, cutpoint = 0, t.design = "geq") 
  rd6 <- rddapp::rd_est(d_rm09_3 ~ winmar04 + T, data = D2, cutpoint = 0, t.design = "geq")   
  rd7 <- rddapp::rd_est(d_rw09_3 ~ winmar04 + T, data = D2, cutpoint = 0, t.design = "geq") 
  
  plot(rd5, fit_line = "quadratic")
  title("Fertility (a-GFR 06-10 avg)")
  
  plot(rd6, fit_line = "quadratic")
  title("Marriage: MPR'09 men, 25-29")
  
  plot(rd7, fit_line = "quadratic")
  title("Marriage: MPR'09 women, 25-29")