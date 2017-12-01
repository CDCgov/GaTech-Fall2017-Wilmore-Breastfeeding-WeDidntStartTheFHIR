#!/bin/sh
curl -X POST -d @/root/testcase/TestCase9/Patient_Test.json http://127.0.0.1:8080/baseDstu3/Patient -H "Content-Type: application/json"
curl -X POST -d @/root/testcase/TestCase9/RelatedPerson_Test.json http://127.0.0.1:8080/baseDstu3/RelatedPerson -H "Content-Type: application/json"
curl -X POST -d @/root/testcase/TestCase9/Patient_BabyTest.json http://127.0.0.1:8080/baseDstu3/Patient -H "Content-Type: application/json"
curl -X POST -d @/root/testcase/TestCase9/Observation_Weight_BabyTest.json http://127.0.0.1:8080/baseDstu3/Observation -H "Content-Type: application/json"
curl -X POST -d @/root/testcase/TestCase9/Observation_BMI_Test.json http://127.0.0.1:8080/baseDstu3/Observation -H "Content-Type: application/json"
curl -X POST -d @/root/testcase/TestCase9/Claim_Birth_Test.json http://127.0.0.1:8080/baseDstu3/Claim -H "Content-Type: application/json"
curl -X POST -d @/root/testcase/TestCase9/Claim_Delivery_Test.json http://127.0.0.1:8080/baseDstu3/Claim -H "Content-Type: application/json"
curl -X POST -d @/root/testcase/TestCase9/QuestionnaireResponse_Concern.json http://127.0.0.1:8080/baseDstu3/QuestionnaireResponse -H "Content-Type: application/json"