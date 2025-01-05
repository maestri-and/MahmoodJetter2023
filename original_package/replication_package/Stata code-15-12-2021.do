clear all
set maxvar 15000
cd "C:\Users\rm6074\Dropbox\Drones\Revision\EJ final submission package\3 replication package\"
import delimited "drones data.csv", clear
save "Data-main-15-12-2021", replace
import delimited "anti-us sentiment.csv", clear
merge 1:1 date using "Data-main-15-12-2021"
drop _m
save "Data-main-15-12-2021", replace
import delimited "GTD and SATP data.csv", clear
merge 1:1 date using "Data-main-15-12-2021"
drop _m
save "Data-main-15-12-2021", replace
import delimited "news sentiment.csv", clear
merge 1:1 date using "Data-main-15-12-2021"
drop _m
save "Data-main-15-12-2021", replace
import delimited "weather data from meteoblue.csv", clear
merge 1:1 date using "Data-main-15-12-2021"
drop _m
save "Data-main-15-12-2021", replace
label variable avgterrornegemo "Average neg emotions in articles(top story/national)mentioning terrorists"
label variable avgterrornousnegemo "Average neg emotions in articles(top story/national)mentioning terrorists not US"
label variable avgterrornodronenegemo "Average neg emotions in articles(top story/national)mentioning terrorists not drone"
label variable avgusnegemo "Average neg emotions in articles(top story/national)mentioning the US"
label variable avgdronenegemo "Average neg emotions in articles(top story/national)mentioning drone"
label variable avgusnodronenegemo "Average neg emotions in articles(top story/national)mentioning the US not drone"
label variable avgusnoterrornegemo "Average neg emotions in articles(top story/national)mentioning the US not terrorists"
label variable avgterrorposemo "Average pos emotions in articles(top story/national)mentioning terrorists"
label variable avgterrornousposemo "Average pos emotions in articles(top story/national)mentioning terrorists not US"
label variable avgterrornodroneposemo "Average pos emotions in articles(top story/national)mentioning terrorists not drone"
label variable avgusposemo "Average pos emotions in articles(top story/national)mentioning the US"
label variable avgdroneposemo "Average pos emotions in articles(top story/national)mentioning drone"
label variable avgusnodroneposemo "Average pos emotions in articles(top story/national)mentioning the US not drone"
label variable avgusnoterrorposemo "Average pos emotions in articles(top story/national)mentioning the US not terrorists"
label variable avgterroranger "Average anger in articles(top story/national)mentioning terrorists"
label variable avgterrornousanger "Average anger in articles(top story/national)mentioning terrorists not US"
label variable avgterrornodroneanger "Average anger in articles(top story/national)mentioning terrorists not drone"
label variable avgusanger "Average anger in articles(top story/national)mentioning the US"
label variable avgdroneanger "Average anger in articles(top story/national)mentioning drone"
label variable avgusnoterroranger "Average anger in articles(top story/national)mentioning the US not terrorists"
label variable avgusnodroneanger "Average anger in articles(top story/national)mentioning the US not drone"

label variable topterrornegemo "Average neg emotions in articles(top story)mentioning terrorists"
label variable topterrornousnegemo "Average neg emotions in articles(top story)mentioning terrorists not US"
label variable topterrornodronenegemo "Average neg emotions in articles(top story)mentioning terrorists not drone"
label variable topusnegemo "Average neg emotions in articles(top story)mentioning the US"
label variable topusnodronenegemo "Average neg emotions in articles(top story)mentioning the US not drone"
label variable topusnoterrornegemo "Average neg emotions in articles(top story)mentioning the US not terrorists"
label variable topterrorposemo "Average pos emotions in articles(top story)mentioning terrorists"
label variable topterrornousposemo "Average pos emotions in articles(top story)mentioning terrorists not US"
label variable topterrornodroneposemo "Average pos emotions in articles(top story)mentioning terrorists not drone"
label variable topusposemo "Average pos emotions in articles(top story)mentioning the US"
label variable topusnodroneposemo "Average pos emotions in articles(top story)mentioning the US not drone"
label variable topusnoterrorposemo "Average pos emotions in articles(top story)mentioning the US not terrorists"
label variable topterroranger "Average anger in articles(top story)mentioning terrorists"
label variable topterrornousanger "Average anger in articles(top story)mentioning terrorists not US"
label variable topterrornodroneanger "Average anger in articles(top story)mentioning terrorists not drone"
label variable topusanger "Average anger in articles(top story)mentioning the US"
label variable topusnoterroranger "Average anger in articles(top story)mentioning the US not terrorists"
label variable topusnodroneanger "Average anger in articles(top story)mentioning the US not drone"

label variable senavgterrornegemo "Average neg emotions in sentences(top story/national)mentioning terrorists"
label variable senavgterrornousnegemo "Average neg emotions in sentences(top story/national)mentioning terrorists not US"
label variable senavgterrornodronenegemo "Average neg emotions in sentences(top story/national)mentioning terrorists not drone"
label variable senavgusnegemo "Average neg emotions in sentences(top story/national)mentioning the US"
label variable senavgusnodronenegemo "Average neg emotions in sentences(top story/national)mentioning the US not drone"
label variable senavgusnoterrornegemo "Average neg emotions in sentences(top story/national)mentioning the US not terrorists"
label variable senavgterrorposemo "Average pos emotions in sentences(top story/national)mentioning terrorists"
label variable senavgterrornousposemo "Average pos emotions in sentences(top story/national)mentioning terrorists not US"
label variable senavgterrornodroneposemo "Average pos emotions in sentences(top story/national)mentioning terrorists not drone"
label variable senavgusposemo "Average pos emotions in sentences(top story/national)mentioning the US"
label variable senavgusnodroneposemo "Average pos emotions in sentences(top story/national)mentioning the US not drone"
label variable senavgusnoterrorposemo "Average pos emotions in sentences(top story/national)mentioning the US not terrorists"
label variable senavgterroranger "Average anger in sentences(top story/national)mentioning terrorists"
label variable senavgterrornousanger "Average anger in sentences(top story/national)mentioning terrorists not US"
label variable senavgterrornodroneanger "Average anger in sentences(top story/national)mentioning terrorists not drone"
label variable senavgusanger "Average anger in sentences(top story/national)mentioning the US"
label variable senavgusnoterroranger "Average anger in sentences(top story/national)mentioning the US not terrorists"
label variable senavgusnodroneanger "Average anger in sentences(top story/national)mentioning the US not drone"
label variable crit1in7 "attacks in the next 7 days meeting criterion 1 in GTD"
label variable crit2in7 "attacks in the next 7 days meeting criterion 2 in GTD"
label variable crit3in7 "attacks in the next 7 days meeting criterion 3 in GTD"
label variable preciraq "Total precipitation in Baghdad"
label variable precisrael "Total precipitation in Jerusalem"
label variable gusts_karachi "max wind gust (km/hr) 10m above ground in Karachi"
label variable tvideo "google trends for the search term taliban video"
label variable jihad "google trends for the search term jihad"
label variable zarb "google trends for the search term zarb-e-momin"
label variable usefp "google trends for the search term usefp"
label variable usaid "google trends for the search term usaid"
label variable usimmi "google trends for the search term US immigration"
label variable ghazwa "google trends for the search term ghazwa-e-hind"
label variable tmean2_mir "mean temperature (C) 2m above ground in Miran Shah"
label variable prec_mir "total precipitation in Miran shah"
label variable wind "wind speed (km/h) mean 80m above ground in Miran Shah"
label variable gusts "max wind gust (km/h) 10 m above ground in Miran Shah"
label variable lnprec "Ln(Total precipitation in Miran Shah: prec_mir)"
label variable tmean2iraq "Temperature mean 2m above ground in Baghdad"
label variable tmean2israel "Temperature mean 2m above ground in Jerusalem"
label variable gustsiraq "max wind gust (km/hr) 10m above ground in Baghdad"
label variable gustsisrael "max wind gust (km/hr) 10m above ground in Jerusalem"
label variable above "Wind gusts above the threshold (27.78km/h) Y/N"
label variable numdrone "Number of drone articles"
label variable numus "Number of articles mentioning the US"
label variable numterror "Number of articles mentioning terrorists"
label variable bomb "Bombings/Explosions in a day coded from GTD"
label variable assassination "Assasinations in a day coded from GTD"
label variable attacks "terror attacks in Pakistan -GTD"
label variable deaths "No. of deaths from terrorism in Pakistan-GTD"
label variable fata "Terrorist attacks in FATA"
label variable govt "terror attacks on govt coded from GTD targtype1=2,3,4,6,7,8,9,11,16,18,19,21"
label variable business "terror attacks on business coded from GTD targtype1=1"
label variable private "terror attacks on private property/citizens coded from GTD targtype1=14"
label variable attacksafg "terror attacks in Afghanistan from GTD"
label variable nonfata "Terror attacks outside FATA from GTD"
label variable assault "Armed plus unarmed assaults today from GTD"
label variable kidnapping "Hostage taking (kidnapping and barricade incidents) today from GTD"
label variable attacksisrael "Attacks in Israel from GTD"
label variable attrel "Attacks by religious organizations excluding unknown attacks"
label variable attnonrel "Attacks by non-religious organizations excluding unknown attacks"
label variable attsep "Attacks by separatists from GTD"
label variable attacksiraq "Attacks in Iraq from GTD"
label variable w_total "Total types of weapons used in attacks in the next 7 days"
label variable a_reltargeted "Attacks by religious organizations directly targeted by drones excluding unknown"
label variable severe "Severity of terror attacks (deaths per attack)"
label variable leadarrest "Terrorist leaders arrest incidents, source SATP"
label variable dumarrest "incident of arrest of terrorist leader (y/n)"
label variable prot_ter "Protests,actor1=Pakistan, actor2=Rebels, separatists, insurgents(GDELT)"
label variable prot_terdum "Binary indicator for prot_ter"
label variable prot_us "Protests,actor1=Pakistan, actor2=USA(GDELT)"
label variable prot_usdum "Binary indicator for prot_us"
label variable drones  "No. of drone strikes in Pakistan-TBIJ"
label variable drone_naf "Number of drone strikes from New America Foundation"
label variable target1 "Drone strikes with target description"
label variable target3 "Drone strikes targeting leaders"
label variable unknown "Drone strikes without target description"
label variable unknown2 "Drone strikes not targeting leaders"
label variable mil_act "No. of actions by Pak military against terrorists-PICSS"
label variable ramadan "Ramadan (Y/N)"
save "Data-main-15-12-2021",replace

use "Data-main-15-12-2021",clear
************************************************
g lnpreciraq=ln(1+preciraq)
g lnprecisrael=ln(1+precisrael)
*******Standardizing***********
foreach x of varlist avgterrornegemo avgterrornousnegemo avgterrornodronenegemo avgusnegemo avgdronenegemo avgusnodronenegemo avgusnoterrornegemo avgterrorposemo avgterrornousposemo avgterrornodroneposemo avgusposemo avgdroneposemo avgusnodroneposemo avgusnoterrorposemo avgterroranger avgterrornousanger avgterrornodroneanger avgusanger avgdroneanger avgusnoterroranger avgusnodroneanger topterrornegemo topterrornousnegemo topterrornodronenegemo topusnegemo topusnodronenegemo topusnoterrornegemo topterrorposemo topterrornousposemo topterrornodroneposemo topusposemo topusnodroneposemo topusnoterrorposemo topterroranger topterrornousanger topterrornodroneanger topusanger topusnodroneanger topusnoterroranger senavgterrornegemo senavgterrornousnegemo senavgterrornodronenegemo senavgterrorposemo senavgterrornousposemo senavgterrornodroneposemo senavgterroranger senavgterrornousanger senavgterrornodroneanger senavgusnegemo senavgusnodronenegemo senavgusnoterrornegemo senavgusposemo senavgusnodroneposemo senavgusnoterrorposemo senavgusanger senavgusnodroneanger senavgusnoterroranger{
	replace `x'=0 if `x'==.
	replace `x'=. if date<16892
	egen `x'std=std(`x')
	rename `x' `x'orig
	rename `x'std `x'
}

