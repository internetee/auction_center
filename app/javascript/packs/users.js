import IdentityCode from './identity_code';
import MobilePhone from './mobile_phone';

function resetMobileFields() {
    let mobilePhoneField = document.getElementById('user_mobile_phone');
    let button = document.getElementById('user_form_commit');

    button.disabled = false;
    mobilePhoneField.classList.remove('is-invalid');
}

function setMobilePhoneInvalid() {
    let mobilePhoneField = document.getElementById('user_mobile_phone');
    let button = document.getElementById('user_form_commit');

    button.disabled = true;
    mobilePhoneField.classList.add('is-invalid');
}

function resetIdentityCodeFields() {
    let identityCodeField = document.getElementById('user_identity_code');
    let button = document.getElementById('user_form_commit');

    button.disabled = false;
    identityCodeField.classList.remove('is-invalid');
}

function setIdentityCodeFieldInvalid() {
    let identityCodeField = document.getElementById('user_identity_code');
    let button = document.getElementById('user_form_commit');

    button.disabled = true;
    identityCodeField.classList.add('is-invalid');
}

document.addEventListener("DOMContentLoaded", function() {
    let mobilePhoneField = document.getElementById('user_mobile_phone');
    let identityCodeField = document.getElementById('user_identity_code');
    let countryCodeField = document.getElementById('user_country_code');

    let completeForm = document.getElementById('user_form');
    console.log(completeForm);

    debugger;

    mobilePhoneField.addEventListener('blur', function(event) {
        resetMobileFields();

        let validator = new MobilePhone(countryCodeField.value, mobilePhoneField.value);
        if (!validator.validate()) {
            setMobilePhoneInvalid();
        } else {
            mobilePhoneField.value = validator.format();
        }
    });

    identityCodeField.addEventListener('blur', function(event) {
        resetIdentityCodeFields();
        let validator = new IdentityCode(countryCodeField.value, identityCodeField.value);

        if (!validator.validate()) {
            setIdentityCodeFieldInvalid();
        }
    });

    countryCodeField.addEventListener('blur', function(event) {
        resetIdentityCodeFields();
        let validator = new IdentityCode(countryCodeField.value, identityCodeField.value);

        if (!validator.validate()) {
            setIdentityCodeFieldInvalid();
        }
    });
});
