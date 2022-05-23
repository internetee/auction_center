import MobilePhone from '../../app/packs/src/mobile_phone';

QUnit.module('MobilePhone validation');

QUnit.test('phone number needs to be a number', function(assert) {
    let mobilePhone = new MobilePhone('EE', 'Foo');
    assert.notOk(mobilePhone.validate());
});

QUnit.test('phone number are validated with national rules', function(assert) {
    let mobilePhone = new MobilePhone('EE', '+3725510203040');
    assert.notOk(mobilePhone.validate());
});

QUnit.test('when providing a phone number, E.164 format takes precedence', function(assert) {
    let mobilePhone = new MobilePhone('EE', '+48605100200');
    assert.equal('PL', mobilePhone.parsedNumber.country);
});

QUnit.test('you can provide a number without E.165 country code', function(assert) {
    let mobilePhone = new MobilePhone('PL', '+48605100200');
    assert.equal('PL', mobilePhone.parsedNumber.country);
});

QUnit.module('MobilePhone formatting');
QUnit.test('numbers are formatted automatically', function(assert) {
    let mobilePhone = new MobilePhone('EE', '55962234');
    assert.equal(mobilePhone.format(), '+37255962234');

    mobilePhone.mobileNumber = '+37255962234';
    assert.equal(mobilePhone.format(), '+37255962234');

    mobilePhone = new MobilePhone('PL', '605100200');
    assert.equal(mobilePhone.format(), '+48605100200');
});
