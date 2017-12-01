#!/bin/sh
curl -X POST -d @/root/TestPatients/Sweets/Patient_Sweets.json http://127.0.0.1:8080/baseDstu3/Patient -H "Content-Type: application/json"
curl -X POST -d @/root/TestPatients/Sweets/RelatedPerson_Sweets.json http://127.0.0.1:8080/baseDstu3/RelatedPerson -H "Content-Type: application/json"
curl -X POST -d @/root/TestPatients/Sweets/Patient_BabySweets.json http://127.0.0.1:8080/baseDstu3/Patient -H "Content-Type: application/json"
curl -X POST -d @/root/TestPatients/Sweets/Observation_Weight_BabySweets.json http://127.0.0.1:8080/baseDstu3/Observation -H "Content-Type: application/json"
curl -X POST -d @/root/TestPatients/Sweets/Observation_BMI_Sweets.json http://127.0.0.1:8080/baseDstu3/Observation -H "Content-Type: application/json"
curl -X POST -d @/root/TestPatients/Sweets/Claim_Birth_Sweets.json http://127.0.0.1:8080/baseDstu3/Claim -H "Content-Type: application/json"
curl -X POST -d @/root/TestPatients/Sweets/Claim_Delivery_Sweets.json http://127.0.0.1:8080/baseDstu3/Claim -H "Content-Type: application/json"
curl -X POST -d @/root/TestPatients/Sweets/Claim_Risk_Sweets.json http://127.0.0.1:8080/baseDstu3/Claim -H "Content-Type: application/json"
