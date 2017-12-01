$command = @'
C:\curl\curl.exe -X POST --data-binary "@./Wellgood/Patient_Wellgood.json" http://127.0.0.1:8080/baseDstu3/Patient -H "Content-Type: application/json"
'@
Invoke-Expression -Command:$command
$command = @'
C:\curl\curl.exe -X POST --data-binary "@./Wellgood/RelatedPerson_Wellgood.json" http://127.0.0.1:8080/baseDstu3/RelatedPerson -H "Content-Type: application/json"
'@
Invoke-Expression -Command:$command
$command = @'
C:\curl\curl.exe -X POST --data-binary "@./Wellgood/Patient_BabyWellgood.json" http://127.0.0.1:8080/baseDstu3/Patient -H "Content-Type: application/json"
'@
Invoke-Expression -Command:$command
$command = @'
C:\curl\curl.exe -X POST --data-binary "@./Wellgood/Observation_Weight_BabyWellgood.json" http://127.0.0.1:8080/baseDstu3/Observation -H "Content-Type: application/json"
'@
Invoke-Expression -Command:$command
$command = @'
C:\curl\curl.exe -X POST --data-binary "@./Wellgood/Observation_BMI_Wellgood.json" http://127.0.0.1:8080/baseDstu3/Observation -H "Content-Type: application/json"
'@
Invoke-Expression -Command:$command
$command = @'
C:\curl\curl.exe -X POST --data-binary "@./Wellgood/Claim_Birth_Wellgood.json" http://127.0.0.1:8080/baseDstu3/Claim -H "Content-Type: application/json"
'@
Invoke-Expression -Command:$command
$command = @'
C:\curl\curl.exe -X POST --data-binary "@./Wellgood/Claim_Delivery_Wellgood.json" http://127.0.0.1:8080/baseDstu3/Claim -H "Content-Type: application/json"
'@
Invoke-Expression -Command:$command
