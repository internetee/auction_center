import IdentityCode from './identity_code';

function MobilePhoneValidator(numberField) {
    this.number = numberField.value;
}

MobilePhoneValidator.prototype.validate = function() {
    if ((/\+372/).test(this.number)) {
        if ((/\+3725[0-9]{6,7}/).test(this.number)) {
            return true;
        } else {
            return false;
        }
    } else {
        return true;
    }
};

function resetFields() {
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
    let identityCodeField = document.getElementById('user_identity_code');
    let countryCodeField = document.getElementById('user_country_code');

    let button = document.getElementById('user_form_commit');

    mobilePhoneField.addEventListener('blur', function(event) {
        resetFields();

        let validator = new MobilePhoneValidator(event.target);
        if (!validator.validate()) {
            setMobilePhoneInvalid();
        }
    });
});
