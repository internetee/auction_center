import * as libphonenumber from 'libphonenumber-js';

class MobilePhone {
    constructor(countryCode, mobileNumber) {
        this.countryCode = countryCode;
        this.mobileNumber = mobileNumber;
        this.parsedNumber = libphonenumber.parseNumber(
            this.mobileNumber,
            { extended: true, defaultCountry: this.countryCode }
        );
    }

    validate() {
        return this.parsedNumber.valid;
    }

    format() {
        let formatted = libphonenumber.formatNumber(this.parsedNumber, 'E.164');
        return formatted;
    };
}

export default MobilePhone;
