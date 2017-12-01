
$command = @'
C:\curl\curl.exe -X POST --data-binary "@./Cesection/Patient_Cesection.json" http://127.0.0.1:8080/baseDstu3/Patient -H "Content-Type: application/json"
'@
Invoke-Expression -Command:$command
$command = @'
C:\curl\curl.exe -X POST --data-binary "@./Cesection/RelatedPerson_Cesection.json" http://127.0.0.1:8080/baseDstu3/RelatedPerson -H "Content-Type: application/json"
'@
Invoke-Expression -Command:$command
$command = @'
C:\curl\curl.exe -X POST --data-binary "@./Cesection/Patient_BabyCesection.json" http://127.0.0.1:8080/baseDstu3/Patient -H "Content-Type: application/json"
'@
Invoke-Expression -Command:$command
$command = @'
C:\curl\curl.exe -X POST --data-binary "@./Cesection/Observation_Weight_BabyCesection.json" http://127.0.0.1:8080/baseDstu3/Observation -H "Content-Type: application/json"
'@
Invoke-Expression -Command:$command
$command = @'
C:\curl\curl.exe -X POST --data-binary "@./Cesection/Observation_BMI_Cesection.json" http://127.0.0.1:8080/baseDstu3/Observation -H "Content-Type: application/json"
'@
Invoke-Expression -Command:$command
$command = @'
C:\curl\curl.exe -X POST --data-binary "@./Cesection/Claim_Birth_Cesection.json" http://127.0.0.1:8080/baseDstu3/Claim -H "Content-Type: application/json"
'@
Invoke-Expression -Command:$command
$command = @'
C:\curl\curl.exe -X POST --data-binary "@./Cesection/Claim_Delivery_Cesection.json" http://127.0.0.1:8080/baseDstu3/Claim -H "Content-Type: application/json"
'@
Invoke-Expression -Command:$command