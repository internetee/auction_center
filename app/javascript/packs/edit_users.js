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

document.addEventListener("DOMContentLoaded", function() {
    let mobilePhoneField = document.getElementById('user_mobile_phone');
    let countryCodeField = document.getElementById('user_country_code');
    let button = document.getElementById('user_form_commit');

    mobilePhoneField.addEventListener('blur', function(event) {
        resetMobileFields();

        let validator = new MobilePhone(mobilePhoneField.value);
        if (!validator.validate()) {
            setMobilePhoneInvalid();
        } else {
            mobilePhoneField.value = validator.format();
        }
    });
});
