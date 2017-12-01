/////////////////////////////////////////////////////////////////////////
// Global variables
let patient,
    hcs = 'HealthcareService/',
    patientprefix = 'Patient/',
    patientCountry, patientState, patientDistrict, hasPatientLocation;

// dashboard.patient = dashboard.patient || (function () {
//     let patientObj = {};
//
//     const demo = {
//         //serviceUrl: 'https://fhir-open-api-dstu2.smarthealthit.org',
// //                serviceUrl: 'https://secure-api.hspconsortium.org/FHIRPit/open'
//         serviceUrl: smartUrl,
//         patientId: '1'
//     };
//
//     // Perform referral function
//     patientObj.performReferral = function (id) {
//         let resource = {
//             resourceType: 'ReferralRequest',
//             status: 'requested',
//             patient: {
//                 'reference': patientprefix + patient.id
//             },
//             supportingInformation: {
//                 reference: hcs + id
//             }
//         };
//
//         // Create the ReferralRequest
//         patient.api.create({resource: resource}).done(function (r) {
//             location.reload(true);
//         });
//     };
//
//     patientObj.init = function () {
//         let smartClient = FHIR.client(demo);
//         smartClient.patient.read().then(function (patient) {
//             let formattedName = patient.name ? patient.name[0].given[0] + ' ' + patient.name[0].family : '',
//                 gender = patient.gender ? patient.gender : '',
//                 DOB = patient.birthDate ? patient.birthDate : '',
//                 mp = patient.telecom ? patient.telecom[0].value : '',
//                 email = patient.telecom ? patient.telecom[1].value : '';
//
//             $('#patientName').text(formattedName);
//             $('#Gender').text(gender);
//             $('#DOB').text(DOB);
//             $('#mobile').text(mp);
//             $('#Email').text(email);
//
//             // Get home address
//             for (let i = 0; i < patient.address.length; i++) {
//                 if (patient.address[i].use === 'home') {
//                     patientCountry = patient.address[i].country;
//                     patientState = patient.address[i].state;
//                     patientDistrict = patient.address[i].district;
//
//                     if (patientCountry && patientState && patientDistrict) {
//                         hasPatientLocation = true;
//                     }
//
//                     break;
//                 }
//             }
//         });
//     };
//
//     return patientObj;
// })();


