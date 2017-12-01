$command = @'
C:\curl\curl.exe -X POST --data-binary "@./Dixon/Patient_Dixon.json" http://127.0.0.1:8080/baseDstu3/Patient -H "Content-Type: application/json"
'@
Invoke-Expression -Command:$command
$command = @'
C:\curl\curl.exe -X POST --data-binary "@./Dixon/RelatedPerson_Dixon.json" http://127.0.0.1:8080/baseDstu3/RelatedPerson -H "Content-Type: application/json"
'@
Invoke-Expression -Command:$command
$command = @'
C:\curl\curl.exe -X POST --data-binary "@./Dixon/Patient_BabyDixon.json" http://127.0.0.1:8080/baseDstu3/Patient -H "Content-Type: application/json"
'@
Invoke-Expression -Command:$command
$command = @'
C:\curl\curl.exe -X POST --data-binary "@./Dixon/Observation_Weight_BabyDixon.json" http://127.0.0.1:8080/baseDstu3/Observation -H "Content-Type: application/json"
'@
Invoke-Expression -Command:$command
$command = @'
C:\curl\curl.exe -X POST --data-binary "@./Dixon/Observation_Weight_BabyDixon_Day3.json" http://127.0.0.1:8080/baseDstu3/Observation -H "Content-Type: application/json"
'@
Invoke-Expression -Command:$command
$command = @'
C:\curl\curl.exe -X POST --data-binary "@./Dixon/Observation_Weight_BabyDixon_Day5.json" http://127.0.0.1:8080/baseDstu3/Observation -H "Content-Type: application/json"
'@
Invoke-Expression -Command:$command
$command = @'
C:\curl\curl.exe -X POST --data-binary "@./Dixon/QuestionnaireResponse_BF_Dixon_Day4.json" http://127.0.0.1:8080/baseDstu3/QuestionnaireResponse -H "Content-Type: application/json"
'@
Invoke-Expression -Command:$command
$command = @'
C:\curl\curl.exe -X POST --data-binary "@./Dixon/QuestionnaireResponse_BF_Dixon_Day5.json" http://127.0.0.1:8080/baseDstu3/QuestionnaireResponse -H "Content-Type: application/json"
'@
Invoke-Expression -Command:$command
$command = @'
C:\curl\curl.exe -X POST --data-binary "@./Dixon/QuestionnaireResponse_Dixon_Day4.json" http://127.0.0.1:8080/baseDstu3/QuestionnaireResponse -H "Content-Type: application/json"
'@
Invoke-Expression -Command:$command
$command = @'
C:\curl\curl.exe -X POST --data-binary "@./Dixon/QuestionnaireResponse_Dixon_Day5.json" http://127.0.0.1:8080/baseDstu3/QuestionnaireResponse -H "Content-Type: application/json"
'@
Invoke-Expression -Command:$command