foreach x of varlist jihad prot_ter prot_terdum prot_us prot_usdum tvideo zarb ghazwa usaid usimmi usefp{
egen `x'std=std(`x')
	rename `x' `x'orig
	rename `x'std `x'
}
***********************************************
*Preps for leads, lags, and binary indicators
***********************************************
sort date
foreach x of varlist attacks deaths{
     g `x'in1=`x'[_n+1]
	 g `x'in2=(`x'[_n+1]+`x'[_n+2])/2
	 g `x'in3=(`x'[_n+1]+`x'[_n+2]+`x'[_n+3])/3
	 g `x'in4=(`x'[_n+1]+`x'[_n+2]+`x'[_n+3]+`x'[_n+4])/4
	 g `x'in5=(`x'[_n+1]+`x'[_n+2]+`x'[_n+3]+`x'[_n+4]+`x'[_n+5])/5
	 g `x'in6=(`x'[_n+1]+`x'[_n+2]+`x'[_n+3]+`x'[_n+4]+`x'[_n+5]+`x'[_n+6])/6
	 g `x'in7=(`x'[_n+1]+`x'[_n+2]+`x'[_n+3]+`x'[_n+4]+`x'[_n+5]+`x'[_n+6]+`x'[_n+7])/7
	 g `x'in8=(`x'[_n+1]+`x'[_n+2]+`x'[_n+3]+`x'[_n+4]+`x'[_n+5]+`x'[_n+6]+`x'[_n+7]+`x'[_n+8])/8
	 g `x'in9=(`x'[_n+1]+`x'[_n+2]+`x'[_n+3]+`x'[_n+4]+`x'[_n+5]+`x'[_n+6]+`x'[_n+7]+`x'[_n+8]+`x'[_n+9])/9
	 g `x'in10=(`x'[_n+1]+`x'[_n+2]+`x'[_n+3]+`x'[_n+4]+`x'[_n+5]+`x'[_n+6]+`x'[_n+7]+`x'[_n+8]+`x'[_n+9]+`x'[_n+10])/10
	 g `x'in11=(`x'[_n+1]+`x'[_n+2]+`x'[_n+3]+`x'[_n+4]+`x'[_n+5]+`x'[_n+6]+`x'[_n+7]+`x'[_n+8]+`x'[_n+9]+`x'[_n+10]+`x'[_n+11])/11
	 g `x'in12=(`x'[_n+1]+`x'[_n+2]+`x'[_n+3]+`x'[_n+4]+`x'[_n+5]+`x'[_n+6]+`x'[_n+7]+`x'[_n+8]+`x'[_n+9]+`x'[_n+10]+`x'[_n+11]+`x'[_n+12])/12
	 g `x'in13=(`x'[_n+1]+`x'[_n+2]+`x'[_n+3]+`x'[_n+4]+`x'[_n+5]+`x'[_n+6]+`x'[_n+7]+`x'[_n+8]+`x'[_n+9]+`x'[_n+10]+`x'[_n+11]+`x'[_n+12]+`x'[_n+13])/13
	 g `x'in14=(`x'[_n+1]+`x'[_n+2]+`x'[_n+3]+`x'[_n+4]+`x'[_n+5]+`x'[_n+6]+`x'[_n+7]+`x'[_n+8]+`x'[_n+9]+`x'[_n+10]+`x'[_n+11]+`x'[_n+12]+`x'[_n+13]+`x'[_n+14])/14
	 g `x'in21=(`x'in14*14+`x'[_n+15]+`x'[_n+16]+`x'[_n+17]+`x'[_n+18]+`x'[_n+19]+`x'[_n+20]+`x'[_n+21])/21
	 g `x'in28=(`x'in21*21+`x'[_n+22]+`x'[_n+23]+`x'[_n+24]+`x'[_n+25]+`x'[_n+26]+`x'[_n+27]+`x'[_n+28])/28
	 g `x'15to21=(`x'[_n+15]+`x'[_n+16]+`x'[_n+17]+`x'[_n+18]+`x'[_n+19]+`x'[_n+20]+`x'[_n+21])/7
	 g `x'15to28=(`x'[_n+15]+`x'[_n+16]+`x'[_n+17]+`x'[_n+18]+`x'[_n+19]+`x'[_n+20]+`x'[_n+21]+`x'[_n+22]+`x'[_n+23]+`x'[_n+24]+`x'[_n+25]+`x'[_n+26]+`x'[_n+27]+`x'[_n+28])/14
	 g `x'15to70=(`x'15to28*14+`x'[_n+29]+`x'[_n+30]+`x'[_n+31]+`x'[_n+32]+`x'[_n+33]+`x'[_n+34]+`x'[_n+35]+`x'[_n+36]+`x'[_n+37]+`x'[_n+38]+`x'[_n+39]+`x'[_n+40]+`x'[_n+41]+`x'[_n+42]+`x'[_n+43]+`x'[_n+44]+`x'[_n+45]+`x'[_n+46]+`x'[_n+47]+`x'[_n+48]+`x'[_n+49]+`x'[_n+50]+`x'[_n+51]+`x'[_n+52]+`x'[_n+53]+`x'[_n+54]+`x'[_n+55]+`x'[_n+56]+`x'[_n+57]+`x'[_n+58]+`x'[_n+59]+`x'[_n+60]+`x'[_n+61]+`x'[_n+62]+`x'[_n+63]+`x'[_n+64]+`x'[_n+65]+`x'[_n+66]+`x'[_n+67]+`x'[_n+68]+`x'[_n+69]+`x'[_n+70])/56
}



foreach x of varlist a_reltargeted attrel attnonrel attsep drones jihad tvideo zarb ghazwa     usaid usimmi usefp prot_us prot_usdum prot_ter prot_terdum bomb assault kidnapping assassination govt business private fata nonfata{
	replace `x'=0 if `x'==.
	g `x'in7=(`x'[_n+1]+`x'[_n+2]+`x'[_n+3]+`x'[_n+4]+`x'[_n+5]+`x'[_n+6]+`x'[_n+7])/7
	g `x'in14=(`x'[_n+1]+`x'[_n+2]+`x'[_n+3]+`x'[_n+4]+`x'[_n+5]+`x'[_n+6]+`x'[_n+7]+`x'[_n+8]+`x'[_n+9]+`x'[_n+10]+`x'[_n+11]+`x'[_n+12]+`x'[_n+13]+`x'[_n+14])/14
}

foreach x of varlist attacksiraq attacksisrael{
	replace `x'=0 if `x'==.
	g `x'in7=(`x'[_n+1]+`x'[_n+2]+`x'[_n+3]+`x'[_n+4]+`x'[_n+5]+`x'[_n+6]+`x'[_n+7])/7
	}

foreach x of varlist numdrone numus numterror avgusnodroneanger avgdronenegemo avgdroneanger avgdroneposemo avgusnegemo avgusanger avgusposemo avgusnoterrornegemo avgusnoterroranger avgusnoterrorposemo avgusnodronenegemo avgusnodroneposemo avgterrornegemo avgterroranger avgterrorposemo avgterrornousnegemo avgterrornousanger avgterrornousposemo avgterrornodronenegemo avgterrornodroneanger avgterrornodroneposemo  {
	g `x'in7=(`x'[_n+1]+`x'[_n+2]+`x'[_n+3]+`x'[_n+4]+`x'[_n+5]+`x'[_n+6]+`x'[_n+7])/7
	g `x'in14=(`x'[_n+1]+`x'[_n+2]+`x'[_n+3]+`x'[_n+4]+`x'[_n+5]+`x'[_n+6]+`x'[_n+7]+`x'[_n+8]+`x'[_n+9]+`x'[_n+10]+`x'[_n+11]+`x'[_n+12]+`x'[_n+13]+`x'[_n+14])/14
}

foreach x of varlist gusts wind drones attacks deaths mil_act attacksisrael attacksafg severe w_total jihad tvideo zarb attacksiraq avgusnodroneanger numdrone numus numterror a_reltargeted attrel attnonrel attsep avgdronenegemo avgdroneanger avgdroneposemo avgusnegemo avgusanger avgusposemo avgusnoterrornegemo avgusnoterroranger avgusnoterrorposemo avgusnodronenegemo avgusnodroneposemo avgterrornegemo avgterroranger avgterrorposemo avgterrornousnegemo avgterrornousanger avgterrornousposemo avgterrornodronenegemo avgterrornodroneanger avgterrornodroneposemo ghazwa     usaid usimmi usefp bomb assault kidnapping assassination govt business private fata nonfata prot_us prot_usdum prot_ter prot_terdum {
	g `x'1=`x'[_n-1]
	g `x'2=`x'[_n-2]
	g `x'3=`x'[_n-3]
	g `x'4=`x'[_n-4]
	g `x'5=`x'[_n-5]
	g `x'6=`x'[_n-6]
	g `x'7=`x'[_n-7]
	g `x'8=`x'[_n-8]
	g `x'9=`x'[_n-9]
	g `x'10=`x'[_n-10]
	g `x'11=`x'[_n-11]
	g `x'12=`x'[_n-12]
	g `x'13=`x'[_n-13]
	g `x'14=`x'[_n-14]
}

g severein7=deathsin7/attacksin7
g severelag14=(deaths1+deaths2+deaths3+deaths4+deaths5+deaths6+deaths7+deaths8+deaths9+deaths10+deaths11+deaths12+deaths13+deaths14)/(attacks1+attacks2+attacks3+attacks4+attacks5+attacks6+attacks7+attacks8+attacks9+attacks10+attacks11+attacks12+attacks13+attacks14)
g attacksafglag1=(attacksafg1+attacksafg2+attacksafg3+attacksafg4+attacksafg5+attacksafg6+attacksafg7)
g attacksafglag2=(attacksafg1+attacksafg2+attacksafg3+attacksafg4+attacksafg5+attacksafg6+attacksafg7+attacksafg8+attacksafg9+attacksafg10+attacksafg11+attacksafg12+attacksafg13+attacksafg14)


*** Generating vars for averages
sort date
foreach x of varlist attacks drones gusts tmean2_mir lnprec mil_act {
	g `x'avg3=(`x'[_n-2]+`x'[_n-1]+`x')/3
	g `x'avg6=(`x'[_n-5]+`x'[_n-4]+`x'[_n-3]+`x'[_n-2]+`x'[_n-1]+`x')/6
	g `x'avg14=(`x'[_n-13]+`x'[_n-12]+`x'[_n-11]+`x'[_n-10]+`x'[_n-9]+`x'[_n-8]+`x'[_n-7]+`x'[_n-6]+`x'[_n-5]+`x'[_n-4]+`x'[_n-3]+`x'[_n-2]+`x'[_n-1]+`x')/14
}
g date3=date/3
g date6=date/6
g date14=date/14

g ign3=(mod(date3,1)>0)
g ign6=(mod(date6,1)>0)
g ign14=(mod(date14,1)>0)

foreach x of varlist attacks mil_act drones {
	g `x'avg3lag=`x'avg3[_n-3]
	g `x'avg3lag2=`x'avg3[_n-6]
	g `x'avg3lag3=`x'avg3[_n-9]
	g `x'avg3lag4=`x'avg3[_n-12]
	g `x'avg6lag=`x'avg6[_n-6]
	g `x'avg6lag2=`x'avg6[_n-12]
	g `x'avg14lag=`x'avg14[_n-14]
	g `x'avg14lag2=`x'avg14[_n-28]
	g `x'avg3lead=`x'avg3[_n+3]
	g `x'avg6lead=`x'avg6[_n+6]
	g `x'avg14lead=`x'avg14[_n+14]
}

foreach x of varlist avgusnegemo avgusanger avgusposemo avgusnoterrornegemo avgusnoterroranger avgusnoterrorposemo avgusnodronenegemo avgusnodroneanger avgusnodroneposemo avgterrornegemo avgterroranger avgterrorposemo avgterrornousnegemo avgterrornousanger avgterrornousposemo avgterrornodronenegemo avgterrornodroneanger avgterrornodroneposemo {
	replace `x'=. if senavgusnegemo==.
}
foreach x of varlist senavgusnegemo senavgusanger senavgusposemo senavgusnoterrornegemo senavgusnoterroranger senavgusnoterrorposemo senavgusnodronenegemo senavgusnodroneanger senavgusnodroneposemo senavgterrornegemo senavgterroranger senavgterrorposemo senavgterrornousnegemo senavgterrornousanger senavgterrornousposemo senavgterrornodronenegemo senavgterrornodroneanger senavgterrornodroneposemo {
	*replace `x'=0 if `x'==.
	g `x'in7=(`x'[_n+1]+`x'[_n+2]+`x'[_n+3]+`x'[_n+4]+`x'[_n+5]+`x'[_n+6]+`x'[_n+7])/7
}
foreach x of varlist senavgusnegemo senavgusanger senavgusposemo senavgusnoterrornegemo senavgusnoterroranger senavgusnoterrorposemo senavgusnodronenegemo senavgusnodroneanger senavgusnodroneposemo senavgterrornegemo senavgterroranger senavgterrorposemo senavgterrornousnegemo senavgterrornousanger senavgterrornousposemo senavgterrornodronenegemo senavgterrornodroneanger senavgterrornodroneposemo {
	g `x'1=`x'[_n-1]
	g `x'2=`x'[_n-2]
	g `x'3=`x'[_n-3]
	g `x'4=`x'[_n-4]
	g `x'5=`x'[_n-5]
	g `x'6=`x'[_n-6]
	g `x'7=`x'[_n-7]
	g `x'8=`x'[_n-8]
	g `x'9=`x'[_n-9]
	g `x'10=`x'[_n-10]
	g `x'11=`x'[_n-11]
	g `x'12=`x'[_n-12]
	g `x'13=`x'[_n-13]
	g `x'14=`x'[_n-14]
}
foreach x of varlist topusnegemo topusanger topusposemo topusnoterrornegemo topusnoterroranger topusnoterrorposemo topusnodronenegemo topusnodroneanger topusnodroneposemo topterrornegemo topterroranger topterrorposemo topterrornousnegemo topterrornousanger topterrornousposemo topterrornodronenegemo topterrornodroneanger topterrornodroneposemo {
	*replace `x'=0 if `x'==.
	g `x'in7=(`x'[_n+1]+`x'[_n+2]+`x'[_n+3]+`x'[_n+4]+`x'[_n+5]+`x'[_n+6]+`x'[_n+7])/7
}
foreach x of varlist topusnegemo topusanger topusposemo topusnoterrornegemo topusnoterroranger topusnoterrorposemo topusnodronenegemo topusnodroneanger topusnodroneposemo topterrornegemo topterroranger topterrorposemo topterrornousnegemo topterrornousanger topterrornousposemo topterrornodronenegemo topterrornodroneanger topterrornodroneposemo {
	g `x'1=`x'[_n-1]
	g `x'2=`x'[_n-2]
	g `x'3=`x'[_n-3]
	g `x'4=`x'[_n-4]
	g `x'5=`x'[_n-5]
	g `x'6=`x'[_n-6]
	g `x'7=`x'[_n-7]
	g `x'8=`x'[_n-8]
	g `x'9=`x'[_n-9]
	g `x'10=`x'[_n-10]
	g `x'11=`x'[_n-11]
	g `x'12=`x'[_n-12]
	g `x'13=`x'[_n-13]
	g `x'14=`x'[_n-14]
}
g dum=(dronesin7>0)
**********generating binary indicators for days of the week and months
gen dow=dow(date)
tab dow, gen(dows)
gen month=month(date)
tab month, gen(months)

tsset date
format date %td
***Tables**********
*************************************************************************************************
*** T1: Summary stats
************************************************************************************************************************************
sutex drones attacks gusts wind mil_act ramadan tmean2_mir prec_mir , dig(2) par minmax


