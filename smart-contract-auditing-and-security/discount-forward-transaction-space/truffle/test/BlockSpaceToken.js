require('truffle-test-utils').init();

var BlockSpaceTokenArtifact = artifacts.require("BlockSpaceToken");

var MockArtifact = artifacts.require("Mock");
var Utils = require('./Utils')(BlockSpaceTokenArtifact);

contract.skip('BlockSpaceToken', function(accounts) {

    it("should have a name and ticker that are proper", async () => {
        let instance = await BlockSpaceTokenArtifact.deployed();
        let retName = await instance.name();
        assert.equal(retName, "BlockSpaceToken", "Name on contract does not match expected value");
        let retSymbol = await instance.symbol();
        assert.equal(retSymbol, "SPACE", "Symbol on contract does not match expected value");
    });

    it("should properly create token and fire an event", async () => {

        let instance = await BlockSpaceTokenArtifact.deployed();
        let bn = web3.eth.blockNumber;
        let mintedTransaction = await instance.mint(bn+2,bn+4,100, { from: accounts[1], value: 500 }) ;
        let supply = await instance.totalSupply();
        let id = supply.sub(1).toNumber();
        let owner = await instance.ownerOf(id);
        assert.equal(supply.toString(), "1", "Minting should increase supply...");
        assert.web3Event(mintedTransaction, {
            'event': 'DerivativeCreated',
            'args': {
                'id': id,
                'lower': bn+2,
                'upper':bn+4,
                'gasLimit': 100,
                'bond': 500,
                'offerer': accounts[1]
            }
        });
        assert.equal(owner,accounts[1]);
    });

    it("should be able to transfer token to taker", async () => {

        let instance = await BlockSpaceTokenArtifact.deployed();
        let bn = web3.eth.blockNumber;
        let mintedTransaction = await instance.mint(bn+2,bn+4,100, { from: accounts[1], value: 500 }) ;
        let supply = await instance.totalSupply();
        let id = supply.sub(1).toNumber();
        let owner = await instance.ownerOf(id);
        assert.equal(supply.toString(), "2", "Minting should increase supply...");
        assert.web3Event(mintedTransaction, {
            'event': 'DerivativeCreated',
            'args': {
                'id': id,
                'lower': bn+2,
                'upper':bn+4,
                'gasLimit': 100,
                'bond': 500,
                'offerer': accounts[1]
            }
        });
        assert.equal(owner,accounts[1]);

        let transferTransaction = await instance.safeTransferFrom(accounts[1], accounts[2], id, { from: accounts[1] });
        owner = await instance.ownerOf(id);
        assert.equal(owner,accounts[2]);
    });

    it("should allow bond to be increased", async () => {
        let instance = await BlockSpaceTokenArtifact.deployed();
        let bn = web3.eth.blockNumber;
        let mintedTransaction = await instance.mint(bn+2,bn+4,100, { "from": accounts[0], value: 500 }) ;
        let supply = await instance.totalSupply();
        let id = supply.sub(1).toNumber();
        assert.equal(supply.toString(), "3", "Minting should increase supply...");
        assert.web3Event(mintedTransaction, {
            'event': 'DerivativeCreated',
            'args': {
                'id': id,
                'lower': bn+2,
                'upper': bn+4,
                'gasLimit': 100,
                'bond': 500,
                'offerer': accounts[0]
            }
        });
        
        let increaseTransaction = await instance.increaseBond(id, { "from": accounts[2], "value": new web3.BigNumber("20000000000000000") } );
        let balance = await Utils.getBalance(instance.address);
        assert.equal(balance.toString(), "20000000000001500");
    });

    it("should allow offerer to cancel it", async () => {
        let instance = await BlockSpaceTokenArtifact.deployed();
        let bn = web3.eth.blockNumber;
        let mintedTransaction = await instance.mint(bn+2,bn+4,100, { "from": accounts[1], value: 500 }) ;
        let supply = await instance.totalSupply();
        let id = supply.sub(1).toNumber();
        assert.equal(supply.toString(), "4", "Minting should increase supply...");
        assert.web3Event(mintedTransaction, {
            'event': 'DerivativeCreated',
            'args': {
                'id': id,
                'lower': bn+2,
                'upper': bn+4,
                'gasLimit': 100,
                'bond': 500,
                'offerer': accounts[1]
            }
        });
        let canceledTransaction = await instance.cancel(id, { "from":accounts[1] } );
        assert.web3Event(canceledTransaction, {
            'event': 'DerivativeCanceled',
            'args': {
                'id': id,
                'offerer': accounts[1],
                'gasLimit': 100,
                'bond': 500
            }
        });
    });

    it("should be able to be executed", async () => {
        let instance = await BlockSpaceTokenArtifact.deployed();
        let mock = await MockArtifact.deployed();
        let bn = web3.eth.blockNumber;
        let mintedTransaction = await instance.mint(bn+2,bn+4,20400, { "from": accounts[1], value: 500 }) ;
        let supply = await instance.totalSupply();
        let id = supply.sub(1).toNumber();
        assert.equal(supply.toString(), "5", "Minting should increase supply...");
        assert.web3Event(mintedTransaction, {
            'event': 'DerivativeCreated',
            'args': {
                'id': id,
                'lower': bn+2,
                'upper': bn+4,
                'gasLimit': 20400,
                'bond': 500,
                'offerer': accounts[1]
            }
        });

        let startBalance = await Utils.getBalance(instance.address);

        // someone takes miner's offer
        let transferTransaction = await instance.safeTransferFrom(accounts[1], accounts[2], id, { from: accounts[1] });
        let owner = await instance.ownerOf(id);
        assert.equal(owner,accounts[2]);
        
        let execAddrTransaction = await instance.setExecutionAddress(id, mock.address, { "from": accounts[2] } );
        assert.ok(execAddrTransaction);

        let funcRef = web3.sha3('increment()').substring(0,11).padEnd(64,0);
        let execMessageTransaction = await instance.setExecutionMessage(id, funcRef, { "from": accounts[2] } );
        assert.ok(execMessageTransaction);

        let startCounter = await mock.counter.call();
        let settleTransaction = await instance.settle(id,{ "from": accounts[1] });
        let endCounter = await mock.counter.call();
        assert.web3Event(settleTransaction, {
            'event': 'DerivativeSettled',
            'args': {
                'id': id,
                'maker': accounts[1],
                'taker': accounts[2],
                'executed': true
            }
        });
        assert.equal(endCounter-startCounter, 1);
    });

    it("should allow taker to reclaim bond if offerer fails to execute", async() => {

        let instance = await BlockSpaceTokenArtifact.deployed();
        let bn = web3.eth.blockNumber;
        let mintedTransaction = await instance.mint(bn+2,bn+4,100, { from: accounts[1], value: 500 }) ;
        let supply = await instance.totalSupply();
        let id = supply.sub(1).toNumber();
        assert.equal(supply.toString(), "6", "Minting should increase supply...");
        assert.web3Event(mintedTransaction, {
            'event': 'DerivativeCreated',
            'args': {
                'id': id,
                'lower': bn+2,
                'upper':bn+4,
                'bond': 500,
                'gasLimit': 100,
                'offerer': accounts[1]
            }
        });

        // someone takes miner's offer
        let transferTransaction = await instance.safeTransferFrom(accounts[1], accounts[2], id, { from: accounts[1] });
        let owner = await instance.ownerOf(id);
        assert.equal(owner,accounts[2]);

        for(var i = 0; i < 4; i++){
            Utils.mineBlock();
        }

        let reclaimTransaction = await instance.reclaim(id, { from: accounts[2] }) ;
        assert.web3Event(reclaimTransaction, {
            'event': 'BondClaimed',
            'args': {
                'id': supply.sub(1).toNumber(),
                'taker': accounts[2],
                'bond': 500
            }
        });
        
    });

});
