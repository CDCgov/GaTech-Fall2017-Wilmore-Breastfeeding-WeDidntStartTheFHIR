#!/bin/sh
curl -X POST -d @/root/TestPatients/Cistica/Patient_Cistica.json http://127.0.0.1:8080/baseDstu3/Patient -H "Content-Type: application/json"
curl -X POST -d @/root/TestPatients/Cistica/RelatedPerson_Cistica.json http://127.0.0.1:8080/baseDstu3/RelatedPerson -H "Content-Type: application/json"
curl -X POST -d @/root/TestPatients/Cistica/Patient_BabyCistica.json http://127.0.0.1:8080/baseDstu3/Patient -H "Content-Type: application/json"
curl -X POST -d @/root/TestPatients/Cistica/Observation_Weight_BabyCistica.json http://127.0.0.1:8080/baseDstu3/Observation -H "Content-Type: application/json"
curl -X POST -d @/root/TestPatients/Cistica/Observation_BMI_Cistica.json http://127.0.0.1:8080/baseDstu3/Observation -H "Content-Type: application/json"
curl -X POST -d @/root/TestPatients/Cistica/Claim_Birth_Cistica.json http://127.0.0.1:8080/baseDstu3/Claim -H "Content-Type: application/json"
curl -X POST -d @/root/TestPatients/Cistica/Claim_Delivery_Cistica.json http://127.0.0.1:8080/baseDstu3/Claim -H "Content-Type: application/json"
curl -X POST -d @/root/TestPatients/Cistica/Claim_Risk_Cistica.json http://127.0.0.1:8080/baseDstu3/Claim -H "Content-Type: application/json"