************************************************************************************************************************************
*** F2: Scatterplots
************************************************************************************************************************************
* Panel A: Wind gusts and drone strikes 
binscatter drones gusts, controls(dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 attacks1 attacks2 attacks3 attacks4 attacks5 attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14 tmean2_mir lnprec) msymbol(diamond_hollow) lcolor(gs2) xtitle("Wind gusts on day t") yscale(range(0 0.2)) ylabel(0(0.05)0.2)  ytitle("Drone strikes on day t") reportreg
gr export "f2a.eps", replace
!epstopdf "f2a.eps"

* Panel B: Wind gusts in Karachi and drone strikes 
binscatter drones gusts_karachi, controls(dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14  attacks1 attacks2 attacks3 attacks4 attacks5 attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14  tmean2_mir lnprec) msymbol(diamond_hollow) lcolor(gs2) xtitle("Wind gusts on day t") yscale(range(0 0.2)) ylabel(0(0.05)0.2) ytitle("Drone strikes on day t") reportreg
gr export "f2b.eps", replace
!epstopdf "f2b.eps"

* Panel C: Wind gusts and terror attacks 
binscatter attacksin7 gusts, controls(dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 attacks1 attacks2 attacks3 attacks4 attacks5 attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14 tmean2_mir lnprec) msymbol(diamond_hollow) lcolor(gs2) xtitle("Wind gusts on day t") yscale(range(2.6 3.1)) ylabel(2.6(0.1)3.1) ytitle("Terror attacks per day on days t+1 to t+7") reportreg
gr export "f2c.eps", replace
!epstopdf "f2c.eps"

* Panel D: Wind gusts in Karachi and terror attacks 
binscatter attacksin7 gusts_karachi, controls(dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 attacks1 attacks2 attacks3 attacks4 attacks5 attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14  tmean2_mir lnprec) msymbol(diamond_hollow) lcolor(gs2) xtitle("Wind gusts on day t") yscale(range(2.6 3.1)) ylabel(2.6(0.1)3.1) ytitle("Terror attacks per day on days t+1 to t+7") reportreg
gr export "f2d.eps", replace
!epstopdf "f2d.eps"

* Panel E: Wind gusts and past attacks
binscatter attacks1 gusts, controls(dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 attacks2 attacks3 attacks4 attacks5 attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14 tmean2_mir lnprec) msymbol(diamond_hollow) lcolor(gs2) xtitle("Wind gusts on day t") yscale(range(2.4 3.2)) ylabel(2.4(0.2)3.2)  ytitle("Terror attacks on day t-1") reportreg
gr export "f2e.eps", replace
!epstopdf "f2e.eps"

* Panel F: Wind gusts and past military actions
binscatter mil_act1 gusts, controls(dows* ramadan date months* mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 attacks1 attacks2 attacks3 attacks4 attacks5 attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14 tmean2_mir lnprec) msymbol(diamond_hollow) lcolor(gs2) xtitle("Wind gusts on day t") yscale(range(0.6 1.4)) ylabel(0.6(0.2)1.4)  ytitle("Pakistani military actions on day t-1") reportreg
gr export "f2f.eps", replace
!epstopdf "f2f.eps"


************************************************************************************************************************************
*** T2: Main results 
************************************************************************************************************************************
*** IV
eststo drop *
* Baseline 
eststo: ivreg2 attacksin7 (drones=gusts) dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 attacks1 attacks2 attacks3 attacks4 attacks5 attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14 tmean2_mir lnprec, r bw(1) first endogtest(drones)
estadd scalar fstat =e(widstat)
weakiv
* Wind speed
eststo: ivreg2 attacksin7 (drones=wind) dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 attacks1 attacks2 attacks3 attacks4 attacks5 attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14 tmean2_mir lnprec, r bw(1) first endogtest(drones)
estadd scalar fstat =e(widstat)
weakiv
* 3-day averages
eststo: ivreg2 attacksavg3lead (dronesavg3=gustsavg3) dows* ramadan date months* mil_actavg3 mil_actavg3lag mil_actavg3lag2 mil_actavg3lag3 mil_actavg3lag4 attacksavg3 attacksavg3lag attacksavg3lag2 attacksavg3lag3 attacksavg3lag4 tmean2_miravg3 lnprecavg3 if ign3==0, r bw(1) first endogtest(dronesavg3)
estadd scalar fstat =e(widstat)
weakiv
* 6-day averages
eststo: ivreg2 attacksavg6lead (dronesavg6=gustsavg6) dows* ramadan date months* mil_actavg6 mil_actavg6lag attacksavg6 attacksavg6lag tmean2_miravg6 lnprecavg6 if ign6==0, r bw(1) first endogtest(dronesavg6)
estadd scalar fstat =e(widstat)
weakiv
* 14-day averages
eststo: ivreg2 attacksavg14lead (dronesavg14=gustsavg14) ramadan date months* mil_actavg14 attacksavg14 tmean2_miravg14 lnprecavg14 if ign14==0, r bw(1) first endogtest(dronesavg14)
estadd scalar fstat =e(widstat)
weakiv
esttab using "1.tex", se replace se(4) b(4) drop(_cons months* dows* attacks* mil_act* tmean2_mir lnprec ramadan date) star(* 0.10 ** 0.05 *** 0.01) sca(fstat olea oleacric oleacric2) 


*** IV (lag 15 option)
eststo drop *
* Baseline 
eststo: ivreg2 attacksin7 (drones=gusts) dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 attacks1 attacks2 attacks3 attacks4 attacks5 attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14 tmean2_mir lnprec, r bw(15) first endogtest(drones)
* Wind speed
eststo: ivreg2 attacksin7 (drones=wind) dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 attacks1 attacks2 attacks3 attacks4 attacks5 attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14 tmean2_mir lnprec, r bw(15) first endogtest(drones)
* 3-day averages
preserve 
keep if ign3==0
g datenew=date/3
tsset datenew
eststo: ivreg2 attacksavg3lead (dronesavg3=gustsavg3) dows* ramadan date months* mil_actavg3 mil_actavg3lag mil_actavg3lag2 mil_actavg3lag3 mil_actavg3lag4 attacksavg3 attacksavg3lag attacksavg3lag2 attacksavg3lag3 attacksavg3lag4 tmean2_miravg3 lnprecavg3 if ign3==0, r bw(5) first endogtest(dronesavg3)
restore
* 6-day averages
preserve 
keep if ign6==0
g datenew=date/6
tsset datenew
eststo: ivreg2 attacksavg6lead (dronesavg6=gustsavg6) dows* ramadan date months* mil_actavg6 mil_actavg6lag attacksavg6 attacksavg6lag tmean2_miravg6 lnprecavg6 if ign6==0, r bw(3) first endogtest(dronesavg6)
restore
* 14-day averages
preserve 
keep if ign14==0
g datenew=date/14
tsset datenew
eststo: ivreg2 attacksavg14lead (dronesavg14=gustsavg14) ramadan date months* mil_actavg14 attacksavg14 tmean2_miravg14 lnprecavg14 if ign14==0, r bw(2) first endogtest(dronesavg14)
restore
esttab using "2.tex", se replace se(4) b(4) drop(_cons months* dows* attacks* mil_act* tmean2_mir lnprec ramadan date) star(* 0.10 ** 0.05 *** 0.01) sca(fstat olea oleacric oleacric2) 


*** OLS
eststo drop *
* Baseline 
eststo: qui newey attacksin7 drones dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 attacks1 attacks2 attacks3 attacks4 attacks5 attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14 tmean2_mir lnprec, lag(1) 
* Wind speed
eststo: qui newey attacksin7 drones dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 attacks1 attacks2 attacks3 attacks4 attacks5 attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14 tmean2_mir lnprec, lag(1) 
preserve
keep if ign3==0
g datenew=date/3
tsset datenew
* 3-day averages
eststo: qui newey attacksavg3lead dronesavg3 dows* ramadan date months* mil_actavg3 mil_actavg3lag mil_actavg3lag2 mil_actavg3lag3 mil_actavg3lag4 attacksavg3 attacksavg3lag attacksavg3lag2 attacksavg3lag3 attacksavg3lag4 tmean2_miravg3 lnprecavg3 if ign3==0, lag(1)
restore
* 6-day averages
preserve
keep if ign6==0
g datenew=date/6
tsset datenew
eststo: qui newey attacksavg6lead dronesavg6 dows* ramadan date months* mil_actavg6 mil_actavg6lag attacksavg6 attacksavg6lag tmean2_miravg6 lnprecavg6 if ign6==0, lag(1) 
restore
preserve
keep if ign14==0
g datenew=date/14
tsset datenew
* 14-day averages
eststo: qui newey attacksavg14lead dronesavg14 ramadan date months* mil_actavg14 attacksavg14 tmean2_miravg14 lnprecavg14 if ign14==0, lag(1)
restore
esttab using "3.tex", se replace se(4) b(4) drop(_cons months* dows* attacks* mil_act* tmean2_mir lnprec ramadan date) star(* 0.10 ** 0.05 *** 0.01) 

*** OLS (lag 15 option)
eststo drop *
* Baseline 
eststo: qui newey attacksin7 drones dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 attacks1 attacks2 attacks3 attacks4 attacks5 attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14 tmean2_mir lnprec, lag(15) 
* Wind speed
eststo: qui newey attacksin7 drones dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 attacks1 attacks2 attacks3 attacks4 attacks5 attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14 tmean2_mir lnprec, lag(15) 
preserve
keep if ign3==0
g datenew=date/3
tsset datenew
* 3-day averages
eststo: qui newey attacksavg3lead dronesavg3 dows* ramadan date months* mil_actavg3 mil_actavg3lag mil_actavg3lag2 mil_actavg3lag3 mil_actavg3lag4 attacksavg3 attacksavg3lag attacksavg3lag2 attacksavg3lag3 attacksavg3lag4 tmean2_miravg3 lnprecavg3 if ign3==0, lag(5)
restore
* 6-day averages
preserve
keep if ign6==0
g datenew=date/6
tsset datenew
eststo: qui newey attacksavg6lead dronesavg6 dows* ramadan date months* mil_actavg6 mil_actavg6lag attacksavg6 attacksavg6lag tmean2_miravg6 lnprecavg6 if ign6==0, lag(3) 
restore
preserve
keep if ign14==0
g datenew=date/14
tsset datenew
* 14-day averages
eststo: qui newey attacksavg14lead dronesavg14 ramadan date months* mil_actavg14 attacksavg14 tmean2_miravg14 lnprecavg14 if ign14==0, lag(2)
restore
esttab using "4.tex", se replace se(4) b(4) drop(_cons months* dows* attacks* mil_act* tmean2_mir lnprec ramadan date) star(* 0.10 ** 0.05 *** 0.01) 

************************************************************************************************************************************
*** F3: Timeframe of dep var
************************************************************************************************************************************
*** Attacks
eststo drop *
foreach x of numlist 1/14 21 28 {
	qui ivreg2 attacksin`x' (drones=gusts) dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 attacks1 attacks2 attacks3 attacks4 attacks5 attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14 tmean2_mir lnprec, r bw(1) 
	est store e`x'
}
qui ivreg2 attacks15to21 (drones=gusts) dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 attacks1 attacks2 attacks3 attacks4 attacks5 attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14 tmean2_mir lnprec, r bw(1) 
est store e17
qui ivreg2 attacks15to28 (drones=gusts) dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 attacks1 attacks2 attacks3 attacks4 attacks5 attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14 tmean2_mir lnprec, r bw(1) 
est store e18
qui ivreg2 attacks15to70 (drones=gusts) dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 attacks1 attacks2 attacks3 attacks4 attacks5 attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14 tmean2_mir lnprec, r bw(1) 
est store e19
coefplot (e1, rename(drones = 1) offset(0)) (e2, rename(drones=1-2) offset(0)) (e3, rename(drones= 1-3) offset(0)) (e4, rename(drones= 1-4) offset(0)) (e5, rename(drones= 1-5) offset(0)) (e6, rename(drones= 1-6) offset(0)) (e7, rename(drones= 1-7) offset(0)) (e8, rename(drones= 1-8) offset(0)) (e9, rename(drones= 1-9) offset(0)) (e10, rename(drones= 1-10) offset(0)) (e11, rename(drones= 1-11) offset(0)) (e12, rename(drones= 1-12) offset(0)) (e13, rename(drones= 1-13) offset(0)) (e14, rename(drones= 1-14) offset(0)) (e21, rename(drones= 1-21) offset(0)) (e28, rename(drones= 1-28) offset(0)) (e17, rename(drones= 15-21) offset(0)) (e18, rename(drones= 15-28) offset(0)) (e19, rename(drones= 15-70) offset(0)), keep(drones) vertical nolabels msize(large) msymbol(diamond_hollow) mcolor(navy) mlwidth(thick) graphregion(color(white)) bgcolor(white) ciopts(recast(rcap rcap) lwidth(thick) lcolor(gs2) fcolor(gs10)) yline(0, lcolor(red)) nokey yline(0) ytitle("Coefficient of drone strikes") xtitle("Days after drone strikes") yscale(range(-5 10)) ylabel(-5(5)10) xlabel(,angle(vertical))
gr export "July1.eps", replace
!epstopdf "July1.eps"


