$command = @'
C:\curl\curl.exe -X POST --data-binary "@./Sweets/Patient_Sweets.json" http://127.0.0.1:8080/baseDstu3/Patient -H "Content-Type: application/json"
'@
Invoke-Expression -Command:$command
$command = @'
C:\curl\curl.exe -X POST --data-binary "@./Sweets/RelatedPerson_Sweets.json" http://127.0.0.1:8080/baseDstu3/RelatedPerson -H "Content-Type: application/json"
'@
Invoke-Expression -Command:$command
$command = @'
C:\curl\curl.exe -X POST --data-binary "@./Sweets/Patient_BabySweets.json" http://127.0.0.1:8080/baseDstu3/Patient -H "Content-Type: application/json"
'@
Invoke-Expression -Command:$command
$command = @'
C:\curl\curl.exe -X POST --data-binary "@./Sweets/Observation_Weight_BabySweets.json" http://127.0.0.1:8080/baseDstu3/Observation -H "Content-Type: application/json"
'@
Invoke-Expression -Command:$command
$command = @'
C:\curl\curl.exe -X POST --data-binary "@./Sweets/Observation_BMI_Sweets.json" http://127.0.0.1:8080/baseDstu3/Observation -H "Content-Type: application/json"
'@
Invoke-Expression -Command:$command
$command = @'
C:\curl\curl.exe -X POST --data-binary "@./Sweets/Claim_Birth_Sweets.json" http://127.0.0.1:8080/baseDstu3/Claim -H "Content-Type: application/json"
'@
Invoke-Expression -Command:$command
$command = @'
C:\curl\curl.exe -X POST --data-binary "@./Sweets/Claim_Delivery_Sweets.json" http://127.0.0.1:8080/baseDstu3/Claim -H "Content-Type: application/json"
'@
Invoke-Expression -Command:$command
$command = @'
C:\curl\curl.exe -X POST --data-binary "@./Sweets/Claim_Risk_Sweets.json" http://127.0.0.1:8080/baseDstu3/Claim -H "Content-Type: application/json"
'@
Invoke-Expression -Command:$command