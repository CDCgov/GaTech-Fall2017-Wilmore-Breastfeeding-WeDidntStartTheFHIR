dashboard.patient = dashboard.patient || function (id) {
    const demo = {
        serviceUrl: smartUrl,
        patientId: id
    };

    let patientInfo = {
        name: '',
        id: id,
        gender: '',
        DOB: '',
        phone: '',
        email: ''
    };

    let baby = {
        id: 0,
        name: '',
        DOB: '',
        weights: []
    };

    let babySmart = {
        serviceUrl: smartUrl,
        patientId: 0
    };

    let babyClient = null;

    let smartClient = FHIR.client(demo);

    let getPatientAge = function () {
        let today = new Date();
        let birthDate = new Date(patientInfo.DOB);
        let age = today.getFullYear() - birthDate.getFullYear();
        let m = today.getMonth() - birthDate.getMonth();

        if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
            age--;
        }

        return age;
    };

    let populateFieldsWithInfo = function () {
        $('#patient-id').val(patientInfo.id);
        $('#patientName').text(patientInfo.name);
        $('#Gender').text(patientInfo.gender);
        $('#DOB').text(patientInfo.DOB);
        $('#mobile').text(patientInfo.phone);
        $('#Email').text(patientInfo.email);

        $('#mother-age').text(getPatientAge());
    };

    smartClient.patient.read().then(function (patient) {
        patientInfo.name = patient.name ? patient.name[0].given[0] + ' ' + patient.name[0].family : '';
        patientInfo.gender = patient.gender ? patient.gender : '';
        patientInfo.DOB = patient.birthDate ? new Date(patient.birthDate) : '';
        patientInfo.phone = patient.telecom ? patient.telecom[0].value : '';
        patientInfo.email = patient.telecom ? patient.telecom[1].value : '';

        dashboard.motherRiskFactors.getAndDisplay(patientInfo.id);
        populateFieldsWithInfo();

        // Get home address
        if (patient.address) {
            for (let i = 0; i < patient.address.length; i++) {
                if (patient.address[i].use === 'home') {
                    patientCountry = patient.address[i].country;
                    patientState = patient.address[i].state;
                    patientDistrict = patient.address[i].district;

                    if (patientCountry && patientState && patientDistrict) {
                        hasPatientLocation = true;
                    }

                    break;
                }
            }
        }
    });

    let getBabyObservations = function (observations) {
        let weightResources = observations.data.entry
            .filter((o) => o.resource.code.text === 'Birth Weight' || o.resource.code.text === 'Body Weight')
            .map((w) => w.resource);

        let birthResource = weightResources.filter((o) => o.code.text === 'Birth Weight')[0];

        for (let weightResource of weightResources) {
            let weight = weightResource.valueQuantity.unit === 'kg' ? weightResource.valueQuantity.value * 1000 : weightResource.valueQuantity.value;
            let weightPercentile = ((birthResource.valueQuantity.value - weight) / birthResource.valueQuantity.value) * -100;

            if (weightPercentile === 100) {
                weightPercentile = 0;
            }

            baby.weights.push({
                value: weightPercentile,
                time: (new Date(weightResource.effectiveDateTime).getTime() - new Date(birthResource.effectiveDateTime).getTime()) / 36e5
            });
        }

        dashboard.chart(baby.weights);
        dashboard.referralRecommendation(baby, patientInfo);
    };

    let populateBabyData = function (babyData) {
        baby.name = babyData.name ? babyData.name[0].given[0] + ' ' + babyData.name[0].family : '';
        baby.DOB = babyData.birthDate ? new Date(babyData.birthDate) : '';

        $('#babyName').text(baby.name);
        $('#babyId').text(baby.id);

        babyClient.patient.api.search({type: 'Observation'}).then(getBabyObservations);
    };

    let getBabyData = function (babyData) {
        if (babyData && babyData.data && babyData.data.entry && babyData.data.entry.length === 1) {
            baby.id = babyData.data.entry[0].resource.id;
            babySmart.patientId = babyData.data.entry[0].resource.id;

            babyClient = FHIR.client(babySmart);
            babyClient.patient.read().then(populateBabyData);
        }
    };

    let getRelatedBabyInfo = function (relatedData) {
        if (relatedData && relatedData.data && relatedData.data.entry && relatedData.data.entry.length === 1) {
            smartClient.api.search({type: 'Patient', query: {link: relatedData.data.entry[0].resource.id}})
                .then(getBabyData);
        }
    };

    smartClient.patient.api.search({type: 'RelatedPerson'})
        .then(getRelatedBabyInfo)
        .fail((e) => console.log(e));

    let render = function () {
        populateFieldsWithInfo();
        $('.current').removeClass('current');
        $('#patient-overview-container').addClass('current');
        dashboard.questionnaire.getPatientResponses(patientInfo.id);
    };

    return {
        render: render
    };
};