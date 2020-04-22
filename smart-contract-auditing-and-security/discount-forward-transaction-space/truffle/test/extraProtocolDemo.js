require('truffle-test-utils').init();

var BlockSpaceTokenArtifact = artifacts.require("BlockSpaceToken");
var DexArtifact = artifacts.require("Dex");

contract.skip('Extra Protocol', function(accounts) {

	// let web3 = BlockSpaceTokenArtifact.web3;

	// let miner = accounts[1];
	// let gasFutureId;

	// let protocolInstance = await ProtocolGasFuturesArtifact.deployed();
	// assert.ok(protocolInstance);
	// Utils.log("Protocol deployed at " + protocolInstance.address);

	// let bal = await Utils.getBalance(protocolInstance.address);
	// let expectedBalance = web3.toWei(5, 'ether');
	// if(bal < expectedBalance){
	//   let ethTx = await Utils.sendTransaction({
	//     from: accounts[0],
	//     to: protocolInstance.address,
	//     value: new web3.BigNumber(expectedBalance).sub(bal)
	//   });
	//   assert.ok(ethTx);
	// }

	// bal = await Utils.getBalance(protocolInstance.address);
	// assert.equal(bal,expectedBalance);
	// Utils.log("Balance: " + bal);

	// let issueTx = await protocolInstance.issue({ from: miner });
	// assert.web3Event(issueTx, {
	//   'event': 'CreatedGasFuture',
	//   'args': {
	//       'id': 0
	//   }
	// });

	// gasFutureId = issueTx.logs[0].args.id;

	// Utils.log("Created gas future (id=" + gasFutureId + ")");

	// });

	// it('should be able to add gas future to DEX', async() => {

	// let token = await ProtocolGasFuturesTokenArtifact.deployed();
	// let dex = await DexArtifact.deployed();

	// let tokenName = await token.name.call();
	// let symbolName = await token.symbol.call();
	// let exists = await dex.checkToken.call(tokenName);
	// if(!exists){
	//   Utils.log(tokenName + " doesn't exist in DEX");
	//   Utils.log("Adding " + tokenName + " to DEX");
	//   let addTx = await dex.addNFToken(token.address, tokenName, { from: accounts[0] });
	//   let id = await token.totalSupply.call();
	//   Utils.log("id=" + id);
	//   assert.web3Event(addTx,{
	//     'event': 'TokenAdded',
	//     'args': {
	//       'symbolName': symbolName, 
	//       'addr': token.address, 
	//       'idx': id.sub(1).toNumber()
	//     }
	//   });
	// }

	// let transferTx = await token.safeTransferFrom(accounts[1], accounts[2], id, { from: accounts[1] });
	// owner = await instance.ownerOf(id);
	// assert.equal(owner,accounts[2]);

	// let depositTx = await dex.depositNFToken(symbolName, gasFutureId, { from: accounts[1] });
	// assert.web3Event(depositTx, {
	//   'event': 'Deposit',
	//   'args': {
	//     'symbolName': symbol,
	//     'user': accounts[1], 
	//     'value': gasFutureId,
	//     'balance': 1
	//   }
	// });
});