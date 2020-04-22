var DexLib = artifacts.require("./DexLib");
var ERC20Token = artifacts.require("./ERC20Token");
var BlockSpaceToken = artifacts.require("./BlockSpaceToken");
var ProtocolGasFutures = artifacts.require("./ProtocolGasFutures");
var ProtocolGasFuturesToken = artifacts.require("./ProtocolGasFuturesToken");
var Dex = artifacts.require("./Dex");

var Mock = artifacts.require("./Mock");

var period = 40;


function wait(ms){
   var start = new Date().getTime();
   var end = start;
   while(end < start + ms) {
     end = new Date().getTime();
  }
}



module.exports = function(deployer, network, accounts) {
  if(network === "development"){

   try {
      web3.personal.importRawKey("1111111111111111111111111110111111111111111111111111111111111110", "password");
   }
   catch(e) {}
   let dexAdmin = "0xe035e5542e113f144286847c7b97a1da110df49f";
   web3.personal.unlockAccount(dexAdmin, "password");
   let fiveETH = Number(web3.toWei(5,'ether'));
   web3.eth.sendTransaction({ from: accounts[0], to: dexAdmin, value: fiveETH * 1000 });
   wait(3000);

    deployer.deploy([
      [ BlockSpaceToken ],
      [ ProtocolGasFuturesToken, { from: dexAdmin } ],
      [ ERC20Token ],
      //[ Mock ]
    ]).then( () => {
      return deployer.deploy([
        [ ProtocolGasFutures, ProtocolGasFuturesToken.address, { from: dexAdmin } ],
        [ DexLib ]
      ]);
    }).then( function(instance) {
      console.log(instance);
      deployer.link(DexLib, Dex);
      return deployer.deploy(Dex, dexAdmin, period, { from: dexAdmin, gas: "8000000" }).then(function (dex) {
        instance[0].setDex(dex.address, {from: dexAdmin})
       });
    }); 
  }else if(network === "geth"){
    deployer.deploy([
      [ ProtocolGasFuturesToken ],
      [ DexLib ]
    ]).then( () => {
      deployer.link(DexLib, Dex);
      return deployer.deploy(Dex, accounts[0], period, { from: accounts[0], gas: "8000000" });
    });
  }
};
