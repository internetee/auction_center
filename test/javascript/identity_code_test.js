import IdentityCode from '../../app/packs/src/identity_code';

QUnit.module('IdentityCode validation');

QUnit.test('foreign identity code is always valid', function(assert) {
    let identityCode = new IdentityCode('FI', 'Foo');
    assert.ok(identityCode.validate());

    identityCode = new IdentityCode('PL', '1897918749812');
    assert.ok(identityCode.validate());
});

QUnit.test('Estonian identity code needs to be 11 characters, only digits', function(assert) {
    let identityCode = new IdentityCode('EE', '111');
    assert.notOk(identityCode.validate());

    identityCode = new IdentityCode('EE', 'A0123456789');
    assert.notOk(identityCode.validate());
});

QUnit.test('Estonian identity code is valid at random', function (assert) {
    let arrayOfCodes = ['51007050316', '51007050327', '51007050338',
                        '51007050349', '51007050352', '51007050360',
                        '51007050371', '51007050382', '51007050393',
                        '51007050403', '51007050414', '51007050425',
                        '51007050436', '51007050447', '51007050458',
                        '51007050469', '51007050470', '51007050480',
                        '51007050491', '51007050501', '51007050512',
                        '51007050523', '51007050534', '51007050545',
                        '51007050556', '51007050567', '51007050578',
                        '51007050589', '51007050597', '51007050604',
                        '51007050610', '51007050621', '51007050632',
                        '51007050643', '51007050654', '51007050665',
                        '51007050676', '51007050687'];

    let randomItem = arrayOfCodes[
        Math.floor(Math.random() * arrayOfCodes.length)
    ];

    let identityCode = new IdentityCode('EE', randomItem);
    assert.ok(identityCode.validate());
});