*** Deaths
eststo drop *
foreach x of numlist 1/14 21 28 {
	qui ivreg2 deathsin`x' (drones=gusts) dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 deaths1 deaths2 deaths3 deaths4 deaths5 deaths6 deaths7 deaths8 deaths9 deaths10 deaths11 deaths12 deaths13 deaths14 tmean2_mir lnprec, r bw(1) 
	est store e`x'
}
qui ivreg2 deaths15to21 (drones=gusts) dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 deaths1 deaths2 deaths3 deaths4 deaths5 deaths6 deaths7 deaths8 deaths9 deaths10 deaths11 deaths12 deaths13 deaths14 tmean2_mir lnprec, r bw(1) 
est store e17
qui ivreg2 deaths15to28 (drones=gusts) dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 deaths1 deaths2 deaths3 deaths4 deaths5 deaths6 deaths7 deaths8 deaths9 deaths10 deaths11 deaths12 deaths13 deaths14 tmean2_mir lnprec, r bw(1) 
est store e18
qui ivreg2 deaths15to70 (drones=gusts) dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 deaths1 deaths2 deaths3 deaths4 deaths5 deaths6 deaths7 deaths8 deaths9 deaths10 deaths11 deaths12 deaths13 deaths14 tmean2_mir lnprec, r bw(1) 
est store e19
coefplot (e1, rename(drones = 1) offset(0)) (e2, rename(drones=1-2) offset(0)) (e3, rename(drones= 1-3) offset(0)) (e4, rename(drones= 1-4) offset(0)) (e5, rename(drones= 1-5) offset(0)) (e6, rename(drones= 1-6) offset(0)) (e7, rename(drones= 1-7) offset(0)) (e8, rename(drones= 1-8) offset(0)) (e9, rename(drones= 1-9) offset(0)) (e10, rename(drones= 1-10) offset(0)) (e11, rename(drones= 1-11) offset(0)) (e12, rename(drones= 1-12) offset(0)) (e13, rename(drones= 1-13) offset(0)) (e14, rename(drones= 1-14) offset(0)) (e21, rename(drones= 1-21) offset(0)) (e28, rename(drones= 1-28) offset(0)) (e17, rename(drones= 15-21) offset(0)) (e18, rename(drones= 15-28) offset(0)) (e19, rename(drones= 15-70) offset(0)), keep(drones) vertical nolabels msize(large) msymbol(diamond_hollow) mcolor(navy) mlwidth(thick) graphregion(color(white)) bgcolor(white) ciopts(recast(rcap rcap) lwidth(thick) lcolor(gs2) fcolor(gs10)) yline(0, lcolor(red)) nokey yline(0) ytitle("Coefficient of drone strikes") xtitle("Days after drone strikes") yscale(range(-5 25)) ylabel(-5(5)25) xlabel(,angle(vertical))
gr export "July2.eps", replace
!epstopdf "July2.eps"

************************************************************************************************************************************
*** F4: Drone articles (TNI)
************************************************************************************************************************************
* # of drone articles
eststo drop *
foreach x of varlist numdrone numus numterror {
	qui ivreg2 `x'in7 (drones=gusts) attacks attacksin7 dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 `x'1 `x'2 `x'3 `x'4 `x'5 `x'6 `x'7 `x'8 `x'9 `x'10 `x'11 `x'12 `x'13 `x'14 tmean2_mir lnprec, r bw(1) 
	est store e`x'
}
coefplot (enumdrone, rename(drones =`" "# of drone" "articles" "') offset(0)) (enumus, rename(drones=`" "# of US" "articles" "') offset(0)) (enumterror, rename(drones=`" "# of terror" "group articles" "') offset(0)), keep(drones) vertical nolabels msize(large) msymbol(diamond_hollow) mcolor(navy) mlwidth(thick) graphregion(color(white)) bgcolor(white) ciopts(recast(rcap rcap) lwidth(thick) lcolor(gs2) fcolor(gs10)) yline(0, lcolor(red)) nokey yline(0) ytitle("Coefficient of drone strikes") xtitle("") yscale(range(-1 10)) ylabel(-1(1)10) 
gr export "articles2.eps", replace
!epstopdf "articles2.eps"

* Drone articles sentiment
eststo drop *
foreach x of varlist avgdronenegemo avgdroneanger avgdroneposemo {
	qui ivreg2 `x'in7 (drones=gusts) attacks attacksin7 dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 `x'1 `x'2 `x'3 `x'4 `x'5 `x'6 `x'7 `x'8 `x'9 `x'10 `x'11 `x'12 `x'13 `x'14 tmean2_mir lnprec, r bw(1) 
	est store e`x'
}
coefplot (eavgdronenegemo, rename(drones =`" "Negative" "emotions" "') offset(0)) (eavgdroneanger, rename(drones="Anger") offset(0)) (eavgdroneposemo, rename(drones=`" "Positive" "emotions" "') offset(0)), keep(drones) vertical nolabels msize(large) msymbol(diamond_hollow) mcolor(navy) mlwidth(thick) graphregion(color(white)) bgcolor(white) ciopts(recast(rcap rcap) lwidth(thick) lcolor(gs2) fcolor(gs10)) yline(0, lcolor(red)) nokey yline(0) ytitle("Coefficient of drone strikes") xtitle("") yscale(range(-0.5 2)) ylabel(-0.5(0.5)2)
gr export "articles4.eps", replace
!epstopdf "articles4.eps"


************************************************************************************************************************************
*** F5: US and terror-group articles (TNI)
************************************************************************************************************************************
*** 7 days
eststo drop *
foreach x of varlist avgusnegemo avgusanger avgusposemo avgusnoterrornegemo avgusnoterroranger avgusnoterrorposemo avgusnodronenegemo avgusnodroneanger avgusnodroneposemo {
	qui ivreg2 `x'in7 (drones=gusts) attacks attacksin7 dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 `x'1 `x'2 `x'3 `x'4 `x'5 `x'6 `x'7 `x'8 `x'9 `x'10 `x'11 `x'12 `x'13 `x'14 tmean2_mir lnprec, r bw(1) 
	est store e`x'
}
coefplot (eavgusnegemo, rename(drones =`" "Negative" "emotions" "') offset(0)) (eavgusanger, rename(drones="Anger") offset(0)) (eavgusposemo, rename(drones=`" "Positive" "emotions" "') offset(0)) (eavgusnoterrornegemo, rename(drones=`" "Negative" "emotions" "(no terror)" "') offset(0)) (eavgusnoterroranger, rename(drones=`" "Anger" " " "(no terror)" "') offset(0)) (eavgusnoterrorposemo, rename(drones=`" "Positive" "emotions" "(no terror)" "') offset(0)) (eavgusnodronenegemo , rename(drones=`" "Negative" "emotions" "(no drone)" "') offset(0)) (eavgusnodroneanger, rename(drones=`" "Anger" " " "(no drone)" "') offset(0)) (eavgusnodroneposemo, rename(drones=`" "Positive" "emotions" "(no drone)" "') offset(0)), keep(drones) vertical nolabels msize(large) msymbol(diamond_hollow) mcolor(navy) mlwidth(thick) graphregion(color(white)) bgcolor(white) ciopts(recast(rcap rcap) lwidth(thick) lcolor(gs2) fcolor(gs10)) yline(0, lcolor(red)) nokey yline(0) ytitle("Coefficient of drone strikes") xtitle("") yscale(range(-1.5 2.5)) ylabel(-1.5(0.5)2.5) xlabel(, labsize(small))
gr export "articles6.eps", replace
!epstopdf "articles6.eps"

eststo drop *
foreach x of varlist avgterrornegemo avgterroranger avgterrorposemo avgterrornousnegemo avgterrornousanger avgterrornousposemo avgterrornodronenegemo avgterrornodroneanger avgterrornodroneposemo {
	qui ivreg2 `x'in7 (drones=gusts) attacks attacksin7 dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 `x'1 `x'2 `x'3 `x'4 `x'5 `x'6 `x'7 `x'8 `x'9 `x'10 `x'11 `x'12 `x'13 `x'14 tmean2_mir lnprec, r bw(1) 
	est store e`x'
}
coefplot (eavgterrornegemo, rename(drones =`" "Negative" "emotions" "') offset(0)) (eavgterroranger, rename(drones="Anger") offset(0)) (eavgterrorposemo, rename(drones=`" "Positive" "emotions" "') offset(0)) (eavgterrornousnegemo, rename(drones=`" "Negative" "emotions" "(no US)" "') offset(0)) (eavgterrornousanger, rename(drones=`" "Anger" " " "(no US)" "') offset(0)) (eavgterrornousposemo, rename(drones=`" "Positive" "emotions" "(no US)" "') offset(0)) (eavgterrornodronenegemo , rename(drones=`" "Negative" "emotions" "(no drone)" "') offset(0)) (eavgterrornodroneanger, rename(drones=`" "Anger" " " "(no drone)" "') offset(0)) (eavgterrornodroneposemo, rename(drones=`" "Positive" "emotions" "(no drone)" "') offset(0)), keep(drones) vertical nolabels msize(large) msymbol(diamond_hollow) mcolor(navy) mlwidth(thick) graphregion(color(white)) bgcolor(white) ciopts(recast(rcap rcap) lwidth(thick) lcolor(gs2) fcolor(gs10)) yline(0, lcolor(red)) nokey yline(0) ytitle("Coefficient of drone strikes") xtitle("") yscale(range(-3 1)) ylabel(-3(0.5)1) xlabel(, labsize(small))
gr export "articles8.eps", replace
!epstopdf "articles8.eps"


************************************************************************************************************************************
*** F6: Anti-US and anti-terror groups protests etc.
************************************************************************************************************************************
eststo drop *
foreach x of varlist prot_us prot_usdum prot_ter prot_terdum {
	qui ivreg2 `x'in7 (drones=gusts) attacks attacksin7 dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 `x'1 `x'2 `x'3 `x'4 `x'5 `x'6 `x'7 `x'8 `x'9 `x'10 `x'11 `x'12 `x'13 `x'14 tmean2_mir lnprec, r bw(1) 
	est store e`x'
}
coefplot (eprot_us, rename(drones =`" "Anti-US" "protests" "') offset(0)) (eprot_usdum, rename(drones =`" "Anti-US" "protests" "(binary)" "') offset(0)) (eprot_ter, rename(drones =`" "Anti-terror" "protests" "') offset(0)) (eprot_terdum, rename(drones =`" "Anti-terror" "protests" "(binary)" "') offset(0)), keep(drones) vertical nolabels msize(large) msymbol(diamond_hollow) mcolor(navy) mlwidth(thick) graphregion(color(white)) bgcolor(white) ciopts(recast(rcap rcap) lwidth(thick) lcolor(gs2) fcolor(gs10)) yline(0, lcolor(red)) nokey yline(0) ytitle("Coefficient of drone strikes") xtitle("") yscale(range(-2 5)) ylabel(-2(1)5) 
gr export "protest1.eps", replace
!epstopdf "protest1.eps"

eststo drop *
foreach x of varlist prot_us prot_usdum prot_ter prot_terdum {
	qui ivreg2 `x'in14 (drones=gusts) attacks attacksin14 dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 `x'1 `x'2 `x'3 `x'4 `x'5 `x'6 `x'7 `x'8 `x'9 `x'10 `x'11 `x'12 `x'13 `x'14 tmean2_mir lnprec, r bw(1) 
	est store e`x'
}
coefplot (eprot_us, rename(drones =`" "Anti-US" "protests" "') offset(0)) (eprot_usdum, rename(drones =`" "Anti-US" "protests" "(binary)" "') offset(0)) (eprot_ter, rename(drones =`" "Anti-terror" "protests" "') offset(0)) (eprot_terdum, rename(drones =`" "Anti-terror" "protests" "(binary)" "') offset(0)), keep(drones) vertical nolabels msize(large) msymbol(diamond_hollow) mcolor(navy) mlwidth(thick) graphregion(color(white)) bgcolor(white) ciopts(recast(rcap rcap) lwidth(thick) lcolor(gs2) fcolor(gs10)) yline(0, lcolor(red)) nokey yline(0) ytitle("Coefficient of drone strikes") xtitle("") yscale(range(-2 5)) ylabel(-2(1)5) 
gr export "protest3.eps", replace
!epstopdf "protest3.eps"


************************************************************************************************************************************
*** F7: Google Trends 
************************************************************************************************************************************
*** 7 days
eststo drop *
foreach x of varlist jihad tvideo zarb ghazwa usaid usimmi usefp {
	qui ivreg2 `x'in7 (drones=gusts) attacks attacksin7 dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 `x'1 `x'2 `x'3 `x'4 `x'5 `x'6 `x'7 `x'8 `x'9 `x'10 `x'11 `x'12 `x'13 `x'14 tmean2_mir lnprec, r bw(1) 
	est store e`x'
}
coefplot (ejihad, rename(drones ="Jihad") offset(0)) (etvideo, rename(drones=`" "Taliban" "video" "') offset(0)) (ezarb, rename(drones=`" "Zarb-e-" "Momin" "') offset(0)) (eghazwa, rename(drones=`" "Ghazwa e" "Hind" "') offset(0))  (eusaid, rename(drones=`" "USAID" "') offset(0)) (eusimmi, rename(drones=`" "US" "immigration" "') offset(0)) (eusefp, rename(drones="USEFP") offset(0)), keep(drones) vertical nolabels msize(large) msymbol(diamond_hollow) mcolor(navy) mlwidth(thick) graphregion(color(white)) bgcolor(white) ciopts(recast(rcap rcap) lwidth(thick) lcolor(gs2) fcolor(gs10)) yline(0, lcolor(red)) nokey yline(0) ytitle("Coefficient of drone strikes") xtitle("") yscale(range(-1 2)) ylabel(-1(0.5)2) xlabel(, labsize(small))
gr export "gt2.eps", replace
!epstopdf "gt2.eps"


*** 14 days
eststo drop *
foreach x of varlist jihad tvideo zarb ghazwa usaid usimmi usefp {
	qui ivreg2 `x'in14 (drones=gusts) attacks attacksin14 dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 `x'1 `x'2 `x'3 `x'4 `x'5 `x'6 `x'7 `x'8 `x'9 `x'10 `x'11 `x'12 `x'13 `x'14 tmean2_mir lnprec, r bw(1) 
	est store e`x'
}
coefplot (ejihad, rename(drones ="Jihad") offset(0)) (etvideo, rename(drones=`" "Taliban" "video" "') offset(0)) (ezarb, rename(drones=`" "Zarb-e-" "Momin" "') offset(0)) (eghazwa, rename(drones=`" "Ghazwa e" "Hind" "') offset(0))  (eusaid, rename(drones=`" "USAID" "') offset(0)) (eusimmi, rename(drones=`" "US" "immigration" "') offset(0)) (eusefp, rename(drones="USEFP") offset(0)), keep(drones) vertical nolabels msize(large) msymbol(diamond_hollow) mcolor(navy) mlwidth(thick) graphregion(color(white)) bgcolor(white) ciopts(recast(rcap rcap) lwidth(thick) lcolor(gs2) fcolor(gs10)) yline(0, lcolor(red)) nokey yline(0) ytitle("Coefficient of drone strikes") xtitle("") yscale(range(-1 2)) ylabel(-1(0.5)2) xlabel(, labsize(small))
gr export "gt4.eps", replace
!epstopdf "gt4.eps"


************************************************************************************************************************************
************************************************************************************************************************************
*** Appendix 
************************************************************************************************************************************
************************************************************************************************************************************


************************************************************************************************************************************
*T.C1* Panel for reduced form
************************************************************************************************************************************
preserve
import delimited "data panel", clear
label variable prec "Total precipitation"
label variable attacks "terror attacks in Pakistan -GTD"
label variable gusts "max wind gust (km/h) 10 m above ground"
label variable tmean2 "mean temperature (C) 2m above ground"



**Preps
gen dow=dow(date)
tab dow, gen(dows)
gen month=month(date)
tab month, gen(months)
format date %td
g lnprec=ln(1+prec)
rename country land
encode land, g(country)
xtset country date
sort country date 
by country: g attacksin7=(attacks[_n+1]+attacks[_n+2]+attacks[_n+3]+attacks[_n+4]+attacks[_n+5]+attacks[_n+6]+attacks[_n+7])/7
foreach x of numlist 1/14 {
	by country: g attacks`x'=attacks[_n-`x']
}
g after=(date>16238)
g treat=(land=="Pakistan")
g aftertreat=after*treat
g aftertreatgusts=aftertreat*gusts
g aftergusts=after*gusts
g treatgusts=treat*gusts

*** 3-day averages
sort country date
foreach x of varlist attacks gusts tmean2 lnprec {
	by country: g `x'avg=(`x'[_n-2]+`x'[_n-1]+`x')/3
}
g newdate=date/3
g ign=(mod(newdate,1)>0)

sort country newdate
foreach x of varlist attacks gusts tmean2 lnprec {
	by country: g `x'avglag=`x'avg[_n-3]
	by country: g `x'avglag2=`x'avg[_n-6]
	by country: g `x'avglag3=`x'avg[_n-9]
	by country: g `x'avglead=`x'avg[_n+3]
}
g aftertreatgustsavg=aftertreat*gustsavg
g aftergustsavg=after*gustsavg
g treatgustsavg=treat*gustsavg

*** 6-day averages
sort country date
foreach x of varlist attacks gusts tmean2 lnprec {
	by country: g `x'avgnew=(`x'[_n-5]+`x'[_n-4]+`x'[_n-3]+`x'[_n-2]+`x'[_n-1]+`x')/6
}
g newdatenew=date/6
g ignnew=(mod(newdatenew,1)>0)

sort country newdatenew
foreach x of varlist attacks gusts tmean2 lnprec {
	by country: g `x'avglagnew=`x'avgnew[_n-6]
	by country: g `x'avglagnew2=`x'avgnew[_n-12]
	by country: g `x'avglagnew3=`x'avgnew[_n-18]
	by country: g `x'avgleadnew=`x'avgnew[_n+6]
}
g aftertreatgustsavgnew=aftertreat*gustsavgnew
g aftergustsavgnew=after*gustsavgnew
g treatgustsavgnew=treat*gustsavgnew


*** 14-day averages
sort country date
foreach x of varlist attacks gusts tmean2 lnprec {
	by country: g `x'avg14=(`x'[_n-13]+`x'[_n-12]+`x'[_n-11]+`x'[_n-10]+`x'[_n-9]+`x'[_n-8]+`x'[_n-7]+`x'[_n-6]+`x'[_n-5]+`x'[_n-4]+`x'[_n-3]+`x'[_n-2]+`x'[_n-1]+`x')/14
}
g newdate14=date/14
g ign14=(mod(newdate14,1)>0)

