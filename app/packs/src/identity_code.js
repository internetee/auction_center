export default class IdentityCode {
    constructor(countryCode, identityCode) {
        this.countryCode = countryCode;
        this.identityCode = identityCode;
    }

    validate() {
        if (this.countryCode !== "EE") {
            return true;
        } else {
            if (/[0-9]{11}/.test(this.identityCode)) {
                let controlDigit = this.controlDigit();
                let checkDigit = parseInt(this.identityCode.charAt(10));

                return (controlDigit === checkDigit);
            } else {
                return false;
            }
        }
    };

    controlDigit() {
        if (this.countryCode === "EE") {
            let identityCode = this.identityCode;
            let total = this.calculateEstonianControlDigit(identityCode);
            return total;
        } else {
            return this.identityCode;
        }
    }

    calculateEstonianControlDigit(identityCode) {
        let scales = [1, 2, 3, 4, 5, 6, 7, 8, 9, 1];
        let total = this.mapScalesWithIdentityCode(scales, identityCode);
            if (total === 10) {
                scales = [3, 4, 5, 6, 7, 8, 9, 1, 2, 3];
                total = this.mapScalesWithIdentityCode(scales, identityCode);

                if (total === 10) {
                    return 0;
                } else {
                    return total;
                }
            } else {
                return total;
            }
        return total;
    }

    mapScalesWithIdentityCode(scales, identityCode) {
        let total = scales.map(function f(currentValue, index) {
            return parseInt(identityCode[index]) * currentValue;
        }).reduce(function f(sum = 0, item) {
            return sum + item;
        });

        return (total % 11);
    }
};
