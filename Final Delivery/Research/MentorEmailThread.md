Jamon Bowen <jamon.bowen@gmail.com>
AttachmentsOct 17

to Sridevi, Madhulekha, jtvanwage, me, potatoyzy, justinkristens., Jennifer, Arunkumar 
Hi Jennifer and Sri,

We did some initial scoping and here is what we think we can get done with the project (attached)

Please let us know what you think.

We are working on a few use case scenarios that we'd like feedback on that we'll send later this week.  One of the areas we'll be looking for guidance on initially is defining the right data to leverage and what would flag a mother and newborn as referral candidates based on the available clinical and patient supplied data.

Thanks!
[Statement of Work - CDC BREASTFEEDING SUPPORT INITIATIVE](./Statement of Work - CDC BREASTFEEDING SUPPORT INITIATIVE.pdf)
---
Wilmore, Sridevi (CDC/ONDIEH/NCCDPHP) <eur3@cdc.gov>
AttachmentsOct 18

to Jamon, Madhulekha, jtvanwage, me, potatoyzy, justinkristens., Jennifer, Arunkumar 
Hi all,
 
The statement of work is great!  Thanks for getting this done.  While you are thinking through case scenarios, we will do the same and we will also brainstorm on pediatrician lactation referral decision support dashboard.  As Jennifer mentioned on the call, the dashboard should support quick (5 min) physician decision making – so any questions for the physician to respond to/select in the dashboard, displays etc. should be developed based on that “quick glance” concept. 
 
Thanks,
Sri
---
Wilmore, Sridevi (CDC/ONDIEH/NCCDPHP) <eur3@cdc.gov>
Oct 20

to Jamon, Madhulekha, jtvanwage, me, potatoyzy, justinkristens., Jennifer, Arunkumar 
Hi all,
Thank you for the call and your efforts!  See the attached ppt and feel free to shoot us email questions as we move along and we will respond as quickly as possible.
Sri
 
[Case Scenarios & Pediatrician Dashboard](./Case Scenarios & Pediatrician Dashboard.pptx)
---
Jamon Bowen <jamon.bowen@gmail.com>
Oct 23

to Sridevi, Madhulekha, jtvanwage, me, potatoyzy, justinkristens., Jennifer, Arunkumar 
Hi Sri and Jennifer,

