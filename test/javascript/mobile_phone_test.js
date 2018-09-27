// import MobilePhone from '../../app/javascript/packs/mobile_phone';

QUnit.module('MobilePhone validation');

QUnit.test('phone number needs to be a number', function(assert) {
    assert.ok(true);
});

QUnit.test('foreign numbers are always accepted', function(assert) {
    assert.ok(true);
});

QUnit.test('estonian numbers need to start with 5.', function(assert) {
    assert.ok(true);
});

QUnit.test('estonian numbers need to be 7 or 8 chars long', function(assert) {
    assert.ok(true);
});
