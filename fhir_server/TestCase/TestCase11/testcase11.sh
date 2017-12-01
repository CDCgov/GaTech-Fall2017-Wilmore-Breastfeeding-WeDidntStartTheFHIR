#!/bin/sh
curl -X POST -d @/root/testcase/TestCase11/Patient_Test.json http://127.0.0.1:8080/baseDstu3/Patient -H "Content-Type: application/json"
curl -X POST -d @/root/testcase/TestCase11/RelatedPerson_Test.json http://127.0.0.1:8080/baseDstu3/RelatedPerson -H "Content-Type: application/json"
curl -X POST -d @/root/testcase/TestCase11/Patient_BabyTest.json http://127.0.0.1:8080/baseDstu3/Patient -H "Content-Type: application/json"
curl -X POST -d @/root/testcase/TestCase11/Observation_Weight_BabyTest.json http://127.0.0.1:8080/baseDstu3/Observation -H "Content-Type: application/json"
curl -X POST -d @/root/testcase/TestCase11/QuestionnaireResponse_BF_Test_Day5.json http://127.0.0.1:8080/baseDstu3/QuestionnaireResponse -H "Content-Type: application/json"
curl -X POST -d @/root/testcase/TestCase11/QuestionnaireResponse_Test_Day4.json http://127.0.0.1:8080/baseDstu3/QuestionnaireResponse -H "Content-Type: application/json"
