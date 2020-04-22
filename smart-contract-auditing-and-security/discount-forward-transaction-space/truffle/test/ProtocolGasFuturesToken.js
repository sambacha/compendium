require('truffle-test-utils').init();

var ProtocolGasFuturesTokenArtifact = artifacts.require("ProtocolGasFuturesToken");

var MockArtifact = artifacts.require("Mock");
var Utils = require('./Utils')(ProtocolGasFuturesTokenArtifact);

contract('ProtocolGasFuturesToken', function(accounts) {
    web3.eth.defaultAccount = web3.eth.coinbase;

    it("should have a name and ticker that are proper", async () => {
        let instance = await ProtocolGasFuturesTokenArtifact.deployed();
        let retName = await instance.name();
        assert.equal(retName, "ProtocolGasFutures", "Name on contract does not match expected value");
        let retSymbol = await instance.symbol();
        assert.equal(retSymbol, "GASF", "Symbol on contract does not match expected value");
    });

    it("should properly issue token and fire an event", async () => {

        let instance = await ProtocolGasFuturesTokenArtifact.deployed();
        let bn = web3.eth.blockNumber;
        let mintedTransaction = await instance.issue(bn+100, bn+1000, 1000000, { from: accounts[1], value: 500 }) ;
        let supply = await instance.totalSupply();
        let id = supply.sub(1).toNumber();
        let owner = await instance.ownerOf(id);
        assert.equal(supply.toString(), "1", "Minting should increase supply...");
        assert.web3Event(mintedTransaction, {
            'event': 'DerivativeCreated',
            'args': {
                'id': id,
                'startHeight': bn+100,
                'executeHeight':bn+1000,
                'gasLimit': 1000000
            }
        });
        //assert.equal(owner,accounts[1]);

    });

    it.skip("should be able to set sales price", async () => {

        let instance = await ProtocolGasFuturesTokenArtifact.deployed();
        let bn = web3.eth.blockNumber;
        let mintedTransaction = await instance.issue(bn+100, bn+1000, 1000000, { from: accounts[1], value: 500 }) ;
        let supply = await instance.totalSupply();
        let id = supply.sub(1).toNumber();
        assert.equal(supply.toString(), "2", "Minting should increase supply...");
        assert.web3Event(mintedTransaction, {
            'event': 'DerivativeCreated',
            'args': {
                'id': id,
                'startHeight': bn+100,
                'executeHeight':bn+1000,
                'gasLimit': 1000000
            }
        });
    
        let d1 = await instance.derivativeData.call(id);
        assert.equal(d1[3].toString(),"0");
        let salesPriceTx = await instance.salePrice(id, { "from": accounts[2], "value": new web3.BigNumber("20000000000000000") } );
        let d2 = await instance.derivativeData.call(id);
        assert.equal(d2[3].sub(d1[3]).toString(), "20000000000000000");
    });

    it.skip("should be able to be executed", async () => {

        let web3 = ProtocolGasFuturesTokenArtifact.web3;

        let bn = web3.eth.blockNumber;
        
        let instance = await ProtocolGasFuturesTokenArtifact.deployed();
        let mock = await MockArtifact.deployed();
        
        let startBalance = await Utils.getBalance(instance.address);

        let mintedTransaction = await instance.issue(bn+100, bn+1000, 1000000, { from: accounts[1], value: 500 }) ;
        let supply = await instance.totalSupply();
        let id = supply.sub(1).toNumber();
        assert.equal(supply.toString(), "3", "Minting should increase supply...");
        assert.web3Event(mintedTransaction, {
            'event': 'DerivativeCreated',
            'args': {
                'id': id,
                'startHeight': bn+100,
                'executeHeight':bn+1000,
                'gasLimit': 1000000
            }
        });

        startBalance = await Utils.getBalance(instance.address);

         // someone wants gas
        let salesPriceTx = await instance.salePrice(id, { from: accounts[2], value: 50000 });
        let d1 = await instance.derivativeData.call(id);
        assert.equal(d1[3].toNumber(), 50000);

        let transferTransaction = await instance.safeTransferFrom(accounts[1], accounts[2], id, { from: accounts[0] });
        let owner = await instance.ownerOf(id);
        assert.equal(owner,accounts[2]);
        
        // let execAddrTransaction = await instance.setExecutionAddress(id, mock.address, { "from": accounts[2] } );
        // assert.ok(execAddrTransaction);

        // let funcRef = web3.sha3('increment()').substring(0,11).padEnd(64,0);
        // let execMessageTransaction = await instance.setExecutionMessage(id, funcRef, { "from": accounts[2] } );
        // assert.ok(execMessageTransaction);

        // let startCounter = await mock.counter.call();
        // let settleTransaction = await instance.settle(id,{ "from": accounts[1] });
        // let endCounter = await mock.counter.call();
        // assert.web3Event(settleTransaction, {
        //     'event': 'DerivativeSettled',
        //     'args': {
        //         'id': id,
        //         'maker': accounts[1],
        //         'taker': accounts[2],
        //         'executed': true
        //     }
        // });
        // assert.equal(endCounter-startCounter, 1);
    });

});
