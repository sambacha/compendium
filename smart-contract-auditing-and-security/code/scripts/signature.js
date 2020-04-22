const ethers = require('ethers')
const admin = new ethers.Wallet('0x290decd9548b62a8d60345a988386fc84ba6bc95484008f6362f93160ef3e563')
admin.signMessage('Authentification nonce').then(signature =>{
  console.log(signature)
}).catch(error => {
  console.log(error)
})
