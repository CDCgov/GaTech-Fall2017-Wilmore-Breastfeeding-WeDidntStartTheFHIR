$command = @'
C:\curl\curl.exe -X POST --data-binary "@./Glands/Patient_Glands.json" http://127.0.0.1:8080/baseDstu3/Patient -H "Content-Type: application/json"
'@
Invoke-Expression -Command:$command
$command = @'
C:\curl\curl.exe -X POST --data-binary "@./Glands/RelatedPerson_Glands.json" http://127.0.0.1:8080/baseDstu3/RelatedPerson -H "Content-Type: application/json"
'@
Invoke-Expression -Command:$command
$command = @'
C:\curl\curl.exe -X POST --data-binary "@./Glands/Patient_BabyGlands.json" http://127.0.0.1:8080/baseDstu3/Patient -H "Content-Type: application/json"
'@
Invoke-Expression -Command:$command
$command = @'
C:\curl\curl.exe -X POST --data-binary "@./Glands/Observation_Weight_BabyGlands.json" http://127.0.0.1:8080/baseDstu3/Observation -H "Content-Type: application/json"
'@
Invoke-Expression -Command:$command
$command = @'
C:\curl\curl.exe -X POST --data-binary "@./Glands/Observation_BMI_Glands.json" http://127.0.0.1:8080/baseDstu3/Observation -H "Content-Type: application/json"
'@
Invoke-Expression -Command:$command
$command = @'
C:\curl\curl.exe -X POST --data-binary "@./Glands/Claim_Birth_Glands.json" http://127.0.0.1:8080/baseDstu3/Claim -H "Content-Type: application/json"
'@
Invoke-Expression -Command:$command
$command = @'
C:\curl\curl.exe -X POST --data-binary "@./Glands/Claim_Delivery_Glands.json" http://127.0.0.1:8080/baseDstu3/Claim -H "Content-Type: application/json"
'@
Invoke-Expression -Command:$command
$command = @'
C:\curl\curl.exe -X POST --data-binary "@./Glands/Claim_Risk_Glands.json" http://127.0.0.1:8080/baseDstu3/Claim -H "Content-Type: application/json"
'@
Invoke-Expression -Command:$command