dashboard.motherRiskFactors = (function () {
    const demo = {
        serviceUrl: smartUrl
    };

    function getProcedure(claim) {
        return claim.resource.procedure;
    }

    function getDiagnosis(claim) {
        return claim.resource.diagnosis;
    }

    function getAndDisplay(patientId) {
        let smartClient = FHIR.client(demo);

        smartClient.api.search({ type: 'Claim', query: { patient: patientId } }).then((claims) => {
            claims.data.entry && claims.data.entry.forEach((c) => {
                let procedure = getProcedure(c);

                if (procedure) {
                    for (let p of procedure) {
                        let code = p.procedureCodeableConcept.coding[0].code;

                        if (code === 'O80.0') {
                            $('#mother-mode-of-delivery').text('Vaginal Delivery');
                        }

                        if (code === 'O82.0') {
                            $('#mother-mode-of-delivery').text('Delivery by elective Caesarean section');
                        }

                        if (code.startsWith('C50.')) {
                            $('#mother-breast-surgery').text('Positive');
                        }
                    }
                }

                let diagnosis = getDiagnosis(c);

                if (diagnosis) {
                    for (let d of diagnosis) {
                        let code = d.diagnosisCodeableConcept.coding[0].code;

                        if (code === 'E28.2') {
                            $('#mother-polycystic').text('Positive');
                        }

                        if (code.startsWith('E10.') || code.startsWith('E11.') || code.startsWith('E13.')) {
                            $('#mother-diabetes').text('Positive');
                        }

                        if (code === 'E05.90') {
                            $('#mother-hyperthyroid').text('Positive');
                        }

                        if (code === 'E03.9') {
                            $('#mother-hypothyroid').text('Positive');
                        }

                        if (code === 'O92.79') {
                            $('#mother-glandular').text('Positive');
                        }

                        if (code.startsWith('C50.')) {
                            $('#mother-breast-surgery').text('Positive');
                        }
                    }
                }
            });
        });

        smartClient.api.search({ type: 'Observation', query: { patient: patientId } }).then((observations) => {
            observations.data.entry && observations.data.entry.forEach((o) => {
                if (o.resource.code.coding[0].code === '39156-5') {
                    $('#mother-bmi').text(o.resource.valueQuantity.value + ' ' + o.resource.valueQuantity.unit);
                }
            })
        });
    }

    return {
        getAndDisplay: getAndDisplay
    };
})();