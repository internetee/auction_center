import IdentityCode from '../src/identity_code';
import MobilePhone from '../src/mobile_phone';

function setMobilePhoneInvalid() {
    let mobilePhoneField = document.getElementById('user_mobile_phone').parentElement;
    mobilePhoneField.classList.add('error');
}

function setIdentityCodeFieldInvalid() {
    let identityCodeField = document.getElementById('user_identity_code').parentElement;
    identityCodeField.classList.add('error');
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
    let mobilePhoneField = document.getElementById('user_mobile_phone').parentElement;
    mobilePhoneField.classList.remove('error');
    let identityCodeField = document.getElementById('user_identity_code').parentElement;
    identityCodeField.classList.remove('error');
}

function formHandler() {
    let mobilePhoneField = document.getElementById('user_mobile_phone');
    let identityCodeField = document.getElementById('user_identity_code');
    let countryCodeField = document.getElementById('user_country_code');
    let button = document.getElementById('user_form_commit');

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

    if (document.querySelector('.error')) {
        disableSubmitButton();
    }
}

document.addEventListener("DOMContentLoaded", function() {
    let form = document.getElementById('user_form');
    let button = document.getElementById('user_form_commit');

    form.addEventListener('change', formHandler);
    button.addEventListener('click', formHandler);
});
