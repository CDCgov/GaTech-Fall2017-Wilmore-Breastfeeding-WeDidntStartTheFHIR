#!/bin/sh
curl -X PUT -d @/root/testcase/TestCase2/Patient_Sweets.json "http://127.0.0.1:8080/baseDstu3/Patient?family=Sweets&given=Ling" -H "Content-Type: application/json"