sort country newdate14
foreach x of varlist attacks gusts tmean2 lnprec {
	by country: g `x'avglag14=`x'avg14[_n-14]
	by country: g `x'avglag142=`x'avg14[_n-28]
	by country: g `x'avglag143=`x'avg14[_n-42]
	by country: g `x'avglead14=`x'avg14[_n+14]
}
g aftertreatgustsavg14=aftertreat*gustsavg14
g aftergustsavg14=after*gustsavg14
g treatgustsavg14=treat*gustsavg14

//C1: Reduced form, Panel
eststo drop *
* Pakistan only
eststo: qui reg attacksin7 after gusts aftergusts date dows* months* tmean2 lnprec attacks1 attacks2 attacks3 attacks4 attacks5 attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14 if land=="Pakistan", r
* Pooled panel
eststo: qui reg attacksin7 after treat aftertreat aftertreatgusts gusts aftergusts treatgusts date dows* months* tmean2 lnprec attacks1 attacks2 attacks3 attacks4 attacks5 attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14 , vce(cluster country)
* FE panel
eststo: qui xtreg attacksin7 after treat aftertreat aftertreatgusts gusts aftergusts treatgusts date dows* months* tmean2 lnprec attacks1 attacks2 attacks3 attacks4 attacks5 attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14 , fe vce(cluster country)
* 3-day averages
eststo: qui xtreg attacksavglead after treat aftertreat aftertreatgustsavg gustsavg aftergustsavg treatgustsavg date dows* months* tmean2avg lnprecavg attacksavg if ign==0, fe vce(cluster country)
* 6-day averages
eststo: qui xtreg attacksavgleadnew after treat aftertreat aftertreatgustsavgnew gustsavgnew aftergustsavgnew treatgustsavgnew date dows* months* tmean2avgnew lnprecavgnew attacksavgnew attacksavglagnew if ignnew==0, fe vce(cluster country)
* 14-day averages
eststo: qui xtreg attacksavglead14 after treat aftertreat aftertreatgustsavg14 gustsavg14 aftergustsavg14 treatgustsavg14 date dows* months* tmean2avg14 lnprecavg14 attacksavg14 if ign14==0, fe vce(cluster country)
esttab using "5.tex", se replace se(4) b(4) drop(_cons months* dows* tmean* lnprec* attacks*) star(* 0.10 ** 0.05 *** 0.01) 

************************************************************************************************************************************
*T.C2* Panel for reduced form with squared time trend
************************************************************************************************************************************
g date2=date*date

eststo drop *
* Pakistan only
eststo: qui reg attacksin7 after gusts aftergusts date date2 dows* months* tmean2 lnprec attacks1 attacks2 attacks3 attacks4 attacks5 attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14 if land=="Pakistan", r
* Pooled panel
eststo: qui reg attacksin7 after treat aftertreat aftertreatgusts gusts aftergusts treatgusts date date2 dows* months* tmean2 lnprec attacks1 attacks2 attacks3 attacks4 attacks5 attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14 , vce(cluster country)
* FE panel
eststo: qui xtreg attacksin7 after treat aftertreat aftertreatgusts gusts aftergusts treatgusts date date2 dows* months* tmean2 lnprec attacks1 attacks2 attacks3 attacks4 attacks5 attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14 , fe vce(cluster country)
* 3-day averages
eststo: qui xtreg attacksavglead after treat aftertreat aftertreatgustsavg gustsavg aftergustsavg treatgustsavg date date2 dows* months* tmean2avg lnprecavg attacksavg if ign==0, fe vce(cluster country)
* 6-day averages
eststo: qui xtreg attacksavgleadnew after treat aftertreat aftertreatgustsavgnew gustsavgnew aftergustsavgnew treatgustsavgnew date date2 dows* months* tmean2avgnew lnprecavgnew attacksavgnew attacksavglagnew if ignnew==0, fe vce(cluster country)
* 14-day averages
eststo: qui xtreg attacksavglead14 after treat aftertreat aftertreatgustsavg14 gustsavg14 aftergustsavg14 treatgustsavg14 date date2 dows* months* tmean2avg14 lnprecavg14 attacksavg14 if ign14==0, fe vce(cluster country)
esttab using "6.tex", se replace se(4) b(4) drop(_cons months* dows* tmean* lnprec* attacks*) star(* 0.10 ** 0.05 *** 0.01) 
restore






*********************************************************************************************************************************************************
**** FE1: Time series of drone strikes and attacks
*********************************************************************************************************************************************************
twoway (lpoly drones date) (lpoly attacks date, yaxis(2) lpattern(longdash)), xscale(range(16802 20819))  xlabel(16802 "2006" 17898 "2009" 18993 "2012" 20089 "2015", format(%td)) xtitle("")  ytitle(Drone strikes) ytitle(Terror attacks, axis(2))  title("") graphregion(color(white)) legend(label(1 "Drone strikes") label(2 "Terror attacks"))
gr export "R3a.eps", replace
!epstopdf "R3a.eps"


*********************************************************************************************************************************************************
**** FE2: Placebo binscatters for Iraq and Israel 
*********************************************************************************************************************************************************
binscatter attacksiraqin7 gustsiraq, controls(dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 attacksiraq1 attacksiraq2 attacksiraq3 attacksiraq4 attacksiraq5 attacksiraq attacksiraq attacksiraq attacksiraq attacksiraq10 attacksiraq11 attacksiraq12 attacksiraq13 attacksiraq4 tmean2iraq lnpreciraq) msymbol(diamond_hollow) lcolor(gs2) xtitle("Wind gusts on day t") yscale(range(4.5 7)) ylabel(4.5(0.5)7) ytitle("Terror attacks per day on days t+1 to t+7") reportreg
gr export "iraq.eps", replace
!epstopdf "iraq.eps"

binscatter attacksisraelin7 gustsisrael, controls(dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 attacksisrael1 attacksisrael2 attacksisrael3 attacksisrael4 attacksisrael5 attacksisrael attacksisrael attacksisrael attacksisrael attacksisrael10 attacksisrael11 attacksisrael12 attacksisrael13 attacksisrael4 tmean2israel lnprecisrael) msymbol(diamond_hollow) lcolor(gs2) xtitle("Wind gusts on day t") yscale(range(0 0.4)) ylabel(0(0.1)0.4) ytitle("Terror attacks per day on days t+1 to t+7") reportreg
gr export "israel.eps", replace
!epstopdf "israel.eps"


************************************************************************************************************************************
*** FE3: OLS sentiment analysis 
************************************************************************************************************************************
* # of articles
eststo drop *
foreach x of varlist numdrone numus numterror {
	qui newey `x'in7 drones attacks attacksin7 dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 `x'1 `x'2 `x'3 `x'4 `x'5 `x'6 `x'7 `x'8 `x'9 `x'10 `x'11 `x'12 `x'13 `x'14 tmean2_mir lnprec, lag(1) 
	est store e`x'
}
coefplot (enumdrone, rename(drones =`" "# of drone" "articles" "') offset(0)) (enumus, rename(drones=`" "# of US" "articles" "') offset(0)) (enumterror, rename(drones=`" "# of terror" "group articles" "') offset(0)), keep(drones) vertical nolabels msize(large) msymbol(diamond_hollow) mcolor(navy) mlwidth(thick) graphregion(color(white)) bgcolor(white) ciopts(recast(rcap rcap) lwidth(thick) lcolor(gs2) fcolor(gs10)) yline(0, lcolor(red)) nokey yline(0) ytitle("Coefficient of drone strikes") xtitle("") yscale(range(-0.2 0.4)) ylabel(-0.2(0.2)0.4)
gr export "articles1.eps", replace
!epstopdf "articles1.eps"

* Drone articles sentiment
eststo drop *
foreach x of varlist avgdronenegemo avgdroneanger avgdroneposemo {
	qui newey `x'in7 drones attacks attacksin7 dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 `x'1 `x'2 `x'3 `x'4 `x'5 `x'6 `x'7 `x'8 `x'9 `x'10 `x'11 `x'12 `x'13 `x'14 tmean2_mir lnprec, lag(1) 
	est store e`x'
}
coefplot (eavgdronenegemo, rename(drones =`" "Negative" "emotions" "') offset(0)) (eavgdroneanger, rename(drones="Anger") offset(0)) (eavgdroneposemo, rename(drones=`" "Positive" "emotions" "') offset(0)), keep(drones) vertical nolabels msize(large) msymbol(diamond_hollow) mcolor(navy) mlwidth(thick) graphregion(color(white)) bgcolor(white) ciopts(recast(rcap rcap) lwidth(thick) lcolor(gs2) fcolor(gs10)) yline(0, lcolor(red)) nokey yline(0) ytitle("Coefficient of drone strikes") xtitle("") yscale(range(-0.5 0.5)) ylabel(-0.5(0.1)0.5)
gr export "articles3.eps", replace
!epstopdf "articles3.eps"

