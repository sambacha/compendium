const async = require('async')

module.exports = (app, nft) => {
  async.series([
    // Set the `approve` target
    (callback) => { app.setTarget('0x095ea7b3', nft, error_callback(callback)) }, 
    // Set the `createRecord` target
    (callback) => { app.setTarget('0x4b3f0f73', nft, error_callback(callback)) }, 
    // Set the `safeTransferFrom` target for transfers without extra data
    (callback) => { app.setTarget('0x42842e0e', nft, error_callback(callback)) }, 
    // Set the `safeTransferFrom` target for transfers with extra data
    (callback) => { app.setTarget('0xb88d4fde', nft, error_callback(callback)) }, 
    // Set the `setApprovalForAll` target
    (callback) => { app.setTarget('0xa22cb465', nft, error_callback(callback)) }, 
    // Set the `signedTransfer` target
    (callback) => { app.setTarget('0x185da2bf', nft, error_callback(callback)) }, 
    // Set the `transferFrom` target
    (callback) => { app.setTarget('0x23b872dd', nft, error_callback(callback)) }, 
    // Set the `versionRecord` target
    (callback) => { app.setTarget('0x8de37a84', nft, error_callback(callback)) }, 
    // Set the `versionRecordSigned` target
    (callback) => { app.setTarget('0x2855a1d5', nft, error_callback(callback)) }
  ])
  return 
}

function error_callback(callback) { 
  return (code, message) => {
    if (code !== 200) throw message 
    callback()
  }
}
