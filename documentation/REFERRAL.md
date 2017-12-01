# Patient Referral Rules

Flag a Patient as a recommended candidate for Lactation consulting referral if any of the following conditions are met:
-	Patient has submitted concerns.

Calculated responses rather than questionnaire:
-	if currentDate – birthdate >=4 and Breastmilkstarted==false 
-	If currentDate – birthdate < 7 and median breastfeeding interval >3 hours or Maximum breastfeeding interval >5 hours 
-	if currentDate – birthdate < 7 and avg wet diapers < 6
-	if (currentDate – birthdate >=4 and BowelTransition==false) || ((Breastmilkstated==true && bowelTransition==false) && (currentDate - dateBreastmilkstarted)>=2) 

Weight observation flags (Pediatrician EHR):
-	If currentDate – birthdate < 10 and weight < 91% of birthweight 
-	If currentDate – birthdate is between 10 and  14  and weight < 95% of birthweight
-	If currentDate – birthdate >=14 and weight < birthweight.


## Visualization
Chart weight using 0-3 months data from here: https://www.cdc.gov/growthcharts/who_charts.htm  
-	External mentors will see about third party data.

Once the patent has been highlighed as a referral candidate, a test field should have a human readable list of all of the conditions that were met to recommend a lactation consulation.

