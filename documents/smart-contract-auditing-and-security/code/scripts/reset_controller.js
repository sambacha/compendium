require('dotenv').config()
const Web3 = require('web3')
const web3 = new Web3(new Web3.providers.HttpProvider('https://ropsten.infura.io/v3/13063608568848709ccbad6633f87fc8'))
const ethers = require('ethers')
// other address: 0x217Dc6A3130a6ab45942219DC4258d680BA5e160
const other = new ethers.Wallet('0x405787fa12a823e0f2b7631cc41b3ba8828b3321ca811111fa75cd3aa3bb5ace', web3) 
const contract_endpoints = require('../../../src/contract_endpoints.js')

module.exports = (callback) => {
  let changeController = contract_endpoints.changeController(other, process.env.universal)
  // Change the controller back to the original controller address
  changeController(process.env.controller, (res_code, res_msg) => {
    if (res_code !== 200) callback(`controller -- code: ${res_code}; message: ${res_msg}`) 
    callback()
  })
}
