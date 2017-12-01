var smartUrl = 'http://localhost:8080/baseDstu3';
var dashboard = dashboard || (function () {
    'use strict';

    let dashboardObj = {};

    dashboardObj.wireGeneralEvents = function () {
        let toggleQuestionnaire = function () {
            $('#referral-recommendation-container').toggleClass('hidden');
            $('#questionnaire-container').toggleClass('hidden');
        };

        let toggleInitiateReferralButton = function (event) {
            $('#initiate-referral').prop('disabled', !event.target.checked);
        };

        $('#initiate-referral').on('click', toggleQuestionnaire);
        $('#cancel').on('click', toggleQuestionnaire);
        $('#patient-authorization').on('click', toggleInitiateReferralButton);
    };

    dashboardObj.init = function () {
        dashboardObj.wireGeneralEvents();
    };

    return dashboardObj;
})();