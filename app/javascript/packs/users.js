import IdentityCode from '../src/identity_code';
import MobilePhone from '../src/mobile_phone';

function setMobilePhoneInvalid() {
    let mobilePhoneField = document.getElementById('user_mobile_phone');
    mobilePhoneField.classList.add('is-invalid');
}

function setIdentityCodeFieldInvalid() {
    let identityCodeField = document.getElementById('user_identity_code');
    identityCodeField.classList.add('is-invalid');
}

function disableSubmitButton() {
    let button = document.getElementById('user_form_commit');
    button.disabled = true;
}

function enableSubmitButton() {
    let button = document.getElementById('user_form_commit');
    button.disabled = false;
}

function resetFields() {
    let mobilePhoneField = document.getElementById('user_mobile_phone');
    mobilePhoneField.classList.remove('is-invalid');
    let identityCodeField = document.getElementById('user_identity_code');
    identityCodeField.classList.remove('is-invalid');
}

document.addEventListener("DOMContentLoaded", function() {
    let mobilePhoneField = document.getElementById('user_mobile_phone');
    let identityCodeField = document.getElementById('user_identity_code');
    let countryCodeField = document.getElementById('user_country_code');
    let button = document.getElementById('user_form_commit');

    let form = document.getElementById('user_form');
    console.log(form);

    form.addEventListener('change', function(event) {
        resetFields();
        enableSubmitButton();
        let identityCode = new IdentityCode(countryCodeField.value, identityCodeField.value);
        if (!identityCode.validate()) {
            setIdentityCodeFieldInvalid();
        }

        let mobilePhone = new MobilePhone(countryCodeField.value, mobilePhoneField.value);
        if (!mobilePhone.validate()) {
            setMobilePhoneInvalid();
        } else {
            mobilePhoneField.value = mobilePhone.format();
        }

        if (document.querySelector('.is-invalid')) {
            disableSubmitButton();
        }
    });
});
