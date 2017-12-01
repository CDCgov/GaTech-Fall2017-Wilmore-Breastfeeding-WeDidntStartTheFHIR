dashboard.router = dashboard.router || (function () {
    let resetQuestionnaire = function () {
        $('#questionnaire-reset').trigger('click');
        $('#questionnaire-container').addClass('hidden');
        $('#referral-recommendation-container').removeClass('hidden');
        $('#patient-authorization').prop('checked', false);
        $('#initiate-referral').prop('disabled', true);
    };

    let resetMotherRiskFactors = function () {
        $('#mother-age').text('...');
        $('#mother-bmi').text('...');
        $('#mother-diabetes').text('negative');
        $('#mother-polycystic').text('negative');
        $('#mother-hyperthyroid').text('negative');
        $('#mother-hypothyroid').text('negative');
        $('#mother-mode-of-delivery').text('...');
        $('#mother-glandular').text('negative');
        $('#mother-breast-surgery').text('negative');
    };

    let handleHashChange = function () {
        let hash = window.location.hash.replace('#', '');

        if (!hash) {
            $('.current').removeClass('current');
        }

        let hashParts = hash.split('/');

        if (hashParts[0] === 'patient') {
            dashboard.patient(hashParts[1]).render();
        }

        resetQuestionnaire();
        resetMotherRiskFactors();
    };

    let init = function () {
        $(window).on('hashchange', handleHashChange);
        handleHashChange();
    };

    return {
        init: init
    };
})();