addtestdata.ps1 is a powershell script I am using to load patient data. 
There is a need to run insert the json files, in the same order into a clean fhir server in the docker/linux environment.

There are 5 pairs of mothers and baby patients with different aspects that may flag a referral.

The Wellgoods: Older mother (> 40 yo). Vaginal birth. 
The Cesections: Cesearean Section
The Sweets: Mother has Diabetes II. Vacuum Extractor birth. 
The Glands: BMI >= 30. Mother has Hypothyroidism. Vaginal birth. 
The Cisticas: BMI >= 30.Mother has Polycistic Ovarian Cysts. Vaginal birth. 