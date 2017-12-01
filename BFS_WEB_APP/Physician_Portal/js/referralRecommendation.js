dashboard.referralRecommendation = dashboard.referralRecommendation || (function () {
    let reason = '';
    let weight_reason = '';
    let baby = {};

    function getAnswer(answerData) {
        if (answerData) {
            if (answerData.valueString) {
                return answerData.valueString;
            } else if (answerData.valueDate) {
                return answerData.valueDate;
            } else if ('valueBoolean' in answerData) {
                return answerData.valueBoolean;
            }
        }
    }

    function getAnswerForQuestion(responses, questionId) {
        let filtered = responses.filter(r => r.questionId === questionId);

        if (filtered.length && filtered[0].answer) {
            return filtered[0].answer;
        }

        return false;
    }

    function makeReccomendation(response) {
        let questionnaireResources = response.data.entry ? response.data.entry.map((e) => e.resource) : [];
        reason = '';
        weight_reason = '';

        for (let resource of questionnaireResources) {
            let authoredDate = new Date(resource.authored);
            let responses = resource.item.map(i => ({questionId: i.linkId, answer: getAnswer(i.answer[0])}));
            let diffDays = Math.ceil(Math.abs(authoredDate.getTime() - baby.DOB.getTime()) / (1000 * 3600 * 24));

            if (diffDays >= 4 && responses.some(r => r.questionId === 'hasMilkComeIn') && !getAnswerForQuestion(responses, 'hasMilkComeIn')) {
                reason += 'Born 4 days without breast feeding. ';
            } else if (diffDays >= 4 && responses.some(r => r.questionId === 'isStoolMustard') && !getAnswerForQuestion(responses, 'isStoolMustard')) {
                reason += 'Born 4 days without bowel transition. ';
            } else if ((responses.some(r => r.questionId === 'hasMilkComeIn') && getAnswerForQuestion(responses, 'hasMilkComeIn')
                    && responses.some(r => r.questionId === 'isStollMustard') && !getAnswerForQuestion(responses, 'isStoolMustard'))
                && diffDays >= 2) {
                reason += 'Started breast feeding more than two days without bowel transition. ';
            } else if (diffDays < 7 && responses.some(r => r.questionId === 'numberOfWetDiapers') && getAnswerForQuestion(responses, 'numberOfWetDiapers') < 6) {
                reason += 'Born within last 7 days with less than 6 wet diapers in average. ';
            } else if (diffDays < 7
                && ((responses.some(r => r.questionId === 'medianGap') && getAnswerForQuestion(responses, 'medianGap') > 5)
                    || (responses.some(r => r.questionId === 'medianGap')  && getAnswerForQuestion(responses, 'maximumGap') > 5))) {
                reason += 'Born within last 7 days with either median gap larger than 3 hours or maximum gap larger than 5 hours. '
            } else if (responses.some(r => r.questionId === 'concerns') || responses.some(r => r.linkId === 'concerns')) {
                let concern = responses.filter(r => r.questionId === 'concerns');

                if (!concern.length) {
                    concern = responses.filter(r => r.linkId === 'concerns');
                }

                let concernText = concern[0].answer.valueString || concern[0].answer;

                reason += 'Patient submitted concern: ' + concernText + '. ';
            }
        }

        if (baby.weights[baby.weights.length - 1].time < 240 && baby.weights[baby.weights.length - 1].value < (0.95 * baby.weights[0].value)) {
            weight_reason += 'Born within last 10 days but weight dropped below 91% of birth weight. ';
        } else if (baby.weights[baby.weights.length - 1].time >= 240 && baby.weights[baby.weights.length - 1].time <= 336 && baby.weights[baby.weights.length - 1].value < (0.95 * baby.weights[0].value)) {
            weight_reason += 'Born between last 10 and 14 days but weight dropped below 95% of birth weight. ';
        } else if (baby.weights[baby.weights.length - 1].time >= 336 && baby.weights[baby.weights.length - 1].value < baby.weights[0]) {
            weight_reason += 'Born more than 14 days but weight dropped below birth weight. ';
        }

        if (reason === '' && weight_reason) {
            reason = 'RECOMMENDED! ' + weight_reason;
        } else if (reason !== '' && weight_reason) {
            reason = 'RECOMMENDED! ' + reason + '<br/>' + weight_reason;
        } else if (reason !== '' && !weight_reason) {
            reason = 'RECOMMENDED! ' + reason;
        } else if (reason === '' && weight_reason === '') {
            reason = 'Available if Needed';
        }

        let $referralRecommended = $('#referral-recommended');

        $referralRecommended.text(reason);

        if (reason !== 'Available if Needed') {
            $referralRecommended.addClass('recommend-referral');
        } else {
            $referralRecommended.removeClass('recommend-referral');
        }

        if (!questionnaireResources.length && !weight_reason) {
            $referralRecommended.text('Available if Needed.');
            $referralRecommended.removeClass('recommend-referral');
        }
    }

    return function (babyInfo, momPatient) {
        baby = babyInfo;

        //read data from FHIR
        const demo = {
            serviceUrl: smartUrl
        };

        let smartClient = FHIR.client(demo);

        //referral logic
        smartClient.api.search({
            type: 'QuestionnaireResponse',
            query: {author: momPatient.id}
        }).then(makeReccomendation);
    };
})();