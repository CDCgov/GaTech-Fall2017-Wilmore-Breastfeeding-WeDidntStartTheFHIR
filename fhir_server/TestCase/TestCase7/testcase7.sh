#!/bin/sh
curl -X POST -d @/root/testcase/TestCase7/Patient_Test.json http://127.0.0.1:8080/baseDstu3/Patient -H "Content-Type: application/json"
curl -X POST -d @/root/testcase/TestCase7/RelatedPerson_Test.json http://127.0.0.1:8080/baseDstu3/RelatedPerson -H "Content-Type: application/json"
curl -X POST -d @/root/testcase/TestCase7/Patient_BabyTest.json http://127.0.0.1:8080/baseDstu3/Patient -H "Content-Type: application/json"
curl -X POST -d @/root/testcase/TestCase7/Observation_Weight_BabyTest.json http://127.0.0.1:8080/baseDstu3/Observation -H "Content-Type: application/json"
curl -X POST -d @/root/testcase/TestCase7/Observation_Weight_BabyTestDay3.json http://127.0.0.1:8080/baseDstu3/Observation -H "Content-Type: application/json"
curl -X POST -d @/root/testcase/TestCase7/Observation_Weight_BabyTestDay7.json http://127.0.0.1:8080/baseDstu3/Observation -H "Content-Type: application/json"
curl -X POST -d @/root/testcase/TestCase7/Observation_Weight_BabyTestDay14.json http://127.0.0.1:8080/baseDstu3/Observation -H "Content-Type: application/json"
curl -X POST -d @/root/testcase/TestCase7/QuestionnaireResponse_BF_Test_Day4.json http://127.0.0.1:8080/baseDstu3/QuestionnaireResponse -H "Content-Type: application/json"
curl -X POST -d @/root/testcase/TestCase7/QuestionnaireResponse_Test_Day4.json http://127.0.0.1:8080/baseDstu3/QuestionnaireResponse -H "Content-Type: application/json"
