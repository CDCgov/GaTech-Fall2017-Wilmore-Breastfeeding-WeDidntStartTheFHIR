## Test Status:
1. PASS - No Patients 
2. PASS - Incomplete Patient Data 
3. PASS - New Patient - PASS 
4. PASS - New Patient, no weight data - PASS
5. PASS - Questionnaire partial, breastfeeding not on track 
6. Unused
7. PASS - Multiple weight entries
8. PASS - Risk Factor Type 1 Diabetes 
9. PASS - Concerns Flagged 
10. PASS - Four days no breastmilk flagged 
11. PASS - Not enough breastfeeding flagged 
12. PASS - Not enough wet diapers flagged
13. PASS - 10 days, 10% weight loss flagged
14. PASS - 12 days, 5% weight loss flagged
15. PASS - 14 days, weight < birth weight flagged 
16. Unused
17. Unused
18. PASS - Risk Factor Maternal BMI > 29 - Patient info shows BMI of 30.


## Test Procedure
+ Docker container with test data, fhir server and physician portal web app must be loaded. 
+ If you have run before run `docker-compose down` to kill a previous session. (May take several seconds)
+ If the app has been updated you may need to rebuild with `docker-compose build`
+ Start `docker-compose up` 
+ From an internet browser, navigate to http://127.0.0.1:8080
+ Verify fhir database is running by viewing HAPI server with populated data. May take a couple of minutes after run command before site is visible and populated. 
+ Using a browser, navigate to http://127.0.0.1:8080/portal/
+ Verify portal contains default patient data.
+ Run script using scriptname defined in test description
  + docker exec finaldelivery_wedidntstartfhir_1 /bin/bash /root/testcase/TestCase<#>/testcase<#>.sh
+ Based on expected results, select the test patient being tested and visually inspect the page for expected results. 
+ _NOTE: Test 1 and 2 need to start from a fresh container state and the container should be discarded "docker-compose down" after test.  All of the later test can be run sequentially on the same container  - this can be done with this command after the container is running: `docker exec finaldelivery_wedidntstartfhir_1 /bin/bash /root/testcase/runtests3_18.sh`_
+ Record results and indicate reason for failure if needed. 

## Test Descriptions
+ Test Case 1
  + Test Name: No Patients
  + Description: Empty database where no patient information exists
  + Script: testcase1.sh
  + Expected Results: Portal contains no links to patients.

+ Test Case 2
  + Test Name: Incomplete Patient Data
  + Description: Patient data resource does not contain all displayed data such as address and phone number.
  + Script: testcase2.sh
  + Expected Results: Portal displays existing data and leaves unknown data blank.

+ Test Case 3
  + Test Name: New Patient 
  + Description: Additional patient information is added to the database. 
  + Script: testcase3.sh
  + Expected Results: Portal displays new patient in patient list. Selecting that patient show relevant information.

+ Test Case 4
  + Test Name: New Patient, no weight data
  + Description: Additional patient information is added to the database but is missing weight data for baby. 
  + Script: testcase4.sh
  + Expected Results: Portal displays new patient in patient list. Selecting that patient show relevant information. No weight chart shown.

+ Test Case 5
  + Test Name: Existing patient partial questionairre
  + Description: Viewing patient with partial data from questionnaire available.
  + Script: testcase5.sh
  + Expected Results: Portal shows answers to patient questions where they have been answered and correctly recommeds a referal.

+ Test Case 7
  + Test Name: Multiple weight entries
  + Description: Viwing patient with a hostory of weights for infant.
  + Script: testcase7.sh
  + Expected Results: Infant weights shown on chart as blue dots.

+ Test Case 8
  + Test Name: Risk Factor Type 1 Diabetes
  + Description: Claim data indicates patient has Type I Diabetes (E10.1)
  + Script: testcase8.sh
  + Expected Results: Viewing patient shows indication that patient has a risk factor.

+ Test Case 9
  + Test Name: Concerns Flagged
  + Description: Questionairre response indicates patient has concerns.
  + Script: testcase9.sh
  + Expected Results: Viewing patient shows indication that patient has concerns.

+ Test Case 10
  + Test Name: Four days no breastmilk flagged
  + Description: Questionairre response indicates patient's breast milk has not come in after 4 days.
  + Script: testcase10.sh
  + Expected Results: Viewing patient shows referral flags.

+ Test Case 11
  + Test Name: Not enough breastfeeding flagged
  + Description: Questionairre response indicates patient is not breast feeding enough.
  + Script: testcase11.sh
  + Expected Results: Viewing patient shows referral flags.

+ Test Case 12
  + Test Name: Not enough wet diapers flagged
  + Description: Questionairre response indicates patient baby has not had enough wet diapers.
  + Script: testcase12.sh
  + Expected Results: Viewing patient shows referral flags.

+ Test Case 13
  + Test Name: 10 days, 10% weight loss flagged
  + Description: Weight observations show baby not gaining enough weight.
  + Script: testcase13.sh
  + Expected Results: Viewing patient shows referral flags.

+ Test Case 14
  + Test Name: 12 days, 5% weight loss flagged
  + Description: Weight observations show baby not gaining enough weight.
  + Script: testcase14.sh
  + Expected Results: Viewing patient shows referral flags.

+ Test Case 15
  + Test Name: 14 days, weight < birth weight flagged 
  + Description: Weight observations show baby not gaining enough weight.
  + Script: testcase15.sh
  + Expected Results: Viewing patient shows referral flags.

+ Test Case 18
  + Test Name: Risk Factor Maternal BMI > 29
  + Description: Observation data indicates patient has BMI > 29
  + Script: testcase18.sh
  + Expected Results: Viewing patient shows indication that patient has BMI of 30.


