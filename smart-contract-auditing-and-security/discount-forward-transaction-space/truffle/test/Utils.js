module.exports = function(artifact){
    return {
        mineBlock: async function (){
            await artifact.web3.currentProvider.send({
                jsonrpc: '2.0',
                method: 'evm_mine',
                params: [],
                id: 0
            });
        },
        getBalance: function (address){
            return new Promise((resolve, reject) => {
                artifact.web3.eth.getBalance(address, function(err,balance){
                    if(err){
                        reject(err);
                    }else{
                        resolve(balance);
                    }
                });
            });
        },
        sendTransaction: function(config){
            return new Promise((resolve, reject) => {
                artifact.web3.eth.sendTransaction(config, function(err,receipt){
                    if(err){
                        reject(err);
                    }else{
                        resolve(receipt);
                    }
                });
            });
        },
        log: function(msg){
            console.log("        " + msg);
        }
    };
};