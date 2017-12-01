# Repository Template
This Github organization was created for use by [CDC](http://www.cdc.gov)
programs to collaborate on public health surveillance related projects in
support of the [CDC Surveillance Strategy](http://www.cdc.gov/surveillance).
This third party web application is not hosted by the CDC, but is used by CDC
and its partners to share information and collaborate on software.

This repository serves as a template for other repositories to follow in order
to provide the appropriate notices for users in regards to privacy protection,
contribution, licensing, copyright, records management and collaboration.

## Public Domain
This project constitutes a work of the United States Government and is not
subject to domestic copyright protection under 17 USC § 105. This project is in
the public domain within the United States, and copyright and related rights in
the work worldwide are waived through the [CC0 1.0 Universal public domain dedication](https://creativecommons.org/publicdomain/zero/1.0/).
All contributions to this project will be released under the CC0 dedication. By
submitting a pull request you are agreeing to comply with this waiver of
copyright interest.

## License
The project utilizes code licensed under the terms of the Apache Software
License and therefore is licensed under ASL v2 or later.

This program is free software: you can redistribute it and/or modify it under
the terms of the Apache Software License version 2, or (at your option) any
later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the Apache Software License for more details.

You should have received a copy of the Apache Software License along with this
program. If not, see http://www.apache.org/licenses/LICENSE-2.0.html

## Privacy
This project contains only non-sensitive, publicly available data and
information. All material and community participation is covered by the
Surveillance Platform [Disclaimer](https://github.com/CDCgov/template/blob/master/DISCLAIMER.md)
and [Code of Conduct](https://github.com/CDCgov/template/blob/master/code-of-conduct.md).
For more information about CDC's privacy policy, please visit [http://www.cdc.gov/privacy.html](http://www.cdc.gov/privacy.html).

## Contributing
Anyone is encouraged to contribute to the project by [forking](https://help.github.com/articles/fork-a-repo)
and submitting a pull request. (If you are new to GitHub, you might start with a
[basic tutorial](https://help.github.com/articles/set-up-git).) By contributing
to this project, you grant a world-wide, royalty-free, perpetual, irrevocable,
non-exclusive, transferable license to all users under the terms of the
[Apache Software License v2](http://www.apache.org/licenses/LICENSE-2.0.html) or
later.

All comments, messages, pull requests, and other submissions received through
CDC including this GitHub page are subject to the [Presidential Records Act](http://www.archives.gov/about/laws/presidential-records.html)
and may be archived. Learn more at [http://www.cdc.gov/other/privacy.html](http://www.cdc.gov/other/privacy.html).

## Records
This project is not a source of government records, but is a copy to increase
collaboration and collaborative potential. All government records will be
published through the [CDC web site](http://www.cdc.gov).

## Notices
Please refer to [CDC's Template Repository](https://github.com/CDCgov/template)
for more information about [contributing to this repository](https://github.com/CDCgov/template/blob/master/CONTRIBUTING.md),
[public domain notices and disclaimers](https://github.com/CDCgov/template/blob/master/DISCLAIMER.md),
and [code of conduct](https://github.com/CDCgov/template/blob/master/code-of-conduct.md).

## Hat-tips
Thanks to [18F](https://18f.gsa.gov/)'s [open source policy](https://github.com/18F/open-source-policy)
and [code of conduct](https://github.com/CDCgov/code-of-conduct/blob/master/code-of-conduct.md)
that were very useful in setting up this GitHub organization. Thanks to CDC's
[Informatics Innovation Unit](https://www.phiresearchlab.org/index.php/code-of-conduct/)
that was helpful in modeling the code of conduct.

---

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
