#!/bin/sh
curl -X POST -d @/root/TestPatients/Cesection/Patient_Cesection.json http://127.0.0.1:8080/baseDstu3/Patient -H "Content-Type: application/json"
curl -X POST -d @/root/TestPatients/Cesection/RelatedPerson_Cesection.json http://127.0.0.1:8080/baseDstu3/RelatedPerson -H "Content-Type: application/json"
curl -X POST -d @/root/TestPatients/Cesection/Patient_BabyCesection.json http://127.0.0.1:8080/baseDstu3/Patient -H "Content-Type: application/json"
curl -X POST -d @/root/TestPatients/Cesection/Observation_Weight_BabyCesection.json http://127.0.0.1:8080/baseDstu3/Observation -H "Content-Type: application/json"
curl -X POST -d @/root/TestPatients/Cesection/Observation_BMI_Cesection.json http://127.0.0.1:8080/baseDstu3/Observation -H "Content-Type: application/json"
curl -X POST -d @/root/TestPatients/Cesection/Claim_Birth_Cesection.json http://127.0.0.1:8080/baseDstu3/Claim -H "Content-Type: application/json"
curl -X POST -d @/root/TestPatients/Cesection/Claim_Delivery_Cesection.json http://127.0.0.1:8080/baseDstu3/Claim -H "Content-Type: application/json"