Here is what we put together for our project plan:
[https://youtu.be/E_yDY4Lqvlg]

Please send over any thoughts or links to resources you'd like us to use for the clinical logic of when to initiate a referral. We'll be mainly working on the back end of the solution this week.

Thanks!
---
Wilmore, Sridevi (CDC/ONDIEH/NCCDPHP) <eur3@cdc.gov>
Oct 25

to Jamon, Madhulekha, jtvanwage, me, potatoyzy, justinkristens., Jennifer, Arunkumar 
Hi Team
 
I wanted to let you know we are working on the clinical concepts, but I wanted to update you quickly and let you know that Jennifer and I had a conversation and to align more with your class concept of using FHIR and EHR we do want the additional components that mom provides to pediatrician should be fed in from the hospital EHR to the mother app.  So infant birth weight and time, mothers risk factors, etc. the data elements from the EHR should be mapped to FHIR resources and transmitted to mother app.  Then mother authorizes pediatrician to view by clicking submit/transmit to pediatrician portal.  We hope to send you the clinical concepts bullets later today.
 
One other point to help you get started is that anytime mom responds no to any of the survey questions this will trigger a flag on mom for pediatrician to investigate breastfeeding issues for a lactation referral.
 
I am unable to schedule a call for tomorrow morning, but if everyone is available I will schedule a call for Monday morning.
 
Thanks,
Sri
---
Jamon Bowen <jamon.bowen@gmail.com>
Oct 25

to Sridevi, Madhulekha, jtvanwage, me, potatoyzy, justinkristens., Jennifer, Arunkumar 
Thanks Sri,

Monday should work.  We have the patient app connecting to a standalone FHIR server but noticed that the app was using FHIR level 2 - we are assuming we should update this to level 3?  If you have an details on the EHR that is the initial target and the FHIR server level that will help.

Thanks,
Jamon
---
Wilmore, Sridevi (CDC/ONDIEH/NCCDPHP) <eur3@cdc.gov>
Oct 25

to Jamon, Madhulekha, jtvanwage, me, potatoyzy, justinkristens., Jennifer, Arunkumar 
Hi all,
 
Yes you should update this to level 3.  Other students noted they are using the Cerner EHR sandbox for their projects so that may be an easy option, but we really don’t have a preference.
---
Wilmore, Sridevi (CDC/ONDIEH/NCCDPHP) <eur3@cdc.gov>
Oct 26

to Jamon, Madhulekha, jtvanwage, me, potatoyzy, justinkristens., Jennifer, Arunkumar 
Hi all,
See the attached and we hope this helps in development.  We can address any questions/concerns on the call Monday.
Thanks,
Sri

[GA Tech Breastfeeding Project Fall 2017 v2](./GA Tech Breastfeeding Project Fall 2017 v2.docx)
---
Arunmozhi, Madhulekha <madhulekha@gatech.edu>
Oct 30

to Tia, Jamon, Sridevi, jtvanwage, me, potatoyzy, justinkristens., Jennifer, Arunkumar, Paula 
Hi Tia
 
The team wanted to know if there are any resources/info on FHIR and EHR sandboxes they can use, for example Cerner EHR sandbox?
They want to connect their patient app to a FHIR server which has an EHR platform too.
 
Regards,
Madhu
---
From: "Pope, Tia M" <tiapope@gatech.edu>
Date: Monday, October 30, 2017 at 6:30 PM
To: "Arunmozhi, Madhulekha" <madhulekha@gatech.edu>, Jamon Bowen <jamon.bowen@gmail.com>, "Wilmore, Sridevi (CDC/ONDIEH/NCCDPHP)" <eur3@cdc.gov>
Cc: "jtvanwage@gmail.com" <jtvanwage@gmail.com>, "pabbyy@gmail.com" <pabbyy@gmail.com>, "potatoyzy@gmail.com" <potatoyzy@gmail.com>, "justinkristensen7@gmail.com" <justinkristensen7@gmail.com>, "Nelson, Jennifer M. (CDC/ONDIEH/NCCDPHP)" <zcn6@cdc.gov>, "Srinivasan, Arunkumar (CDC/ONDIEH/NCCDPHP)" <fos2@cdc.gov>, "Braun, Paula A. (CDC/OPHSS/NCHS)" <pax1@cdc.gov>

---
Jamon Bowen
Oct 30

to Madhulekha, Tia, Sridevi, jtvanwage, me, potatoyzy, justinkristens., Jennifer, Arunkumar, Paula 
Hi Tia and Madhu,

I think we are ok - we found there is a smart on fhir ehr app sandbox here:https://sandbox.smarthealthit.org/#/start

We plan on using our fhir docker instance and local web hosting for the alpha phase (the basic connections are all working now) and plan to make sure that this sandbox can launch the app properly during testing - just to make sure we haven't broken any requirements.  If you have alternative suggestions let us know!
---

Phillip Baxley <pabbyy@gmail.com>
Nov 1

to Madhulekha, Jamon, Tia, Paula, Jennifer, Arunkumar, Sridevi, jtvanwage, justinkristens., potatoyzy 
Jen and Sri,

There were a couple of actions items from the Monday meeting to provide us some information and I wanted to see how it was going   

One was what FHIR resource we could use for identifying the delivery procedure. There was a mention this would be part of the billing information. At the time it was not clear which FHIR resource this would be part of and how it would tie to the patient. 

Second were the ICD codes we should be using for the diagnostic codes for the diabetes and thyroid conditions we are basing referrals on. 

If the needed we can just take an approach and make sure it is documented appropriately so that if they turn out to be wrong in a real world scenario it can be corrected in the future. 

Thanks for your time

-Phil Baxley
---
Wilmore, Sridevi (CDC/ONDIEH/NCCDPHP)
AttachmentsNov 2

to me, Madhulekha, Jamon, Tia, Paula, Jennifer, Arunkumar, jtvanwage, justinkristens., potatoyzy 
Hi Phil/all
Sorry for the delay.  Here is what we have so far to assist with coding and FHIR resource use for identifying conditions.  Just a note that we may more risk factor codes and we will get this to you as soon as possible.

[Birth & Breastfeeding ICD 10 codes](./Birth & Breastfeeding ICD 10 codes.pdf)
---
Justin Kristensen <justinkristensen7@gmail.com>
Oct 28

to eur3, zcn6, fos2, Jamon, John, me, Zeyu 
External Mentors:

We have several questions concerning the representation of the relation between the mother and her newborn in the Breastfeeding Support system using FHIR resources.

1. Will the system need to support two types of patients, the mother and her newborn?

2. What FHIR resource(s) would you recommend using to represent the relationship between the mother and her newborn in the system?

We can discuss this in our meeting on Monday. Thank you.

Sincerely,

Justin Kristensen
---
Wilmore, Sridevi (CDC/ONDIEH/NCCDPHP) <eur3@cdc.gov>
Oct 30

to Justin, Jennifer, Arunkumar, Jamon, John, me, Zeyu 
Hi all,
 
As Jennifer mentioned, mother and baby are separate patients in EHR systems, so they do require separate patient FHIR resources.  See this link http://hl7.org/fhir/2016sep/patient.html  in terms of managing their linkage using FHIR.  There is a table shown on this page on how to manage patients.  Also, section 8.1.7 speaks to the mother newborn relationship.  The additional FHIR resources needed are encounter and familymemberhistory.  There is also a very specific example on a maternity encounter resource that should be helpful.
 
|Patient.contact.relationship|The nature of the relationship between a patient and a contact person for that patient.|Extensible|v2 Contact Role
---
 
From: Justin Kristensen [mailto:justinkristensen7@gmail.com] 
Sent: Saturday, October 28, 2017 12:27 PM
To: Wilmore, Sridevi (CDC/ONDIEH/NCCDPHP) <eur3@cdc.gov>; Nelson, Jennifer M. (CDC/ONDIEH/NCCDPHP) <zcn6@cdc.gov>; Srinivasan, Arunkumar (CDC/ONDIEH/NCCDPHP) <fos2@cdc.gov>
Cc: Jamon Bowen <jamon.bowen@gmail.com>; John Van Wagenen <jtvanwage@gmail.com>; Phillip Baxley <pabbyy@gmail.com>; Zeyu Yang <potatoyzy@gmail.com>
Subject: Question on Mother and Baby relation FHIR resource?


Phillip Baxley <pabbyy@gmail.com>
Oct 30

to Sridevi, Justin, Jennifer, Arunkumar, Jamon, John, Zeyu 
I have some related followup questions. 

A later version suggest using the RelatedPerson field, https://www.hl7.org/fhir/STU3/patient.html section 8.1.8. Should we also use the FamilyMemberHitory as well? 

Diagnoses:
Looking over the DiagnosisReport field it looks like the appropriate field to determine if the patient has a condition such as Diabetes Type I, we would use the codedDiagnosis field. https://www.hl7.org/fhir/STU3/DiagnosticReport.html
When I look at SNOWMED, there are many different codes for different variations of the condition. Should we stick with one for the purposes of this particular project or should we be handling several that might define a single condition? This is a similar issue when it comes to the birth procedure codes.
---

Wilmore, Sridevi (CDC/ONDIEH/NCCDPHP)
Oct 30

to me, Justin, Jennifer, Arunkumar, Jamon, John, Zeyu 
Yes absolutely thank you for referring to the latest!
 
From: Phillip Baxley [mailto:pabbyy@gmail.com] 
Sent: Monday, October 30, 2017 8:50 AM
To: Wilmore, Sridevi (CDC/ONDIEH/NCCDPHP) <eur3@cdc.gov>
Cc: Justin Kristensen <justinkristensen7@gmail.com>; Nelson, Jennifer M. (CDC/ONDIEH/NCCDPHP) <zcn6@cdc.gov>; Srinivasan, Arunkumar (CDC/ONDIEH/NCCDPHP) <fos2@cdc.gov>; Jamon Bowen <jamon.bowen@gmail.com>; John Van Wagenen <jtvanwage@gmail.com>; Zeyu Yang <potatoyzy@gmail.com>
Subject: Re: Question on Mother and Baby relation FHIR resource?
---
Phillip Baxley <pabbyy@gmail.com>
AttachmentsNov 12

to Jamon, Sridevi, Madhulekha, jtvanwage, potatoyzy, justinkristens., Jennifer, Arunkumar, Joan, Michelle, Tia 
Sri and Jennifer,

Was the list provided a couple of weeks ago the final list? I seem to remember a discussion that there might be some additions or deletions.

Thanks,
Phillip Baxley
---
Wilmore, Sridevi (CDC/ONDIEH/NCCDPHP)
Nov 13

to me, Jamon, Madhulekha, jtvanwage, potatoyzy, justinkristens., Jennifer, Arunkumar, Joan, Michelle, Tia 
Hi Phillip and all,
You can use the ICD list we provided.  For this semester, we will stick with that list and then move on to something more advanced in future semesters.
Thank you!
---

Wilmore, Sridevi (CDC/ONDIEH/NCCDPHP)
AttachmentsNov 21 (11 days ago)

 to Madhulekha, jtvanwage, me, potatoyzy, justinkristens., Jennifer, Jamon, Arunkumar, Joan, Michelle, Tia 
Dear Team
 
We have been working on getting you NEWT API information and you will see the information in the attached email from the developer.  You will see that it hasn’t been tested widely so please let us know about any challenges you run into.
 
Happy Thanksgiving!
Sri
---

---------- Forwarded message ----------
From: "Nelson, Jennifer M. (CDC/ONDIEH/NCCDPHP)" <zcn6@cdc.gov>
To: Adam Meyer <adam@apmeyer.com>
Cc: "Griffin, Jerry" <ggriffin@pennstatehealth.psu.edu>, "Wilmore, Sridevi (CDC/ONDIEH/NCCDPHP)" <eur3@cdc.gov>
Bcc: 
Date: Tue, 21 Nov 2017 18:45:41 +0000
Subject: RE: Newt API
Greetings Adam,
 
I am cc’ing Sri Wilmore who is the IT SME on this project.
 
Sincerely, Jennifer
 
From: Adam Meyer [mailto:adam@apmeyer.com] 
Sent: Tuesday, November 21, 2017 1:11 PM
To: Nelson, Jennifer M. (CDC/ONDIEH/NCCDPHP) <zcn6@cdc.gov>
Cc: Griffin, Jerry <ggriffin@pennstatehealth.psu.edu>
Subject: Newt API
 
Hello Jennifer. I am the developer who created newbornweight.org (Newt) with Penn State Health. Jerry Griffin at Penn State Health asked that I reach out to you regarding an inquiry into potentially making Newt accessible to other applications.
 
We did recently create an API for staff within Penn State to be able to access the data programmatically – vs using the website user interface. It has not yet been put through the paces for testing to be used on a wide scale – so, that’s one thing we’d need to consider if it is to be put into use on a broader scale. We don’t have documentation pulled together for using this API, but I’ve outlined the parameters below. It’s possible that we could make changes to it if necessary. We’d just need to see what was needed and how much time it would take to make necessary updates.
 
Please let me know if you have any questions.
 
Thanks.
 
Adam Meyer
763.458.7203
@apmeyer | LinkedIn
 
 
Here are some details and a sample API call:
 
 
Sample API Call:
 
https://www.newbornweight.org/api/v1/measurements/?measurements=0%255Btimestamp%255D%3D1416853260%260%255Bweight%255D%3D3.38%261%255Btimestamp%255D%3D1416929700%261%255Bweight%255D%3D3.27%262%255Btimestamp%255D%3D1417005240%262%255Bweight%255D%3D3.29%263%255Btimestamp%255D%3D1417045500%263%255Bweight%255D%3D3.18&birth_time=1416796440&birth_weight=3.45&birth_type=vag&feed_method=bf&api_key=yu78kjh27cus5667xfg2lop
 
This returns the measurements in JSON format.
 
 
Parameters
 
In the above URL you’ll see the following data being passed to the API:
 
measurements
The application is PHP based. In PHP this is an array that is double encoded, first using http_build_query()  then using urlencode()  Other languages would just need to encode to achieve the resulting format. The format (in PHP) of the array to encode:
 
array(
    array('timestamp' => '1416853260', 'weight' => '3.38'),
    array('timestamp' => '1416929700', 'weight' => '3.27'),
    array('timestamp' => '1417006200', 'weight' => '3.18')
)
 
Weight values can be in g or kg. Timestamps in Unix timestamp format.
 
birth_time
Unix time stamp format
 
birth_weight
In g or kg
Note: Birth weight must be no less than 2000g (2kg) and no greater than 5000g (5kg) – though right now there’s nothing in place within the API preventing birth weight outside of that range.
 
birth_type
Possible values: vag or ces
 
feed_method
Possible values: ff or bf
Formula fed and breastfed, respectively
 
api_key
The one in use here is a test/development key. we’d want to establish a unique key for each entity accessing the API.
 
Attachments area

Wilmore, Sridevi (CDC/ONDIEH/NCCDPHP)
AttachmentsNov 22 (10 days ago)

to Andrew, Valerie, Mark, Paula, Jason, Madhulekha, jtvanwage, me, potatoyzy, justinkristens., Jennifer, Jamon, Arunkumar, Joan, Michelle, Tia 
Dear Team
 
See the additional attached NEWT instruction document provided by Dr. Valerie Flaherman (breastfeeding SME) and Andrew Robinson (her technology counterpart) out of UCSF.  They will be joining our upcoming calls in order to determine the feasibility of implementing your work via their current breastfeeding outcomes evaluation project.  Very exciting!
 
Regards,
Sri

[EMR link to NEWT InstructionsUpdated](./EMR link to NEWT InstructionsUpdated.pdf)
---
From: Wilmore, Sridevi (CDC/ONDIEH/NCCDPHP) 
Sent: Tuesday, November 21, 2017 1:52 PM
To: Arunmozhi, Madhulekha <madhulekha@gatech.edu>; jtvanwage@gmail.com; pabbyy@gmail.com; potatoyzy@gmail.com; justinkristensen7@gmail.com; Nelson, Jennifer M. (CDC/ONDIEH/NCCDPHP) <zcn6@cdc.gov>; 'Jamon Bowen' <jamon.bowen@gmail.com>; Srinivasan, Arunkumar (CDC/ONDIEH/NCCDPHP) <fos2@cdc.gov>; 'Meek, Joan' <Joan.Meek@med.fsu.edu>; Brenner, Michelle G <Michelle.Brenner@CHKD.ORG>; 'Pope, Tia M' <tiapope@gatech.edu>
Subject: Team We Didn't Start the FHIR Breastfeeding Technology

Attachments area

Jamon B
Nov 22 (10 days ago)

to Sridevi, Madhulekha, jtvanwage, me, potatoyzy, justinkristens., Jennifer, Arunkumar, Joan, Michelle, Tia, Andrew, Valerie, Mark, Paula, Jason 
Great, we will take a look at this.  Looks like we would embedded a link withe the parameters we have already collected.  I did have one other quick question.  Do you have access to and mac computers?  For the iPhone app it needs to run in an emulator as we aren't publishing it to the App store, on macs with OS X the emulator is just build in and it is easy to run.  If you don't have access to a Mac there are emulators for other OSes, but we haven't tested any as they are not typically Apple supported.

Thanks!
---