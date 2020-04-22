require('truffle-test-utils').init();

var DexArtifact = artifacts.require("Dex");
var ProtocolGasFuturesTokenArtifact = artifacts.require("ProtocolGasFuturesToken");

var Utils = require('./Utils')(DexArtifact);

contract('Dex', function(accounts) {

    it.skip('should skip test',async () => {

        assert.fail("should not enter");

    });

    it("should be able to check if token exists", async () => {

        let instance = await DexArtifact.deployed();
        let token = await ProtocolGasFuturesTokenArtifact.deployed();
        let tokenName = await token.name.call();
        let exists = await instance.checkToken.call(tokenName);
        assert(!exists);

    });

    it("should not accept ether", async () => {

        let instance = await DexArtifact.deployed();
        try{
            let tx = await instance.sendTransaction({
                from: accounts[0],
                value: 5
            });
            assert.fail('accepted ether');
        }catch(e){
            assert.ok(e);
        }

    });

});