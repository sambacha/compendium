require('dotenv').config()
const Web3 = require('web3')
const web3 = new Web3(new Web3.providers.HttpProvider('https://ropsten.infura.io/v3/13063608568848709ccbad6633f87fc8'))
const ethers = require('ethers')
const contract_endpoints = require('../../../src/contract_endpoints.js')

module.exports = (wallet, callback) => {
  let changeMaster = contract_endpoints.changeMaster(wallet, process.env.controller)
  changeMaster(process.env.master, (code, msg) => {
    if (code != 200) callback(`master -- code: ${code}; message: ${msg}`) 
    callback()
  })
}
