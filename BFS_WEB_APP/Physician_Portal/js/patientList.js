(function () {
    const demo = {
        serviceUrl: smartUrl
    };

    let smartClient = FHIR.client(demo);
    smartClient.api.search({type: 'Patient', count: 500}).done(function (response) {
        let patients = response.data.entry
            .map((e) => e.resource)
            .filter((p) => (Date.now() - (new Date(p.birthDate))) > 31536000000);
        let $list = $('#patient-list');

        for (let p of patients) {
            let patient = p;
            let $a = $('<a>', {id: 'patient-' + patient.id, href: '#patient/' + patient.id});
            let $li = $('<li>');
            $a.text(patient.name ? patient.name[0].given[0] + ' ' + patient.name[0].family : '');
            $li.html($a);
            $list.append($li);
        }
    });
})();