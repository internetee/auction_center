import IdentityCode from '../src/identity_code';
import MobilePhone from '../src/mobile_phone';

function setMobilePhoneInvalid() {
    let mobilePhoneField = document.getElementById('user_mobile_phone').parentElement;
    mobilePhoneField.classList.add('error');
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
}

function formHandler() {
    let mobilePhoneField = document.getElementById('user_mobile_phone');
    let countryCodeField = document.getElementById('user_country_code');
    let button = document.getElementById('user_form_commit');

    resetFields();
    enableSubmitButton();

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
