require('dotenv').config()
const app = require('../../../src/app.js')
const Web3 = require('web3')
const ethers = require('ethers')
app.web3 = new Web3(new Web3.providers.HttpProvider('https://ropsten.infura.io/v3/13063608568848709ccbad6633f87fc8'))
// admin address: 0xa433f323541CF82f97395076B5F83a7A06F1646c
const admin = new ethers.Wallet('0x290decd9548b62a8d60345a988386fc84ba6bc95484008f6362f93160ef3e563', app.web3)

require('./reset_controller.js')(e => {
  if (e) console.log(e)
  setTimeout(require('./reset_master.js'), 20000, admin, error => {
    if (error) console.log(error)
  })
})
