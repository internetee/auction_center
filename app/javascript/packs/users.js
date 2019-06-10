import MobilePhone from '../src/mobile_phone';

function setMobilePhoneInvalid() {
    const mobilePhoneField = document
        .getElementById('user_mobile_phone')
        .parentElement;
    mobilePhoneField.classList.add('error');
}

function disableSubmitButton() {
    const button = document.getElementById('user_form_commit');
    button.disabled = true;
}

function enableSubmitButton() {
    const button = document.getElementById('user_form_commit');
    button.disabled = false;
}

function resetFields() {
    const mobilePhoneField = document
        .getElementById('user_mobile_phone')
        .parentElement;
    mobilePhoneField.classList.remove('error');
}

function formHandler() {
    const mobilePhoneField = document.getElementById('user_mobile_phone');
    const countryCodeField = document.getElementById('user_country_code');

    resetFields();
    enableSubmitButton();

    const mobilePhone =
          new MobilePhone(countryCodeField.value, mobilePhoneField.value);
    if (!mobilePhone.validate()) {
        setMobilePhoneInvalid();
    } else {
        mobilePhoneField.value = mobilePhone.format();
    }

    if (document.querySelector('.error')) {
        disableSubmitButton();
    }
}

document.addEventListener('turbolinks:load', function() {
    const form = document.getElementById('user_form');
    const button = document.getElementById('user_form_commit');

    form.addEventListener('change', formHandler);
    button.addEventListener('click', formHandler);
});
