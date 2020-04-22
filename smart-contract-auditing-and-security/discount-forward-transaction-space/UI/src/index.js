import * as Web3 from "web3";

import { Table } from './component/table/table.js';
import { Chart } from './component/chart/chart.js';

import './styles.css';

var url = "http://localhost:9545";
var web3 = new Web3(new Web3.providers.HttpProvider(url));

const PROTOCOL_ADDRESS = "0x83bd509c95e724d3c0c1ec3561433611d81cc8df";
const TOKEN_ADDRESS = "0x9bcb6c42ce458397f7621337cf7079d535d5ad70";

function watchEvents(){

    var ProtocolContract = web3.eth.contract(
        [
        {
          "constant": true,
          "inputs": [],
          "name": "numFuturesIssued",
          "outputs": [
            {
              "name": "",
              "type": "uint256"
            }
          ],
          "payable": false,
          "stateMutability": "view",
          "type": "function"
        },
        {
          "constant": true,
          "inputs": [
            {
              "name": "",
              "type": "uint256"
            },
            {
              "name": "",
              "type": "uint256"
            }
          ],
          "name": "ids",
          "outputs": [
            {
              "name": "",
              "type": "uint256"
            }
          ],
          "payable": false,
          "stateMutability": "view",
          "type": "function"
        },
        {
          "inputs": [
            {
              "name": "_token",
              "type": "address"
            }
          ],
          "payable": false,
          "stateMutability": "nonpayable",
          "type": "constructor"
        },
        {
          "anonymous": false,
          "inputs": [
            {
              "indexed": true,
              "name": "id",
              "type": "uint256"
            }
          ],
          "name": "CreatedGasFuture",
          "type": "event"
        },
        {
          "anonymous": false,
          "inputs": [
            {
              "indexed": false,
              "name": "id",
              "type": "uint256"
            },
            {
              "indexed": false,
              "name": "price",
              "type": "uint256"
            }
          ],
          "name": "AuctionResult",
          "type": "event"
        },
        {
          "constant": false,
          "inputs": [],
          "name": "issue",
          "outputs": [],
          "payable": false,
          "stateMutability": "nonpayable",
          "type": "function"
        },
        {
          "constant": false,
          "inputs": [
            {
              "name": "_dex",
              "type": "address"
            }
          ],
          "name": "setDex",
          "outputs": [],
          "payable": false,
          "stateMutability": "nonpayable",
          "type": "function"
        },
        {
          "constant": false,
          "inputs": [
            {
              "name": "_id",
              "type": "uint256"
            }
          ],
          "name": "runAuction",
          "outputs": [],
          "payable": false,
          "stateMutability": "nonpayable",
          "type": "function"
        },
        {
          "constant": false,
          "inputs": [],
          "name": "settle",
          "outputs": [
            {
              "name": "",
              "type": "bool"
            }
          ],
          "payable": false,
          "stateMutability": "nonpayable",
          "type": "function"
        }
    ]);

    var tokenContract = web3.eth.contract([
        {
          "constant": true,
          "inputs": [
            {
              "name": "_interfaceId",
              "type": "bytes4"
            }
          ],
          "name": "supportsInterface",
          "outputs": [
            {
              "name": "",
              "type": "bool"
            }
          ],
          "payable": false,
          "stateMutability": "view",
          "type": "function"
        },
        {
          "constant": true,
          "inputs": [],
          "name": "name",
          "outputs": [
            {
              "name": "",
              "type": "string"
            }
          ],
          "payable": false,
          "stateMutability": "view",
          "type": "function"
        },
        {
          "constant": true,
          "inputs": [
            {
              "name": "_tokenId",
              "type": "uint256"
            }
          ],
          "name": "getApproved",
          "outputs": [
            {
              "name": "",
              "type": "address"
            }
          ],
          "payable": false,
          "stateMutability": "view",
          "type": "function"
        },
        {
          "constant": false,
          "inputs": [
            {
              "name": "_to",
              "type": "address"
            },
            {
              "name": "_tokenId",
              "type": "uint256"
            }
          ],
          "name": "approve",
          "outputs": [],
          "payable": false,
          "stateMutability": "nonpayable",
          "type": "function"
        },
        {
          "constant": true,
          "inputs": [],
          "name": "totalSupply",
          "outputs": [
            {
              "name": "",
              "type": "uint256"
            }
          ],
          "payable": false,
          "stateMutability": "view",
          "type": "function"
        },
        {
          "constant": true,
          "inputs": [],
          "name": "InterfaceId_ERC165",
          "outputs": [
            {
              "name": "",
              "type": "bytes4"
            }
          ],
          "payable": false,
          "stateMutability": "view",
          "type": "function"
        },
        {
          "constant": false,
          "inputs": [
            {
              "name": "_from",
              "type": "address"
            },
            {
              "name": "_to",
              "type": "address"
            },
            {
              "name": "_tokenId",
              "type": "uint256"
            }
          ],
          "name": "transferFrom",
          "outputs": [],
          "payable": false,
          "stateMutability": "nonpayable",
          "type": "function"
        },
        {
          "constant": true,
          "inputs": [
            {
              "name": "_owner",
              "type": "address"
            },
            {
              "name": "_index",
              "type": "uint256"
            }
          ],
          "name": "tokenOfOwnerByIndex",
          "outputs": [
            {
              "name": "",
              "type": "uint256"
            }
          ],
          "payable": false,
          "stateMutability": "view",
          "type": "function"
        },
        {
          "constant": false,
          "inputs": [
            {
              "name": "_from",
              "type": "address"
            },
            {
              "name": "_to",
              "type": "address"
            },
            {
              "name": "_tokenId",
              "type": "uint256"
            }
          ],
          "name": "safeTransferFrom",
          "outputs": [],
          "payable": false,
          "stateMutability": "nonpayable",
          "type": "function"
        },
        {
          "constant": true,
          "inputs": [
            {
              "name": "_tokenId",
              "type": "uint256"
            }
          ],
          "name": "exists",
          "outputs": [
            {
              "name": "",
              "type": "bool"
            }
          ],
          "payable": false,
          "stateMutability": "view",
          "type": "function"
        },
        {
          "constant": true,
          "inputs": [
            {
              "name": "_index",
              "type": "uint256"
            }
          ],
          "name": "tokenByIndex",
          "outputs": [
            {
              "name": "",
              "type": "uint256"
            }
          ],
          "payable": false,
          "stateMutability": "view",
          "type": "function"
        },
        {
          "constant": true,
          "inputs": [
            {
              "name": "",
              "type": "uint256"
            }
          ],
          "name": "derivativeData",
          "outputs": [
            {
              "name": "blockCreated",
              "type": "uint256"
            },
            {
              "name": "startHeight",
              "type": "uint256"
            },
            {
              "name": "executeHeight",
              "type": "uint256"
            },
            {
              "name": "gasLimit",
              "type": "uint256"
            },
            {
              "name": "price",
              "type": "uint256"
            },
            {
              "name": "executionMessage",
              "type": "bytes"
            },
            {
              "name": "executionAddress",
              "type": "address"
            }
          ],
          "payable": false,
          "stateMutability": "view",
          "type": "function"
        },
        {
          "constant": true,
          "inputs": [
            {
              "name": "_tokenId",
              "type": "uint256"
            }
          ],
          "name": "ownerOf",
          "outputs": [
            {
              "name": "",
              "type": "address"
            }
          ],
          "payable": false,
          "stateMutability": "view",
          "type": "function"
        },
        {
          "constant": true,
          "inputs": [
            {
              "name": "_owner",
              "type": "address"
            }
          ],
          "name": "balanceOf",
          "outputs": [
            {
              "name": "",
              "type": "uint256"
            }
          ],
          "payable": false,
          "stateMutability": "view",
          "type": "function"
        },
        {
          "constant": true,
          "inputs": [],
          "name": "symbol",
          "outputs": [
            {
              "name": "",
              "type": "string"
            }
          ],
          "payable": false,
          "stateMutability": "view",
          "type": "function"
        },
        {
          "constant": false,
          "inputs": [
            {
              "name": "_to",
              "type": "address"
            },
            {
              "name": "_approved",
              "type": "bool"
            }
          ],
          "name": "setApprovalForAll",
          "outputs": [],
          "payable": false,
          "stateMutability": "nonpayable",
          "type": "function"
        },
        {
          "constant": false,
          "inputs": [
            {
              "name": "_from",
              "type": "address"
            },
            {
              "name": "_to",
              "type": "address"
            },
            {
              "name": "_tokenId",
              "type": "uint256"
            },
            {
              "name": "_data",
              "type": "bytes"
            }
          ],
          "name": "safeTransferFrom",
          "outputs": [],
          "payable": false,
          "stateMutability": "nonpayable",
          "type": "function"
        },
        {
          "constant": true,
          "inputs": [
            {
              "name": "_tokenId",
              "type": "uint256"
            }
          ],
          "name": "tokenURI",
          "outputs": [
            {
              "name": "",
              "type": "string"
            }
          ],
          "payable": false,
          "stateMutability": "view",
          "type": "function"
        },
        {
          "constant": true,
          "inputs": [
            {
              "name": "_owner",
              "type": "address"
            },
            {
              "name": "_operator",
              "type": "address"
            }
          ],
          "name": "isApprovedForAll",
          "outputs": [
            {
              "name": "",
              "type": "bool"
            }
          ],
          "payable": false,
          "stateMutability": "view",
          "type": "function"
        },
        {
          "inputs": [],
          "payable": false,
          "stateMutability": "nonpayable",
          "type": "constructor"
        },
        {
          "anonymous": false,
          "inputs": [
            {
              "indexed": true,
              "name": "id",
              "type": "uint256"
            },
            {
              "indexed": false,
              "name": "startHeight",
              "type": "uint256"
            },
            {
              "indexed": false,
              "name": "executeHeight",
              "type": "uint256"
            },
            {
              "indexed": false,
              "name": "gasLimit",
              "type": "uint256"
            }
          ],
          "name": "DerivativeCreated",
          "type": "event"
        },
        {
          "anonymous": false,
          "inputs": [
            {
              "indexed": true,
              "name": "id",
              "type": "uint256"
            },
            {
              "indexed": true,
              "name": "miner",
              "type": "address"
            },
            {
              "indexed": true,
              "name": "taker",
              "type": "address"
            },
            {
              "indexed": false,
              "name": "executed",
              "type": "bool"
            }
          ],
          "name": "DerivativeSettled",
          "type": "event"
        },
        {
          "anonymous": false,
          "inputs": [
            {
              "indexed": true,
              "name": "_from",
              "type": "address"
            },
            {
              "indexed": true,
              "name": "_to",
              "type": "address"
            },
            {
              "indexed": true,
              "name": "_tokenId",
              "type": "uint256"
            }
          ],
          "name": "Transfer",
          "type": "event"
        },
        {
          "anonymous": false,
          "inputs": [
            {
              "indexed": true,
              "name": "_owner",
              "type": "address"
            },
            {
              "indexed": true,
              "name": "_approved",
              "type": "address"
            },
            {
              "indexed": true,
              "name": "_tokenId",
              "type": "uint256"
            }
          ],
          "name": "Approval",
          "type": "event"
        },
        {
          "anonymous": false,
          "inputs": [
            {
              "indexed": true,
              "name": "_owner",
              "type": "address"
            },
            {
              "indexed": true,
              "name": "_operator",
              "type": "address"
            },
            {
              "indexed": false,
              "name": "_approved",
              "type": "bool"
            }
          ],
          "name": "ApprovalForAll",
          "type": "event"
        },
        {
          "constant": false,
          "inputs": [
            {
              "name": "_startHeight",
              "type": "uint256"
            },
            {
              "name": "_executeHeight",
              "type": "uint256"
            },
            {
              "name": "_gasLimit",
              "type": "uint256"
            }
          ],
          "name": "issue",
          "outputs": [
            {
              "name": "",
              "type": "uint256"
            }
          ],
          "payable": true,
          "stateMutability": "payable",
          "type": "function"
        },
        {
          "constant": false,
          "inputs": [
            {
              "name": "_id",
              "type": "uint256"
            }
          ],
          "name": "salePrice",
          "outputs": [],
          "payable": true,
          "stateMutability": "payable",
          "type": "function"
        },
        {
          "constant": false,
          "inputs": [
            {
              "name": "_id",
              "type": "uint256"
            },
            {
              "name": "_executionAddress",
              "type": "address"
            }
          ],
          "name": "setExecutionAddress",
          "outputs": [],
          "payable": false,
          "stateMutability": "nonpayable",
          "type": "function"
        },
        {
          "constant": false,
          "inputs": [
            {
              "name": "_id",
              "type": "uint256"
            },
            {
              "name": "_executionMessage",
              "type": "bytes"
            }
          ],
          "name": "setExecutionMessage",
          "outputs": [],
          "payable": false,
          "stateMutability": "nonpayable",
          "type": "function"
        },
        {
          "constant": false,
          "inputs": [
            {
              "name": "_id",
              "type": "uint256"
            }
          ],
          "name": "settle",
          "outputs": [
            {
              "name": "",
              "type": "bool"
            }
          ],
          "payable": false,
          "stateMutability": "nonpayable",
          "type": "function"
        }
    ]);

    var protocolInstance = ProtocolContract.at(PROTOCOL_ADDRESS);

    var tokenInstance = tokenContract.at(TOKEN_ADDRESS);

    web3.eth.filter('latest').watch(function(error, blockHash){
        if(error){
            console.log(error);
        }else{
            //console.log(blockHash);
            var block = web3.eth.getBlock(blockHash);
            //console.log(block);
            t.onNewBlock(block);
        }
    });

    var filter = protocolInstance.allEvents({
        fromBlock: 0,
        toBlock: 'latest',
        topics: [
            web3.sha3('CreatedGasFuture(uint256)')
        ]
    });
    filter.watch(function(error, result){
        if (!error){
            //console.log(result);
            if(result.event == 'CreatedGasFuture'){
                var id = result.args.id.toNumber();
                //console.log('token id = '+ id);
                var data = tokenInstance.derivativeData.call(id);
                //console.log(data);
                c.onCreatedGasFuture(data);
                t.onCreatedGasFuture(data);
            }
        }
    });
}

window.addEventListener('load',function(){
  c.onLoad();
  t.onLoad();
  watchEvents();
});

var c = new Chart();
var t = new Table();

document.body.appendChild(c.createComponent());
document.body.appendChild(t.createComponent());