**********************************************************************
*FE4: OLS: US-related and terror group-related articles
*************************************************************************
* US articles sentiment
eststo drop *
foreach x of varlist avgusnegemo avgusanger avgusposemo avgusnoterrornegemo avgusnoterroranger avgusnoterrorposemo avgusnodronenegemo avgusnodroneanger avgusnodroneposemo {
	qui newey `x'in7 drones attacks attacksin7 dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 `x'1 `x'2 `x'3 `x'4 `x'5 `x'6 `x'7 `x'8 `x'9 `x'10 `x'11 `x'12 `x'13 `x'14 tmean2_mir lnprec, lag(1) 
	est store e`x'
}
coefplot (eavgusnegemo, rename(drones =`" "Negative" "emotions" "') offset(0)) (eavgusanger, rename(drones="Anger") offset(0)) (eavgusposemo, rename(drones=`" "Positive" "emotions" "') offset(0)) (eavgusnoterrornegemo, rename(drones=`" "Negative" "emotions" "(no terror)" "') offset(0)) (eavgusnoterroranger, rename(drones=`" "Anger" " " "(no terror)" "') offset(0)) (eavgusnoterrorposemo, rename(drones=`" "Positive" "emotions" "(no terror)" "') offset(0)) (eavgusnodronenegemo , rename(drones=`" "Negative" "emotions" "(no drone)" "') offset(0)) (eavgusnodroneanger, rename(drones=`" "Anger" " " "(no drone)" "') offset(0)) (eavgusnodroneposemo, rename(drones=`" "Positive" "emotions" "(no drone)" "') offset(0)), keep(drones) vertical nolabels msize(large) msymbol(diamond_hollow) mcolor(navy) mlwidth(thick) graphregion(color(white)) bgcolor(white) ciopts(recast(rcap rcap) lwidth(thick) lcolor(gs2) fcolor(gs10)) yline(0, lcolor(red)) nokey yline(0) ytitle("Coefficient of drone strikes") xtitle("") yscale(range(-0.15 0.15)) ylabel(-0.15(0.05)0.15) xlabel(, labsize(small))
gr export "articles5.eps", replace
!epstopdf "articles5.eps"

* Terror group articles sentiment
eststo drop *
foreach x of varlist avgterrornegemo avgterroranger avgterrorposemo avgterrornousnegemo avgterrornousanger avgterrornousposemo avgterrornodronenegemo avgterrornodroneanger avgterrornodroneposemo {
	qui newey `x'in7 drones attacks attacksin7 dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 `x'1 `x'2 `x'3 `x'4 `x'5 `x'6 `x'7 `x'8 `x'9 `x'10 `x'11 `x'12 `x'13 `x'14 tmean2_mir lnprec, lag(1) 
	est store e`x'
}
coefplot (eavgterrornegemo, rename(drones =`" "Negative" "emotions" "') offset(0)) (eavgterroranger, rename(drones="Anger") offset(0)) (eavgterrorposemo, rename(drones=`" "Positive" "emotions" "') offset(0)) (eavgterrornousnegemo, rename(drones=`" "Negative" "emotions" "(no US)" "') offset(0)) (eavgterrornousanger, rename(drones=`" "Anger" " " "(no US)" "') offset(0)) (eavgterrornousposemo, rename(drones=`" "Positive" "emotions" "(no US)" "') offset(0)) (eavgterrornodronenegemo , rename(drones=`" "Negative" "emotions" "(no drone)" "') offset(0)) (eavgterrornodroneanger, rename(drones=`" "Anger" " " "(no drone)" "') offset(0)) (eavgterrornodroneposemo, rename(drones=`" "Positive" "emotions" "(no drone)" "') offset(0)), keep(drones) vertical nolabels msize(large) msymbol(diamond_hollow) mcolor(navy) mlwidth(thick) graphregion(color(white)) bgcolor(white) ciopts(recast(rcap rcap) lwidth(thick) lcolor(gs2) fcolor(gs10)) yline(0, lcolor(red)) nokey yline(0) ytitle("Coefficient of drone strikes") xtitle("") yscale(range(-0.1 0.1)) ylabel(-0.1(0.05)0.1) xlabel(, labsize(small))
gr export "articles7.eps", replace
!epstopdf "articles7.eps"


************************************************************************************************************************************
*** FE5: IV: Emotions robustness check for 14 days
************************************************************************************************************************************
* US articles
eststo drop *
foreach x of varlist avgusnegemo avgusanger avgusposemo avgusnoterrornegemo avgusnoterroranger avgusnoterrorposemo avgusnodronenegemo avgusnodroneanger avgusnodroneposemo {
	qui ivreg2 `x'in14 (drones=gusts) attacks attacksin7 dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 `x'1 `x'2 `x'3 `x'4 `x'5 `x'6 `x'7 `x'8 `x'9 `x'10 `x'11 `x'12 `x'13 `x'14 tmean2_mir lnprec, r bw(1) 
	est store e`x'
}
coefplot (eavgusnegemo, rename(drones =`" "Negative" "emotions" "') offset(0)) (eavgusanger, rename(drones="Anger") offset(0)) (eavgusposemo, rename(drones=`" "Positive" "emotions" "') offset(0)) (eavgusnoterrornegemo, rename(drones=`" "Negative" "emotions" "(no terror)" "') offset(0)) (eavgusnoterroranger, rename(drones=`" "Anger" " " "(no terror)" "') offset(0)) (eavgusnoterrorposemo, rename(drones=`" "Positive" "emotions" "(no terror)" "') offset(0)) (eavgusnodronenegemo , rename(drones=`" "Negative" "emotions" "(no drone)" "') offset(0)) (eavgusnodroneanger, rename(drones=`" "Anger" " " "(no drone)" "') offset(0)) (eavgusnodroneposemo, rename(drones=`" "Positive" "emotions" "(no drone)" "') offset(0)), keep(drones) vertical nolabels msize(large) msymbol(diamond_hollow) mcolor(navy) mlwidth(thick) graphregion(color(white)) bgcolor(white) ciopts(recast(rcap rcap) lwidth(thick) lcolor(gs2) fcolor(gs10)) yline(0, lcolor(red)) nokey yline(0) ytitle("Coefficient of drone strikes") xtitle("") yscale(range(-1.5 2.5)) ylabel(-1.5(0.5)2.5) xlabel(, labsize(small))
gr export "articles6a.eps", replace
!epstopdf "articles6a.eps"


* Terror group articles
eststo drop *
foreach x of varlist avgterrornegemo avgterroranger avgterrorposemo avgterrornousnegemo avgterrornousanger avgterrornousposemo avgterrornodronenegemo avgterrornodroneanger avgterrornodroneposemo {
	qui ivreg2 `x'in14 (drones=gusts) attacks attacksin7 dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 `x'1 `x'2 `x'3 `x'4 `x'5 `x'6 `x'7 `x'8 `x'9 `x'10 `x'11 `x'12 `x'13 `x'14 tmean2_mir lnprec, r bw(1) 
	est store e`x'
}
coefplot (eavgterrornegemo, rename(drones =`" "Negative" "emotions" "') offset(0)) (eavgterroranger, rename(drones="Anger") offset(0)) (eavgterrorposemo, rename(drones=`" "Positive" "emotions" "') offset(0)) (eavgterrornousnegemo, rename(drones=`" "Negative" "emotions" "(no US)" "') offset(0)) (eavgterrornousanger, rename(drones=`" "Anger" " " "(no US)" "') offset(0)) (eavgterrornousposemo, rename(drones=`" "Positive" "emotions" "(no US)" "') offset(0)) (eavgterrornodronenegemo , rename(drones=`" "Negative" "emotions" "(no drone)" "') offset(0)) (eavgterrornodroneanger, rename(drones=`" "Anger" " " "(no drone)" "') offset(0)) (eavgterrornodroneposemo, rename(drones=`" "Positive" "emotions" "(no drone)" "') offset(0)), keep(drones) vertical nolabels msize(large) msymbol(diamond_hollow) mcolor(navy) mlwidth(thick) graphregion(color(white)) bgcolor(white) ciopts(recast(rcap rcap) lwidth(thick) lcolor(gs2) fcolor(gs10)) yline(0, lcolor(red)) nokey yline(0) ytitle("Coefficient of drone strikes") xtitle("") yscale(range(-3 1)) ylabel(-3(0.5)1) xlabel(, labsize(small))
gr export "articles8a.eps", replace
!epstopdf "articles8a.eps"


************************************************************************************************************************************
*** FE6: Emotions robustness check for analyzing sentences, then averaging across articles by day
************************************************************************************************************************************
sort date
* US articles
eststo drop *
foreach x of varlist senavgusnegemo senavgusanger senavgusposemo senavgusnoterrornegemo senavgusnoterroranger senavgusnoterrorposemo senavgusnodronenegemo senavgusnodroneanger senavgusnodroneposemo {
	qui ivreg2 `x'in7 (drones=gusts) attacks attacksin7 dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 `x'1 `x'2 `x'3 `x'4 `x'5 `x'6 `x'7 `x'8 `x'9 `x'10 `x'11 `x'12 `x'13 `x'14 tmean2_mir lnprec, r bw(1) 
	est store e`x'
}
coefplot (esenavgusnegemo, rename(drones =`" "Negative" "emotions" "') offset(0)) (esenavgusanger, rename(drones="Anger") offset(0)) (esenavgusposemo, rename(drones=`" "Positive" "emotions" "') offset(0)) (esenavgusnoterrornegemo, rename(drones=`" "Negative" "emotions" "(no terror)" "') offset(0)) (esenavgusnoterroranger, rename(drones=`" "Anger" " " "(no terror)" "') offset(0)) (esenavgusnoterrorposemo, rename(drones=`" "Positive" "emotions" "(no terror)" "') offset(0)) (esenavgusnodronenegemo , rename(drones=`" "Negative" "emotions" "(no drone)" "') offset(0)) (esenavgusnodroneanger, rename(drones=`" "Anger" " " "(no drone)" "') offset(0)) (esenavgusnodroneposemo, rename(drones=`" "Positive" "emotions" "(no drone)" "') offset(0)), keep(drones) vertical nolabels msize(large) msymbol(diamond_hollow) mcolor(navy) mlwidth(thick) graphregion(color(white)) bgcolor(white) ciopts(recast(rcap rcap) lwidth(thick) lcolor(gs2) fcolor(gs10)) yline(0, lcolor(red)) nokey yline(0) ytitle("Coefficient of drone strikes") xtitle("") yscale(range(-1.5 2.5)) ylabel(-1.5(0.5)2.5) xlabel(, labsize(small))
gr export "articles6b.eps", replace
!epstopdf "articles6b.eps"


* Terror group articles
eststo drop *
foreach x of varlist senavgterrornegemo senavgterroranger senavgterrorposemo senavgterrornousnegemo senavgterrornousanger senavgterrornousposemo senavgterrornodronenegemo senavgterrornodroneanger senavgterrornodroneposemo {
	qui ivreg2 `x'in7 (drones=gusts) attacks attacksin7 dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 `x'1 `x'2 `x'3 `x'4 `x'5 `x'6 `x'7 `x'8 `x'9 `x'10 `x'11 `x'12 `x'13 `x'14 tmean2_mir lnprec, r bw(1) 
	est store e`x'
}
coefplot (esenavgterrornegemo, rename(drones =`" "Negative" "emotions" "') offset(0)) (esenavgterroranger, rename(drones="Anger") offset(0)) (esenavgterrorposemo, rename(drones=`" "Positive" "emotions" "') offset(0)) (esenavgterrornousnegemo, rename(drones=`" "Negative" "emotions" "(no US)" "') offset(0)) (esenavgterrornousanger, rename(drones=`" "Anger" " " "(no US)" "') offset(0)) (esenavgterrornousposemo, rename(drones=`" "Positive" "emotions" "(no US)" "') offset(0)) (esenavgterrornodronenegemo , rename(drones=`" "Negative" "emotions" "(no drone)" "') offset(0)) (esenavgterrornodroneanger, rename(drones=`" "Anger" " " "(no drone)" "') offset(0)) (esenavgterrornodroneposemo, rename(drones=`" "Positive" "emotions" "(no drone)" "') offset(0)), keep(drones) vertical nolabels msize(large) msymbol(diamond_hollow) mcolor(navy) mlwidth(thick) graphregion(color(white)) bgcolor(white) ciopts(recast(rcap rcap) lwidth(thick) lcolor(gs2) fcolor(gs10)) yline(0, lcolor(red)) nokey yline(0) ytitle("Coefficient of drone strikes") xtitle("") yscale(range(-3 1)) ylabel(-3(0.5)1) xlabel(, labsize(small))
gr export "articles8b.eps", replace
!epstopdf "articles8b.eps"


************************************************************************************************************************************
*** FE7: Emotions robustness check for Top Story only 
************************************************************************************************************************************
sort date

eststo drop *
foreach x of varlist topusnegemo topusanger topusposemo topusnoterrornegemo topusnoterroranger topusnoterrorposemo topusnodronenegemo topusnodroneanger topusnodroneposemo {
	qui ivreg2 `x'in7 (drones=gusts) attacks attacksin7 dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 `x'1 `x'2 `x'3 `x'4 `x'5 `x'6 `x'7 `x'8 `x'9 `x'10 `x'11 `x'12 `x'13 `x'14 tmean2_mir lnprec, r bw(1) 
	est store e`x'
}
coefplot (etopusnegemo, rename(drones =`" "Negative" "emotions" "') offset(0)) (etopusanger, rename(drones="Anger") offset(0)) (etopusposemo, rename(drones=`" "Positive" "emotions" "') offset(0)) (etopusnoterrornegemo, rename(drones=`" "Negative" "emotions" "(no terror)" "') offset(0)) (etopusnoterroranger, rename(drones=`" "Anger" " " "(no terror)" "') offset(0)) (etopusnoterrorposemo, rename(drones=`" "Positive" "emotions" "(no terror)" "') offset(0)) (etopusnodronenegemo , rename(drones=`" "Negative" "emotions" "(no drone)" "') offset(0)) (etopusnodroneanger, rename(drones=`" "Anger" " " "(no drone)" "') offset(0)) (etopusnodroneposemo, rename(drones=`" "Positive" "emotions" "(no drone)" "') offset(0)), keep(drones) vertical nolabels msize(large) msymbol(diamond_hollow) mcolor(navy) mlwidth(thick) graphregion(color(white)) bgcolor(white) ciopts(recast(rcap rcap) lwidth(thick) lcolor(gs2) fcolor(gs10)) yline(0, lcolor(red)) nokey yline(0) ytitle("Coefficient of drone strikes") xtitle("") yscale(range(-1.5 2.5)) ylabel(-1.5(0.5)2.5) xlabel(, labsize(small))
gr export "articles6c.eps", replace
!epstopdf "articles6c.eps"

