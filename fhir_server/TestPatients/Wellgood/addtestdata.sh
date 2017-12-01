#!/bin/sh
curl -X POST -d @/root/TestPatients/Wellgood/Patient_Wellgood.json http://127.0.0.1:8080/baseDstu3/Patient -H "Content-Type: application/json"
curl -X POST -d @/root/TestPatients/Wellgood/RelatedPerson_Wellgood.json http://127.0.0.1:8080/baseDstu3/RelatedPerson -H "Content-Type: application/json"
curl -X POST -d @/root/TestPatients/Wellgood/Patient_BabyWellgood.json http://127.0.0.1:8080/baseDstu3/Patient -H "Content-Type: application/json"
curl -X POST -d @/root/TestPatients/Wellgood/Observation_Weight_BabyWellgood.json http://127.0.0.1:8080/baseDstu3/Observation -H "Content-Type: application/json"
curl -X POST -d @/root/TestPatients/Wellgood/Observation_BMI_Wellgood.json http://127.0.0.1:8080/baseDstu3/Observation -H "Content-Type: application/json"
curl -X POST -d @/root/TestPatients/Wellgood/Claim_Birth_Wellgood.json http://127.0.0.1:8080/baseDstu3/Claim -H "Content-Type: application/json"
curl -X POST -d @/root/TestPatients/Wellgood/Claim_Delivery_Wellgood.json http://127.0.0.1:8080/baseDstu3/Claim -H "Content-Type: application/json"
