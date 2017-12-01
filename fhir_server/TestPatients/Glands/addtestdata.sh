#!/bin/sh
curl -X POST -d @/root/TestPatients/Glands/Patient_Glands.json http://127.0.0.1:8080/baseDstu3/Patient -H "Content-Type: application/json"
curl -X POST -d @/root/TestPatients/Glands/RelatedPerson_Glands.json http://127.0.0.1:8080/baseDstu3/RelatedPerson -H "Content-Type: application/json"
curl -X POST -d @/root/TestPatients/Glands/Patient_BabyGlands.json http://127.0.0.1:8080/baseDstu3/Patient -H "Content-Type: application/json"
curl -X POST -d @/root/TestPatients/Glands/Observation_Weight_BabyGlands.json http://127.0.0.1:8080/baseDstu3/Observation -H "Content-Type: application/json"
curl -X POST -d @/root/TestPatients/Glands/Observation_BMI_Glands.json http://127.0.0.1:8080/baseDstu3/Observation -H "Content-Type: application/json"
curl -X POST -d @/root/TestPatients/Glands/Claim_Birth_Glands.json http://127.0.0.1:8080/baseDstu3/Claim -H "Content-Type: application/json"
curl -X POST -d @/root/TestPatients/Glands/Claim_Delivery_Glands.json http://127.0.0.1:8080/baseDstu3/Claim -H "Content-Type: application/json"
curl -X POST -d @/root/TestPatients/Glands/Claim_Risk_Glands.json http://127.0.0.1:8080/baseDstu3/Claim -H "Content-Type: application/json"