eststo drop *
foreach x of varlist topterrornegemo topterroranger topterrorposemo topterrornousnegemo topterrornousanger topterrornousposemo topterrornodronenegemo topterrornodroneanger topterrornodroneposemo {
	qui ivreg2 `x'in7 (drones=gusts) attacks attacksin7 dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 `x'1 `x'2 `x'3 `x'4 `x'5 `x'6 `x'7 `x'8 `x'9 `x'10 `x'11 `x'12 `x'13 `x'14 tmean2_mir lnprec, r bw(1) 
	est store e`x'
}
coefplot (etopterrornegemo, rename(drones =`" "Negative" "emotions" "') offset(0)) (etopterroranger, rename(drones="Anger") offset(0)) (etopterrorposemo, rename(drones=`" "Positive" "emotions" "') offset(0)) (etopterrornousnegemo, rename(drones=`" "Negative" "emotions" "(no US)" "') offset(0)) (etopterrornousanger, rename(drones=`" "Anger" " " "(no US)" "') offset(0)) (etopterrornousposemo, rename(drones=`" "Positive" "emotions" "(no US)" "') offset(0)) (etopterrornodronenegemo , rename(drones=`" "Negative" "emotions" "(no drone)" "') offset(0)) (etopterrornodroneanger, rename(drones=`" "Anger" " " "(no drone)" "') offset(0)) (etopterrornodroneposemo, rename(drones=`" "Positive" "emotions" "(no drone)" "') offset(0)), keep(drones) vertical nolabels msize(large) msymbol(diamond_hollow) mcolor(navy) mlwidth(thick) graphregion(color(white)) bgcolor(white) ciopts(recast(rcap rcap) lwidth(thick) lcolor(gs2) fcolor(gs10)) yline(0, lcolor(red)) nokey yline(0) ytitle("Coefficient of drone strikes") xtitle("") yscale(range(-3 1)) ylabel(-3(0.5)1) xlabel(, labsize(small))
gr export "articles8c.eps", replace
!epstopdf "articles8c.eps"

