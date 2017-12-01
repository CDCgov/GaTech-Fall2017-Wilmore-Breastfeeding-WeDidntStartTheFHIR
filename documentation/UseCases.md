# Hospital EHR and Discharge
A new mother is discharged from the hospital where various metrics on the baby’s weight has been recorded into the EHR.  Mother would be flagged as breastfeeding in hospital.  Data about the new mother that can be used to signify that she is a high risk mother for Breastfeeding issues are also recorded.

The mother’s first well baby visit is scheduled and she is advised to download the Breastfeeding support app and start tracking breastfeeding and diaper status.  At the first well baby visit the Pediatrician opens the patient record and the SMART on FHIR Breastfeeding support app compares the collected data from the hospital EHR (mother risk factors, babies weights), the pediatrician EH, the patient supplied records against a set of rules provided by the CDC and flags the patient as a referral candidate for lactation services or not. 

# Mother’s use of the iOS APP
_(future) - The first time the app is launched it will collect data from the Hospital EHR and request permission to transmit data on the Mother’s risk factors to the Pediatrician EHR._

At launch of the iOS app the mother is asked if her breast milk has come in and if the baby’s bowel movements have transitions.  If the answer to either of these questions is NO, then the first time that the mother uses the app the next day, whichever questions had a NO answer will be asked again.

After these questions have been answered, the app offers the mother a convenient way to track feeding times with a stopwatch.  The mother should open the app at each feeding start the stopwatch and stop the stopwatch immediately after the feeding.  Based on memory, at each feeding the mother should increment the wet diaper count.  The data on the feedings and wet diapers is summarized and send to the pediatrician EHR every day. 

# Physician Dashboard
The physician should be able to see the report of day worth of breastfeeding data. Based on this information and the history, the patient (mother) should be able to flagged or not flagged that if they need to talk to a lactation consultant. 

If the patient is flagged as a referral candidate, the app enables the selection of referral to a lactation consultant once the physician secures the patient's consent.  The referral is issued by the Smart app in the EMR.  A text description of why the patient is flagged as a referral candidate based on the logic of the flagging is displayed.
If the patient is not flagged, but is close to the level, the physician is notified that the patient is borderline and referral can be initiated.
If the patient is flagged as low risk a message is displayed that they are on track.

In all of these cases there is a graphical display of the babies weights that is compared to expectations.

A button will be available for Initiate referral that will open a form to collect the referral relevant data - pre populated.

# Lactation consultant Referral
_Lactation Consultant Portal (Out of scope - for fall 2017)_

The lactation consultant should give advice to patient based on the patient’s medical history and breastfeeding record, to make both mother and the baby healthy.

As a Lactation Consultant or physician, I want to be able to authorize the transfer of patient data between the lactation consultant and the physician if the patient consents so that both parties can be informed and provide the best possible care to the patient.

As a Lactation Consultant, I want to be able to see the patient data the physician records so that I can better understand the challenges the patient is facing so I can provide the best consultation possible.

As a physician, I want to be able to see the data the lactation consultant records so that I can have a better picture of my patient’s experiences and needs so that I can provide the best care possible.
