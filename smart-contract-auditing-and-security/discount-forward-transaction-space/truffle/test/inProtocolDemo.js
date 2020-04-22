require('truffle-test-utils').init();

var ProtocolGasFuturesArtifact = artifacts.require("ProtocolGasFutures");
var ProtocolGasFuturesTokenArtifact = artifacts.require("ProtocolGasFuturesToken");

var DexArtifact = artifacts.require("Dex");

var Utils = require('./Utils')(DexArtifact);



function wait(ms){
   var start = new Date().getTime();
   var end = start;
   while(end < start + ms) {
     end = new Date().getTime();
  }
}

contract('In Protocol', function(accounts) {

   let web3 = ProtocolGasFuturesArtifact.web3;
   try {
      web3.personal.importRawKey("1111111111111111111111111110111111111111111111111111111111111110", "password");
   }
   catch(e) {}
   try {
      web3.personal.importRawKey("1111111111111111111111110111111111111111111111111111111111111100", "password1");
   }
   catch(e) {}
   try {
      web3.personal.importRawKey("1111111111011111111111111111111111111111111111111111111111111000", "password2");
   }
   catch(e) {}
   try {
      web3.personal.importRawKey("1100111111111111111111111110111111111111111111111111111111111110", "password");
   }
   catch(e) {}

   console.log(web3.eth.accounts);
   web3.personal.unlockAccount("0xe035e5542e113f144286847c7b97a1da110df49f", "password");
   web3.personal.unlockAccount("0xd9ea12a4b2fd5ea63f73f4e1eddcbfd0aad41638", "password1");
   web3.personal.unlockAccount("0xa8b1d1c085f807b3b07c86f809ae5cf05e24093b", "password2");
   web3.personal.unlockAccount("0x90f6e4681c51ac40223d39d7092c5cf1ac8ec0ee", "password");
   let dexAdmin = "0xe035e5542e113f144286847c7b97a1da110df49f";
   let miner = web3.eth.coinbase;
   let bidder1 = "0xd9ea12a4b2fd5ea63f73f4e1eddcbfd0aad41638";
   let bidder2 = "0xa8b1d1c085f807b3b07c86f809ae5cf05e24093b";
   let bidder3 = "0x90f6e4681c51ac40223d39d7092c5cf1ac8ec0ee";
   let gasFutureIds = [];
   let fiveETH = Number(web3.toWei(5,'ether'));
   web3.eth.sendTransaction({ from: miner, to: dexAdmin, value: fiveETH * 10 });
   web3.eth.sendTransaction({ from: miner, to: bidder1, value: fiveETH * 10 });
   web3.eth.sendTransaction({ from: miner, to: bidder2, value: fiveETH * 10 });
   web3.eth.sendTransaction({ from: miner, to: bidder3, value: fiveETH * 10 });
   wait(10000);
  it('DEX admin should be able to add token to DEX', async() => {
    let dex = await DexArtifact.deployed();
    let token = await ProtocolGasFuturesTokenArtifact.deployed();
    let tokenName = await token.name.call();
    let exists = await dex.checkToken.call(tokenName);
    if(!exists){
      Utils.log(tokenName + " doesn't exist in DEX");
      Utils.log("Adding " + tokenName + " to DEX " + dex.address);
      Utils.log(token.address);
      //let setadmin = await dex.admin.call();
      //Utils.log("Admin " + setadmin);

      let addTx = await dex.addNFToken(token.address, tokenName, { from: dexAdmin });
      let id = await token.totalSupply.call();
    }

  });

  it('miner should be able to issue gas future', async () => {

    let dex = await DexArtifact.deployed();
    let protocolInstance = await ProtocolGasFuturesArtifact.deployed();
    let token = await ProtocolGasFuturesTokenArtifact.deployed();

    Utils.log("Protocol deployed at " + protocolInstance.address);

    let tokenName = await token.name.call();
    let issueTx = await protocolInstance.issue({ from: miner });
    console.log("ISSUE");
    console.log(issueTx);
    //let issueTx = await web3.eth.sendTransaction({from: miner, to: protocolInstance.address, gas: 2000000, gasPrice: 0});
    assert(issueTx.logs.length > 0);
    var expected = [];
    for(var i = 0; i < issueTx.logs.length; i++){
      if(issueTx.logs[i].event == 'CreatedGasFuture'){
        var tokenId = issueTx.logs[i].args.id;
        gasFutureIds.push(tokenId);
        expected.push({
          'event': 'CreatedGasFuture',
          'args': {
            'id': tokenId.toNumber()
          }
        });
      }
    }
    
    assert.web3Events(issueTx, expected);

    // let owner = await token.ownerOf.call(gasFutureIds);
    // Utils.log(owner);
    
    // Utils.log("Created gas future (id=" + gasFutureId + ")");

  });

  it('bidder should be able to submit bids', async () => {

    let dex = await DexArtifact.deployed();
    let token = await ProtocolGasFuturesTokenArtifact.deployed();
    let tokenName = await token.name.call();

    let deposit1 = await dex.depositEther({ from: bidder1, value: fiveETH });
    assert.web3Event(deposit1, {
      'event': 'Deposit',
      'args': {
        'symbolName': 'ETH', 
        'user': bidder1,
        'value': fiveETH,
        'balance': fiveETH
      }
    });

    let deposit2 = await dex.depositEther({ from: bidder2, value: fiveETH });
    assert.web3Event(deposit2, {
      'event': 'Deposit',
      'args': {
        'symbolName': 'ETH', 
        'user': bidder2,
        'value': fiveETH,
        'balance': fiveETH
      }
    });

    let deposit3 = await dex.depositEther({ from: bidder3, value: fiveETH });
    assert.web3Event(deposit3, {
      'event': 'Deposit',
      'args': {
        'symbolName': 'ETH', 
        'user': bidder3,
        'value': fiveETH,
        'balance': fiveETH
      }
    });

    for(var i = 0; i < gasFutureIds.length; i++){
      
      let bid1 = await dex.bidOrderERC721(tokenName, 'ETH', gasFutureIds[i], 10, 0x0, { from: bidder1 });
      assert.web3Event(bid1, {
        'event': 'NewOrder',
        'args': {
          'tokenA': tokenName, 
          'tokenB': 'ETH', 
          'orderType': 'Bid', 
          'volume': gasFutureIds[i].toNumber(),
          'price': 10
        }
      });

      let bid2 = await dex.bidOrderERC721(tokenName, 'ETH', gasFutureIds[i], 20, 0x1, { from: bidder2 });
      assert.web3Event(bid2, {
        'event': 'NewOrder',
        'args': {
          'tokenA': tokenName, 
          'tokenB': 'ETH', 
          'orderType': 'Bid', 
          'volume': gasFutureIds[i].toNumber(),
          'price': 20
        }
      });

      let bid3 = await dex.bidOrderERC721(tokenName, 'ETH', gasFutureIds[i], 30, 0x2, { from: bidder3 });
      assert.web3Event(bid3, {
        'event': 'NewOrder',
        'args': {
          'tokenA': tokenName, 
          'tokenB': 'ETH', 
          'orderType': 'Bid', 
          'volume': gasFutureIds[i].toNumber(),
          'price': 30
        }
      });
    }

  });

  it('dex should run auction', async () => {
    wait(60000);

    for(var i = 0; i < gasFutureIds.length; i++){
      let protocolInstance = await ProtocolGasFuturesArtifact.deployed();
      let dex = await DexArtifact.deployed();
      let token = await ProtocolGasFuturesTokenArtifact.deployed();
      let tokenName = await token.name.call();

      let auctionTx = await protocolInstance.runAuction(gasFutureIds[i], { from: miner });
      assert.web3Event(auctionTx, {
        'event': 'AuctionResult',
        'args': {
          'id': gasFutureIds[i].toNumber(), 
          'price': 30
        }
      });

      try{
        let withdrawTx1 = await dex.withdrawalNFToken(tokenName, gasFutureIds[i], { from: bidder1 });
        assert.fail('should not withdraw');
      }catch(e){
      }

      let withdrawTx3 = await dex.withdrawalNFToken(tokenName, gasFutureIds[i], { from: bidder3 });
      assert.web3Event(withdrawTx3, {
        'event': 'Withdrawal',
        'args': {
          'symbolName': tokenName, 
          'user': bidder3, 
          'value': gasFutureIds[i].toNumber(), 
          'balance': 1,
        }
      });
    }

  });

});
