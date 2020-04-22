const truffle_contract = require('truffle-contract') 
const contract_endpoints = require('../../../src/contract_endpoints.js')
const ethers = require('ethers')

module.exports = async (app, admin, controller, master, nft, universal) => {
  // Set the truffle contract abstractions
  app.universal_contract = truffle_contract(require(getPath() + 'ethereum/build/contracts/UniversalABI.json'))
  app.universal_contract.setProvider(app.web3.currentProvider)
  if (typeof app.universal_contract.currentProvider.sendAsync !== "function") {
    app.universal_contract.currentProvider.sendAsync = function() {
      return app.universal_contract.currentProvider.send.apply(
        app.universal_contract.currentProvider, arguments
      )
    };
  }
  
  app.controller_contract = truffle_contract(require(getPath() + 'ethereum/build/contracts/Controller.json'))
  app.controller_contract.setProvider(app.web3.currentProvider)
  if (typeof app.controller_contract.currentProvider.sendAsync !== "function") {
    app.controller_contract.currentProvider.sendAsync = function() {
      return app.controller_contract.currentProvider.send.apply(
        app.controller_contract.currentProvider, arguments
      )
    };
  }
  
  // Change the controller address of the universal proxy to the deployed controller
  let change_controller = contract_endpoints.changeController(admin, universal)
  change_controller(controller, (res_code, res_msg) => {
    if (res_code !== 200) {
      throw res_msg
    } else {
      // Set up the app's proxy contract functions
      app.changeController = contract_endpoints.changeController(admin, controller) 
      app.changeMaster = contract_endpoints.changeMaster(admin, controller)
      app.setTarget = contract_endpoints.setTarget(admin, controller)
      app.pause = contract_endpoints.pause(admin, controller)

      // Set up the app's proxy contract functions
      app.approve = contract_endpoints.approve(admin, universal)
      app.createRecord = contract_endpoints.createRecord(admin, universal)
      app.safeTransferFrom = contract_endpoints.safeTransferFrom(admin, universal)
      app.setApprovalForAll = contract_endpoints.setApprovalForAll(admin, universal)
      app.signedTransfer = contract_endpoints.signedTransfer(admin, universal)
      app.transferFrom = contract_endpoints.transferFrom(admin, universal)
      app.versionRecord = contract_endpoints.versionRecord(admin, universal)
      app.versionRecordSigned = contract_endpoints.versionRecordSigned(admin, universal)
      
      // Set the nft targets within the master proxy
      require('./nft_set_targets.js')(app, nft) 
      return
    }
  })
}

function getPath() {
  var path = __dirname
  var arr = __dirname.split('/')
  arr = arr.slice(0, arr.length - 3)
  return arr.join('/') + '/'
}
