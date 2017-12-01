// Global variables
var patient,
    pid,
    hcs = 'HealthcareService/',
    patientprefix = 'Patient/';

// Perform referral function
function performReferral(id) {
    var resource = {
        resourceType: 'ReferralRequest',
        status: 'requested',
        patient: {
            reference: patientprefix + patient.id
        },
        supportingInformation: {
            reference: hcs + id
        }
    };

    // Create the ReferralRequest
    patient.api.create({resource: resource}).done(function () {
        location.reload(true);
    });
}

FHIR.oauth2.ready(function (fClient) {
    patient = fClient.patient;
    var smartt = fClient,
        patientCountry = null,
        patientState = null,
        patientDistrict = null,
        hasPatientLocation = false;

    // Get patient details
    $.when(patient.read()).done(function (p) {
        // Get patient info
        pid = 'Patient/' + p.id;
        console.log(pid);

        var name = p.name[0],
            formattedName = name.given[0] + ' ' + name.family,
            gender = p.gender,
            DOB = p.birthDate,
            mp = p.telecom[1].value,
            email = p.telecom[2].value;

        $('#patientName').text(formattedName);
        $('#Gender').text(gender);
        $('#DOB').text(DOB);
        $('#mobile').text(mp);
        $('#Email').text(email);

        // Get home address
        for (var i = 0; i < p.address.length; i++) {
            if (p.address[i].use === 'home') {
                patientCountry = p.address[i].country;
                patientState = p.address[i].state;
                patientDistrict = p.address[i].district;

                if (patientCountry && patientState && patientDistrict) {
                    hasPatientLocation = true;
                }

                break;
            }
        }


        //get questionnaire !!!!!
        var demo = {
            //serviceUrl: 'https://fhir-open-api-dstu2.smarthealthit.org',
            serviceUrl: 'https://secure-api.hspconsortium.org/FHIRPit/open'
            //patientId: '1137192'
        };

        smartt = FHIR.client(demo);
        smartt.api.search({
            type: 'QuestionnaireResponse',
            query: {author: {$reference: 'Patient/' + pid}}
        }).done(function (q) {
            //q.data.entry[1].resource.group.question[0].text
            //q.data.entry[1].resource.group.question[0].answer[0].valueDate

            if (q.data.entry) {
                q.data.entry.forEach(function () {
                    for (var i = 0; i < q.data.entry[j].resource.group.question.length; i++) {
                        var questionrow = '<tr><td>' + q.data.entry[1].resource.group.question[0].text + '</td><td>' + q.data.entry[1].resource.group.question[0].answer[0].valueDate + '</td></tr>';
                        $('#questiontable').append(questionrow);
                    }
                });
            }
        });
    });


    // Populate referral status window
    var referralProgramIdCache = [];
    $.when(patient.api.search({type: 'ReferralRequest', query: {}, count: 50}))
        .done(function (referralSearchResults) {
            if (referralSearchResults.data.entry) {
                referralSearchResults.data.entry.forEach(function (referrals) {

                    // Search the supporting information to find the associated program ids
                    if (referrals.resource.supportingInformation) {
                        for (var i = 0; i < referrals.resource.supportingInformation.length; i++) {
                            if (referrals.resource.supportingInformation[i].reference.startsWith(hcs)) {
                                // Cache the program id
                                var programId = referrals.resource.supportingInformation[i].reference.substr(hcs.length);
                                referralProgramIdCache.push(programId);

                                // Query for the healthcare service by id
                                $.when(patient.api.search({
                                    type: 'HealthcareService',
                                    query: {_id: programId},
                                    count: 1
                                }))
                                    .done(function (hcsResults) {
                                        hcsResults.data.entry.forEach(function (associatedHcs) {
                                            // !! Display program referral status
                                            var referralRow = '<tr><td>' + associatedHcs.resource.programName + '</td><td><p>' +
                                                referrals.resource.status + '</td></tr>';
                                            $('#referralResults').append(referralRow);
                                        });
                                    });
                            }
                        }
                    }
                });
            }

            // Populate available program window
            $.when(patient.api.search({type: 'HealthcareService', query: {}, count: 50}))
                .done(function (programSearchResults) {
                    programSearchResults.data.entry.forEach(function (programs) {
                        // Filter out programs that have already been referred
                        var skip = false;

                        for (var i = 0; i < referralProgramIdCache.length; i++) {
                            if (referralProgramIdCache[i] === programs.resource.id) {
                                skip = true;
                                break;
                            }
                        }

                        // Scan program coverage areas
                        if (!skip && hasPatientLocation) {
                            if (programs.resource.coverageArea) {
                                for (var j = 0; j < programs.resource.coverageArea.length; j++) {
                                    $.when(patient.api.search({
                                        type: 'Location',
                                        query: {_id: programs.resource.coverageArea[j].reference},
                                        count: 1
                                    }))
                                        .done(function (locationResults) {
                                            locationResults.data.entry.forEach(function (coverageArea) {
                                                // Check if patient is in coverage area
                                                if (coverageArea.resource.address &&
                                                    coverageArea.resource.address.country === patientCountry &&
                                                    coverageArea.resource.address.state === patientState &&
                                                    coverageArea.resource.address.district === patientDistrict) {
                                                    // Display location matched program
                                                    var programRow = '<tr><td>' + programs.resource.programName + '</td><td><p><button type="button" class="btn btn-primary" onclick="performReferral(\'' + programs.resource.id + '\')">Refer</button></td></tr>';
                                                    $('#programTable').append(programRow);
                                                }
                                            });
                                        });
                                }
                            }
                        }
                    });
                });
        });
});
