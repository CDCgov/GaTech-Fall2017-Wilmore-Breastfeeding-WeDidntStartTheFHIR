dashboard.questionnaire = dashboard.questionnaire || (function () {
    const demo = {
        serviceUrl: smartUrl
    };

    let smartClient = FHIR.client(demo);
    let $questionnaireForm = $('#questionnaire');

    let objectifyForm = function (formArray) {
        let returnObj = {};

        for (let i = 0; i < formArray.length; ++i){
            returnObj[formArray[i]['name']] = formArray[i]['value'];
        }

        return returnObj;
    };

    let submitQuestionnaire = function (event) {
        event.preventDefault();
        let data = objectifyForm($questionnaireForm.find(':input').serializeArray());

        let questionnaireResponse = {
            resourceType: 'QuestionnaireResponse',
            author: {
                reference: 'Patient/' + data['patient-id']
            },
            source: {
                reference: 'Patient/' + data['patient-id']
            },
            identifier: 'questionnaire',
            item: [{
                linkId: 'questionnaireType',
                text: 'QuestionnaireType',
                answer: [{
                    valueString: 'Patient questionnaire responses'
                }]
            }, {
                linkId: 'breastfeedingGoingWell',
                text: 'Do you feel breastfeeding is going well so far?',
                answer: [{
                    valueBoolean: data['going-well'] === 'yes'
                }]
            }, {
                linkId: 'concerned',
                text: 'Do you have any concerns?',
                answer: {
                    valueBoolean: data['concerned'] === 'yes'
                }
            }, {
                linkId: 'concerns',
                text: 'What concerns do you have about breastfeeding?',
                answer: {
                    valueString: data['concerns-explanation']
                }
            }, {
                linkId: 'hasMilkComeIn',
                text: 'Has your milk come in? (Between the 2nd and 4th day postpartum, did your breast get firm?)',
                answer: [{
                    valueBoolean: data['milk-come-in'] === 'yes'
                }]
            }, {
                linkId: 'nurseRegularly',
                text: 'Does your baby nurse approximately every two to three hours with no more than one longer interval at night (up to 5 hours)?',
                answer: [{
                    valueBoolean: data['nurse-regularly'] === 'yes'
                }]
            }, {
                linkId: 'isStoolMustard',
                text: 'Is your baby having bowel movements that look like yellow, seedy mustard?',
                answer: [{
                    valueBoolean: data['baby-bowel-movements'] === 'yes'
                }]
            }, {
                linkId: 'wetDiapers',
                text: 'Is your baby having at least 6 wet diapers a day?',
                answer: [{
                    valueBoolean: data['baby-wet-diapers'] === 'yes'
                }]
            }, {
                linkId: 'otherLiquids',
                text: 'Is your baby being fed any infant formula, water, or other liquids?',
                answer: [{
                    valueBoolean: data['baby-other-liquids'] === 'yes'
                }]
            }]
        };

        smartClient.api.create({resource: questionnaireResponse}).done(function (r) {
            $('#questionnaire-reset').trigger('click');
            window.alert('Questionnaire submitted successfully!');
        }).fail(function (e) {
            console.log(e);
        });
    };

    let init = function () {
        $questionnaireForm.off().on('submit', submitQuestionnaire);
    };

    let getMotherResponses = function (response) {
        return response.resource.item.filter(r => r.linkId !== 'questionnaireType');
    };

    let getPatientResponses = function (patientId) {
        const fhir = {
            serviceUrl: smartUrl,
            patient: patientId
        };

        let smartClient = FHIR.client(fhir);

        smartClient.api.search({ type: 'QuestionnaireResponse', query: {author: patientId} }).then((responses) => {
            responses.data.entry && responses.data.entry.forEach((response) => {
                let momResponses = getMotherResponses(response);

                momResponses.forEach((mr) => {
                    if (mr.linkId === 'medianGap') {
                        let gap = +mr.answer[0].valueString.split(' ')[0];
                        let goodGap = gap >= 2 && gap <= 3;

                        $('[name="nurse-regularly"][value="yes"]').prop('checked', goodGap);
                        $('[name="nurse-regularly"][value="no"]').prop('checked', !goodGap);
                    } else if (mr.linkId === 'maximumGap') {
                        let gap = ((+mr.answer[0].valueString.split(' ')[0]) <= 5);

                        $('[name="nurse-regularly"][value="yes"]').prop('checked', gap);
                        $('[name="nurse-regularly"][value="no"]').prop('checked', !gap);
                    } else if (mr.linkId === 'numberOfWetDiapers') {
                        let diapers = ((+mr.answer[0].valueString) >= 6);

                        $('[name="baby-wet-diapers"][value="yes"]').prop('checked', diapers);
                        $('[name="baby-wet-diapers"][value="no"]').prop('checked', !diapers);
                    } else if (mr.linkId === 'hasMilkComeIn') {
                        let comeIn = mr.answer[0].valueBoolean;

                        $('[name="milk-come-in"][value="yes"]').prop('checked', comeIn);
                        $('[name="milk-come-in"][value="no"]').prop('checked', !comeIn);
                    } else if (mr.linkId === 'isStoolMustard') {
                        let stoolGood = mr.answer[0].valueBoolean;

                        $('[name="milk-come-in"][value="yes"]').prop('checked', stoolGood);
                        $('[name="milk-come-in"][value="no"]').prop('checked', !stoolGood);
                    } else if (mr.linkId === 'concerns') {
                        let concern = mr.answer[0].valueString.trim();

                        $('[name="concerned"][value="yes"]').prop('checked', concern);
                        $('[name="concerned"][value="no"]').prop('checked', !concern);

                        $('#concerns-explanation').val(concern);
                    }
                });
            });
        });
    };

    return {
        init: init,
        getPatientResponses: getPatientResponses
    };
})();