export default class IdentityCode {
    constructor(countryCode, identityCode) {
        this.countryCode = countryCode;
        this.identityCode = identityCode;
    }

    validate() {
        if (this.countryCode !== "EE") {
            return true;
        } else {
            return false;
        }
    };
};