************************************************************************************************************************************
*** FE8: Anti-US protests OLS 7 & 14 days
************************************************************************************************************************************
eststo drop *
foreach x of varlist prot_us prot_usdum prot_ter prot_terdum {
	qui newey `x'in7 drones attacks attacksin7 dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 `x'1 `x'2 `x'3 `x'4 `x'5 `x'6 `x'7 `x'8 `x'9 `x'10 `x'11 `x'12 `x'13 `x'14 tmean2_mir lnprec, lag(1) 
	est store e`x'
}
coefplot (eprot_us, rename(drones =`" "Anti-US" "protests" "') offset(0)) (eprot_usdum, rename(drones =`" "Anti-US" "protests" "(binary)" "') offset(0)) (eprot_ter, rename(drones =`" "Anti-terror" "protests" "') offset(0)) (eprot_terdum, rename(drones =`" "Anti-terror" "protests" "(binary)" "') offset(0)), keep(drones) vertical nolabels msize(large) msymbol(diamond_hollow) mcolor(navy) mlwidth(thick) graphregion(color(white)) bgcolor(white) ciopts(recast(rcap rcap) lwidth(thick) lcolor(gs2) fcolor(gs10)) yline(0, lcolor(red)) nokey yline(0) ytitle("Coefficient of drone strikes") xtitle("") yscale(range(-0.1 0.1)) ylabel(-0.1(0.05)0.1) 
gr export "protest2.eps", replace
!epstopdf "protest2.eps"


eststo drop *
foreach x of varlist prot_us prot_usdum prot_ter prot_terdum {
	qui newey `x'in14 drones attacks attacksin14 dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 `x'1 `x'2 `x'3 `x'4 `x'5 `x'6 `x'7 `x'8 `x'9 `x'10 `x'11 `x'12 `x'13 `x'14 tmean2_mir lnprec, lag(1) 
	est store e`x'
}
coefplot (eprot_us, rename(drones =`" "Anti-US" "protests" "') offset(0)) (eprot_usdum, rename(drones =`" "Anti-US" "protests" "(binary)" "') offset(0)) (eprot_ter, rename(drones =`" "Anti-terror" "protests" "') offset(0)) (eprot_terdum, rename(drones =`" "Anti-terror" "protests" "(binary)" "') offset(0)), keep(drones) vertical nolabels msize(large) msymbol(diamond_hollow) mcolor(navy) mlwidth(thick) graphregion(color(white)) bgcolor(white) ciopts(recast(rcap rcap) lwidth(thick) lcolor(gs2) fcolor(gs10)) yline(0, lcolor(red)) nokey yline(0) ytitle("Coefficient of drone strikes") xtitle("") yscale(range(-0.1 0.1)) ylabel(-0.1(0.05)0.1)
gr export "protest4.eps", replace
!epstopdf "protest4.eps"


************************************************************************************************************************************
*** FE9: Google Trends OLS
************************************************************************************************************************************
*** 7 days
eststo drop *
foreach x of varlist jihad tvideo zarb ghazwa  usaid usimmi usefp {
	qui newey `x'in7 drones attacks attacksin7 dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 `x'1 `x'2 `x'3 `x'4 `x'5 `x'6 `x'7 `x'8 `x'9 `x'10 `x'11 `x'12 `x'13 `x'14 tmean2_mir lnprec, lag(1) 
	est store e`x'
}
coefplot (ejihad, rename(drones ="Jihad") offset(0)) (etvideo, rename(drones=`" "Taliban" "video" "') offset(0)) (ezarb, rename(drones=`" "Zarb-e-" "Momin" "') offset(0)) (eghazwa, rename(drones=`" "Ghazwa e" "Hind" "') offset(0))  (eusaid, rename(drones=`" "USAID" "') offset(0)) (eusimmi, rename(drones=`" "US" "immigration" "') offset(0)) (eusefp, rename(drones="USEFP") offset(0)), keep(drones) vertical nolabels msize(large) msymbol(diamond_hollow) mcolor(navy) mlwidth(thick) graphregion(color(white)) bgcolor(white) ciopts(recast(rcap rcap) lwidth(thick) lcolor(gs2) fcolor(gs10)) yline(0, lcolor(red)) nokey yline(0) ytitle("Coefficient of drone strikes") xtitle("") yscale(range(-0.1 0.1)) ylabel(-0.1(0.05)0.1) xlabel(, labsize(small))
gr export "gt1.eps", replace
!epstopdf "gt1.eps"

*** 14 days
eststo drop *
foreach x of varlist jihad tvideo zarb ghazwa  usaid usimmi usefp {
	qui newey `x'in14 drones attacks attacksin14 dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 `x'1 `x'2 `x'3 `x'4 `x'5 `x'6 `x'7 `x'8 `x'9 `x'10 `x'11 `x'12 `x'13 `x'14 tmean2_mir lnprec, lag(1) 
	est store e`x'
}
coefplot (ejihad, rename(drones ="Jihad") offset(0)) (etvideo, rename(drones=`" "Taliban" "video" "') offset(0)) (ezarb, rename(drones=`" "Zarb-e-" "Momin" "') offset(0)) (eghazwa, rename(drones=`" "Ghazwa e" "Hind" "') offset(0))  (eusaid, rename(drones=`" "USAID" "') offset(0)) (eusimmi, rename(drones=`" "US" "immigration" "') offset(0)) (eusefp, rename(drones="USEFP") offset(0)), keep(drones) vertical nolabels msize(large) msymbol(diamond_hollow) mcolor(navy) mlwidth(thick) graphregion(color(white)) bgcolor(white) ciopts(recast(rcap rcap) lwidth(thick) lcolor(gs2) fcolor(gs10)) yline(0, lcolor(red)) nokey yline(0) ytitle("Coefficient of drone strikes") xtitle("") yscale(range(-0.1 0.1)) ylabel(-0.1(0.05)0.1) xlabel(, labsize(small))
gr export "gt3.eps", replace
!epstopdf "gt3.eps"

************************************************************************************************************************************
*** TF1: Compliers
************************************************************************************************************************************
eststo drop *
* Benchmark 1st stage
eststo: qui newey drones gusts dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 attacks1 attacks2 attacks3 attacks4 attacks5 attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14 tmean2_mir lnprec, lag(1)
* DS with target description -- gusts are not an issue
	eststo: qui newey target1 gusts dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 attacks1 attacks2 attacks3 attacks4 attacks5 attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14 tmean2_mir lnprec, lag(1)
* DS targeting leaders (always-takers) -- gusts are not an issue
	eststo: qui newey target3 gusts dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 attacks1 attacks2 attacks3 attacks4 attacks5 attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14 tmean2_mir lnprec, lag(1)
* DS without target description (compliers)
eststo: qui newey unknown gusts dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 attacks1 attacks2 attacks3 attacks4 attacks5 attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14 tmean2_mir lnprec, lag(1)
* DS not explicitly targeting leaders (compliers) 
eststo: qui newey unknown2 gusts dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 attacks1 attacks2 attacks3 attacks4 attacks5 attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14 tmean2_mir lnprec, lag(1)
esttab using "7.tex", se replace se(4) b(4) drop(_cons months* dows* mil_act* attacks*) star(* 0.10 ** 0.05 *** 0.01) sca(fstat)


************************************************************************************************************************************
*** TF2: Autocorrelation 
************************************************************************************************************************************
*** Attacks
qui newey attacks ramadan dows* lnprec tmean2_mir months* date mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14, lag(1)
actest, r
estat durbinalt, force

qui newey attacks attacks1 attacks2 attacks3 attacks4 attacks5 attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14 ramadan dows* lnprec tmean2_mir months* date, lag(1)
*actest, lag(14)
actest, r
estat durbinalt, force


*** DS
qui newey drones ramadan dows* lnprec tmean2_mir months* date, lag(1)
actest, r
estat durbinalt, force

qui newey drones drones1 drones2 drones3 drones4 drones5 drones6 drones7 ramadan dows* lnprec tmean2_mir months* date, lag(1)
*actest, lag(7)
actest, r
estat durbinalt, force


*** Gusts
qui newey gusts dows* lnprec tmean2_mir months* date, lag(1)
actest, r
estat durbinalt, force

qui newey gusts gusts1 gusts2 gusts3 gusts4 gusts5 gusts6 gusts7 gusts8 gusts9 gusts10 gusts11 gusts12 gusts13 gusts14 ramadan dows* lnprec tmean2_mir months* date, lag(1)
*actest, lag(14)
actest, r
estat durbinalt, force


************************************************************************************************************************************
*** TF3: Robustness checks
************************************************************************************************************************************
eststo drop *
preserve 
replace attacksin7=attacksin7*7
* Nbreg
qui nbreg drones gusts dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 attacks1 attacks2 attacks3 attacks4 attacks5 attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14 tmean2_mir lnprec, r
predict drones_hat
eststo: qui nbreg attacksin7 drones_hat dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 attacks1 attacks2 attacks3 attacks4 attacks5 attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14 tmean2_mir lnprec, vce(r)
* IVPoisson
eststo: qui ivpoisson gmm attacksin7 (drones=gusts) dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 attacks1 attacks2 attacks3 attacks4 attacks5 attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14 tmean2_mir lnprec, vce(r)
restore
* Lag(auto) 
eststo: qui ivreg2 attacksin7 (drones=gusts) dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 tmean2_mir lnprec, r bw(auto) first endogtest(drones)
estadd scalar fstat =e(widstat)
* Adding lag of DS
eststo: qui ivreg2 attacksin7 (drones=gusts) drones1 drones2 drones3 drones4 drones5 drones6 drones7 dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 attacks1 attacks2 attacks3 attacks4 attacks5 attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14 tmean2_mir lnprec, r bw(1) first endogtest(drones)
estadd scalar fstat =e(widstat)
* Add Afghanistan attacks
eststo: qui ivreg2 attacksin7 (drones=gusts) dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 attacks1 attacks2 attacks3 attacks4 attacks5 attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14 tmean2_mir lnprec attacksafglag1 attacksafglag2, r bw(1) first endogtest(drones)
estadd scalar fstat =e(widstat)
* Controlling for wind speed but using dummy for wind gusts as IV
eststo: qui ivreg2 attacksin7 (drones=above) wind dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 attacks1 attacks2 attacks3 attacks4 attacks5 attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14 tmean2_mir lnprec, r bw(1) first endogtest(drones)
estadd scalar fstat =e(widstat)
* Drone strikes from New America Foundation 
eststo: qui ivreg2 attacksin7 (drone_naf=gusts) dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 attacks1 attacks2 attacks3 attacks4 attacks5 attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14 tmean2_mir lnprec, r bw(1) first endogtest(drone_naf)
estadd scalar fstat =e(widstat)
* Other terrorism criteria
eststo: qui ivreg2 crit1in7 (drones=gusts) dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 attacks1 attacks2 attacks3 attacks4 attacks5 attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14 tmean2_mir lnprec, r bw(1) first endogtest(drones)
estadd scalar fstat =e(widstat)
eststo: qui ivreg2 crit2in7 (drones=gusts) dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 attacks1 attacks2 attacks3 attacks4 attacks5 attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14 tmean2_mir lnprec, r bw(1) first endogtest(drones)
estadd scalar fstat =e(widstat)
eststo: qui ivreg2 crit3in7 (drones=gusts) dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 attacks1 attacks2 attacks3 attacks4 attacks5 attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14 tmean2_mir lnprec, r bw(1) first endogtest(drones)
estadd scalar fstat =e(widstat)
* Severity
eststo: qui ivreg2 severein7 (drones=gusts) dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 severelag14 tmean2_mir lnprec, r bw(1) first endogtest(drones)
estadd scalar fstat =e(widstat)
* Weapon diversity
eststo: qui ivreg2 w_total (drones=gusts) dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 w_total1 w_total2 w_total3 w_total4 w_total5 w_total6 w_total7 w_total8 w_total9 w_total10 w_total11 w_total12 w_total13 w_total14 tmean2_mir lnprec, r bw(1) first endogtest(drones)
estadd scalar fstat =e(widstat)
esttab using "9.tex", se replace se(4) b(4) drop(_cons dows* ramadan date months* mil_act* attacks* tmean2_mir lnprec mil_act*) star(* 0.10 ** 0.05 *** 0.01) sca(fstat)

*** OLS
eststo drop *
preserve 
replace attacksin7=attacksin7*7
* Nbreg
eststo: qui nbreg attacksin7 drones dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 attacks1 attacks2 attacks3 attacks4 attacks5 attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14 tmean2_mir lnprec, vce(r)
* Poisson
eststo: qui poisson attacksin7 drones dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 attacks1 attacks2 attacks3 attacks4 attacks5 attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14 tmean2_mir lnprec, vce(r)
restore
* Lag(46) 
eststo: newey attacksin7 drones dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 tmean2_mir lnprec, lag(46)
* Adding lag of DS
eststo: qui newey attacksin7 drones drones1 drones2 drones3 drones4 drones5 drones6 drones7 dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 attacks1 attacks2 attacks3 attacks4 attacks5 attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14 tmean2_mir lnprec, lag(1)
* Add Afghanistan attacks
eststo: qui newey attacksin7 drones dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 attacks1 attacks2 attacks3 attacks4 attacks5 attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14 tmean2_mir lnprec attacksafglag1 attacksafglag2, lag(1)
* Controlling for wind speed but using dummy for wind gusts as IV
eststo: qui newey attacksin7 drones wind dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 attacks1 attacks2 attacks3 attacks4 attacks5 attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14 tmean2_mir lnprec, lag(1)
* Drone strikes from New America Foundation 
eststo: qui newey attacksin7 drone_naf dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 attacks1 attacks2 attacks3 attacks4 attacks5 attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14 tmean2_mir lnprec, lag(1)
* Other terrorism criteria
eststo: qui newey crit1in7 drones dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 attacks1 attacks2 attacks3 attacks4 attacks5 attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14 tmean2_mir lnprec, lag(1)
eststo: qui newey crit2in7 drones dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 attacks1 attacks2 attacks3 attacks4 attacks5 attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14 tmean2_mir lnprec, lag(1)
eststo: qui newey crit3in7 drones dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 attacks1 attacks2 attacks3 attacks4 attacks5 attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14 tmean2_mir lnprec, lag(1)
* Severity
eststo: qui reg severein7 drones dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 severelag14 tmean2_mir lnprec, r
* Weapon diversity
eststo: qui newey w_total drones dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 w_total1 w_total2 w_total3 w_total4 w_total5 w_total6 w_total7 w_total8 w_total9 w_total10 w_total11 w_total12 w_total13 w_total14 tmean2_mir lnprec, lag(1)
esttab using "10.tex", se replace se(4) b(4) drop(_cons dows* ramadan date months* mil_act* attacks* tmean2_mir lnprec mil_act*) star(* 0.10 ** 0.05 *** 0.01) sca(fstat)


************************************************************************************************************************************
*** TF4: Target types etc. 
************************************************************************************************************************************
*** IV
eststo drop *
foreach x of varlist bomb assault kidnapping assassination govt business private fata nonfata attrel attnonrel a_reltargeted attsep {
		eststo: qui ivreg2 `x'in7 (drones=gusts) dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 `x'1 `x'2 `x'3 `x'4 `x'5 `x'6 `x'7 `x'8 `x'9 `x'10 `x'11 `x'12 `x'13 `x'14 tmean2_mir lnprec, r bw(1) first endogtest(drones) 
	estadd scalar fstat =e(widstat)
}
esttab using "11.tex", se replace se(4) b(4) drop(_cons dows* ramadan date months* mil_act* tmean2_mir lnprec) star(* 0.10 ** 0.05 *** 0.01) sca(fstat)


*** OLS
eststo drop *
foreach x of varlist bomb assault kidnapping assassination govt business private fata nonfata attrel attnonrel a_reltargeted attsep {
		eststo: qui newey `x'in7 drones dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 `x'1 `x'2 `x'3 `x'4 `x'5 `x'6 `x'7 `x'8 `x'9 `x'10 `x'11 `x'12 `x'13 `x'14 tmean2_mir lnprec, lag(1) 
}
esttab using "12.tex", se replace se(4) b(4) drop(_cons dows* ramadan date months* mil_act* tmean2_mir lnprec) star(* 0.10 ** 0.05 *** 0.01) sca(fstat)
************************************************************************************************************************************
*** TF5: Arrests of terror leaders predict drone strikes
************************************************************************************************************************************
sort date
eststo drop *
eststo: qui newey dronesin7 leadarrest , lag(1)
eststo: qui newey dronesin7 leadarrest dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 tmean2_mir lnprec drones1 drones2 drones3 drones4 drones5 drones6 drones7, lag(1)
eststo: qui newey dronesin7 leadarrest attacksin7 dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 tmean2_mir lnprec drones1 drones2 drones3 drones4 drones5 drones6 drones7, lag(1)
eststo: qui logit dum dumarrest , r
eststo: qui logit dum dumarrest dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 drones1 drones2 drones3 drones4 drones5 drones6 drones7 tmean2_mir lnprec , r
eststo: qui logit dum dumarrest attacksin7 dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 drones1 drones2 drones3 drones4 drones5 drones6 drones7 tmean2_mir lnprec , r
esttab using "6.tex", se replace se(4) b(4) drop(_cons months* dows* mil_act* drones*) star(* 0.10 ** 0.05 *** 0.01) 

********************************************************************************
***TF6 summary stat panel
*******************************************************************************
preserve
import delimited "data panel", clear
label variable prec "Total precipitation"
label variable attacks "terror attacks in Pakistan -GTD"
label variable gusts "max wind gust (km/h) 10 m above ground"
label variable tmean2 "mean temperature (C) 2m above ground"

*** Summary stat panel
sutex attacks gusts tmean2 prec if country=="Pakistan" & attacks!=., dig(2) 
sutex attacks gusts tmean2 prec if country=="Philippines" & attacks!=., dig(2) 
sutex attacks gusts tmean2 prec if country=="India" & attacks!=., dig(2) 
sutex attacks gusts tmean2 prec if country=="Thailand" & attacks!=., dig(2) 
sutex attacks gusts tmean2 prec if country=="Nigeria" & attacks!=., dig(2) 
restore

*********************************************************************************
***TF7: Placebos for past attacks
*********************************************************************************
preserve
foreach x of varlist attacks {
		g `x'avg3lag5=`x'avg3[_n-15]
	g `x'avg3lag7=`x'avg3[_n-21]
	g `x'avg6lag3=`x'avg6[_n-18]
	g `x'avg6lag5=`x'avg6[_n-30]
	g `x'avg6lag7=`x'avg6[_n-42]
	g `x'avg14lag3=`x'avg14[_n-42]
	g `x'avg14lag5=`x'avg14[_n-70]
	g `x'avg14lag7=`x'avg14[_n-98]
	
	}
eststo drop *
* Baseline 
eststo: ivreg2 attacks1 (drones=gusts) dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 attacks2 attacks3 attacks4 attacks5 attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14 tmean2_mir lnprec, r bw(1) first endogtest(drones)
eststo: ivreg2 attacks3 (drones=gusts) dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14 attacks1 attacks2  attacks4 attacks5 attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14 tmean2_mir lnprec, r bw(1) first endogtest(drones)
eststo: ivreg2 attacks5 (drones=gusts) dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14  attacks1 attacks2 attacks3 attacks4  attacks6 attacks7 attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14 tmean2_mir lnprec, r bw(1) first endogtest(drones)
eststo: ivreg2 attacks7 (drones=gusts) dows* ramadan date months* mil_act1 mil_act2 mil_act3 mil_act4 mil_act5 mil_act6 mil_act7 mil_act8 mil_act9 mil_act10 mil_act11 mil_act12 mil_act13 mil_act14  attacks1 attacks2 attacks3 attacks4 attacks5 attacks6  attacks8 attacks9 attacks10 attacks11 attacks12 attacks13 attacks14 tmean2_mir lnprec, r bw(1) first endogtest(drones)
eststo: ivreg2 attacksavg3lag (dronesavg3=gustsavg3) dows* ramadan date months* mil_actavg3 mil_actavg3lag mil_actavg3lag2 mil_actavg3lag3 mil_actavg3lag4 attacksavg3  attacksavg3lag2 attacksavg3lag3 attacksavg3lag4 tmean2_miravg3 lnprecavg3 if ign3==0, r bw(1) first endogtest(dronesavg3)
eststo: ivreg2 attacksavg3lag3 (dronesavg3=gustsavg3) dows* ramadan date months* mil_actavg3 mil_actavg3lag mil_actavg3lag2 mil_actavg3lag3 mil_actavg3lag4 attacksavg3 attacksavg3lag attacksavg3lag2  attacksavg3lag4 tmean2_miravg3 lnprecavg3 if ign3==0, r bw(1) first endogtest(dronesavg3)
eststo: ivreg2 attacksavg3lag5 (dronesavg3=gustsavg3) dows* ramadan date months* mil_actavg3 mil_actavg3lag mil_actavg3lag2 mil_actavg3lag3 mil_actavg3lag4 attacksavg3 attacksavg3lag attacksavg3lag2 attacksavg3lag3 attacksavg3lag4 tmean2_miravg3 lnprecavg3 if ign3==0, r bw(1) first endogtest(dronesavg3)
eststo: ivreg2 attacksavg3lag7 (dronesavg3=gustsavg3) dows* ramadan date months* mil_actavg3 mil_actavg3lag mil_actavg3lag2 mil_actavg3lag3 mil_actavg3lag4 attacksavg3 attacksavg3lag attacksavg3lag2 attacksavg3lag3 attacksavg3lag4 tmean2_miravg3 lnprecavg3 if ign3==0, r bw(1) first endogtest(dronesavg3)
eststo: ivreg2 attacksavg6lag (dronesavg6=gustsavg6) dows* ramadan date months* mil_actavg6 mil_actavg6lag attacksavg6  tmean2_miravg6 lnprecavg6 if ign6==0, r bw(1) first endogtest(dronesavg6)
eststo: ivreg2 attacksavg6lag3 (dronesavg6=gustsavg6) dows* ramadan date months* mil_actavg6 mil_actavg6lag attacksavg6 attacksavg6lag tmean2_miravg6 lnprecavg6 if ign6==0, r bw(1) first endogtest(dronesavg6)
eststo: ivreg2 attacksavg6lag5 (dronesavg6=gustsavg6) dows* ramadan date months* mil_actavg6 mil_actavg6lag attacksavg6 attacksavg6lag tmean2_miravg6 lnprecavg6 if ign6==0, r bw(1) first endogtest(dronesavg6)
eststo: ivreg2 attacksavg6lag7 (dronesavg6=gustsavg6) dows* ramadan date months* mil_actavg6 mil_actavg6lag attacksavg6 attacksavg6lag tmean2_miravg6 lnprecavg6 if ign6==0, r bw(1) first endogtest(dronesavg6)
eststo: ivreg2 attacksavg14lag (dronesavg14=gustsavg14) ramadan date months* mil_actavg14 attacksavg14 tmean2_miravg14 lnprecavg14 if ign14==0, r bw(1) first endogtest(dronesavg14)
eststo: ivreg2 attacksavg14lag3 (dronesavg14=gustsavg14) ramadan date months* mil_actavg14 attacksavg14 tmean2_miravg14 lnprecavg14 if ign14==0, r bw(1) first endogtest(dronesavg14)
eststo: ivreg2 attacksavg14lag5 (dronesavg14=gustsavg14) ramadan date months* mil_actavg14 attacksavg14 tmean2_miravg14 lnprecavg14 if ign14==0, r bw(1) first endogtest(dronesavg14)
eststo: ivreg2 attacksavg14lag7 (dronesavg14=gustsavg14) ramadan date months* mil_actavg14 attacksavg14 tmean2_miravg14 lnprecavg14 if ign14==0, r bw(1) first endogtest(dronesavg14)
esttab using "placebo.tex", se replace se(4) b(4) drop(_cons months* dows* attacks* ramadan date) star(* 0.10 ** 0.05 *** 0.01) sca(fstat olea oleacric oleacric2) 

restore

************************************************************************************************************************************
*** TF8: Summary stats additional variables
************************************************************************************************************************************
sutex drone_naf unknown unknown2 target3 target1 above  deaths attacksafg attacksiraq attacksisrael gusts_karachi gustsiraq gustsisrael  crit1 crit2 crit3 severe fata nonfata bomb assault kidnapping assassination govt private business attrel attnonrel a_reltargeted attsep w_total leadarrest, dig(2) par minmax 

sutex numdrone numus numterror avgdronenegemo avgdroneanger avgdroneposemo avgusnegemo avgusanger avgusposemo avgusnoterrornegemo avgusnoterroranger avgusnoterrorposemo avgusnodronenegemo avgusnodroneanger avgusnodroneposemo avgterrornegemo avgterroranger avgterrorposemo avgterrornousnegemo avgterrornousanger avgterrornousposemo avgterrornodronenegemo avgterrornodroneanger avgterrornodroneposemo  senavgusnegemo senavgusanger senavgusposemo senavgusnoterrornegemo senavgusnoterroranger senavgusnoterrorposemo senavgusnodronenegemo senavgusnodroneanger senavgusnodroneposemo senavgterrornegemo senavgterroranger senavgterrorposemo senavgterrornousnegemo senavgterrornousanger senavgterrornousposemo senavgterrornodronenegemo senavgterrornodroneanger senavgterrornodroneposemo  topusnegemo topusanger topusposemo topusnoterrornegemo topusnoterroranger topusnoterrorposemo topusnodronenegemo topusnodroneanger topusnodroneposemo topterrornegemo topterroranger topterrorposemo topterrornousnegemo topterrornousanger topterrornousposemo topterrornodronenegemo topterrornodroneanger topterrornodroneposemo prot_us  prot_ter  jihad tvideo zarb ghazwa usaid usimmi usefp , dig(2) par minmax






