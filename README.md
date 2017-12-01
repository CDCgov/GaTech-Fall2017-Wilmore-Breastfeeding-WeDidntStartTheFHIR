# CDC-BREASTFEEDING-SUPPORT-INITIATIVE


This is an evolving an multifaceted project that has been implemented my multiple Georgia Tech team in concert with the CDC.

![CDC BreastFeeding Support Iniitiative](documentation/CDC_breastfeedingsupport_Initiative.pdf)

The first Georgia Tech team - Panda implemented an initial iOS APP to track new mother survey response, track feedings, a physician portal to see the survey questions, initiate a referral, and finally a lactation consultant portal to receive the referrals

The work of this team is saved in the previous team directory.

![Previous Team Project](Spring2017Panda/README.md)


The Fall 2017 Georgia Tech <Jamon Bowen, John Van Wagenen, Justin Kristensen, Philip Baxley, Zeyu Yang> team expanded on this work to expand the scope of the iOS app to automate much of the survey responses through the mother's use of of the app to track feedings, as well as to lay the foundation for the app to act as the bridge between the hospital EHR system and the Pediatrician EHR system.  Additionally, the pediatrician portal has been expanded to implement a decision support procedure to recommend when new mothers should be referred to a lactation consultant.

The ![documentation](documentation) directory contains details on the current version of the project, plans specific to development and architectural details.  The other directories contain specific portions of this solution and documentation specific to these modules.

To launch this project follow the instructions ![here](Final%20Delivery/Special%20Instructions%20-%20We%20Didn't%20Start%20the%20FHIR.md)

Outside of the scope of this project, but required prior to final delivery is enhancements to the lactation consultant portal to accept patient data and provide feedback on the success of the consultation.  Additional, a population view of all of a pediatrician’s new mother patients is omitted.  Adding these components would be a straight forward project for another team with 4-5 members as a 6-8 week project.

Future work:
If the App and EHR portal are released as products into the medical community they should enable the collection on interesting population health data.  The current solution should be enhanced to enable new mothers to view the clinical decision support data to help them adjust their behavior to be in the best interest of the child.  Changes in the self-reported tracking data can also be used to objectively measure the success of various lactation consultations.  These aspects of the tool are logical extensions of the current work.  

In addition, we have tried to make the iOS app collect data that will be of broad use in future studies.  Provided that value is achieve from new mothers using the App, they will be incentivized to record breastfeeding information from start of life.  With a large enough population of patient recording this data, with a clinician providing prompt feedback to the patient based on the data, it is more likely that the data will be accurate for the initial weeks of collection.  This population data on feeding time, duration, interval, weight changes, etc. should provide a wealth of information that can be used in population research studies on early life development, data based validation of the clinical decisions on referral, and data to validate the impact of breastfeeding practices on future health.  While it will take some time of active use of the solution to create a large enough data set to assist these studies - we believe the project should continue with this additional goal in mind. 
