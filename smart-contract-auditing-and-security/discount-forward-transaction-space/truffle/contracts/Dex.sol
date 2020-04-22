pragma solidity ^0.4.10;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";
import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";

import "./DexLib.sol";

contract Dex {

    using DexLib for DexLib.Dex;
    using DexLib for DexLib.Token;
    using DexLib for DexLib.NFToken;
    using DexLib for DexLib.Batch;
    using DexLib for DexLib.Order;
    using SafeMath for uint;
    
    DexLib.Dex dex;

    event TokenAdded(string symbolName, address addr, uint idx);
    event Deposit(string symbolName, address user, uint value, uint balance);
    event Withdrawal(string symbolName, address user, uint value, uint balance);
    event NewOrder(string tokenA, string tokenB, string orderType, uint price, uint volume);
    event SettledOrder(string tokenA, string tokenB, uint price, uint volume);

    
    
    function () public {
        revert();
    }
    
    constructor (address admin, uint lenPeriod) public {
        dex.initDex(admin, lenPeriod);
    }

    function changeAdmin (address admin) public {
        require(msg.sender == dex.admin);
        dex.admin = admin;
    }
    
    function changePeriod (uint lenPeriod) public {
        require(msg.sender == dex.admin);
        dex.lenPeriod = lenPeriod;
        //need to modify to change in the next period!!!
    }

    //check if the token is known
    function checkToken(string token) public view returns (bool) {
        return (dex.tokenIndex[token] != 0 || dex.nftokenIndex[token] != 0);
    }

    function auctionPeriod(string token, uint tokenId) public view returns (uint, uint) {
        require(dex.nftokenIndex[token] != 0);
        require(dex.nftokens[dex.nftokenIndex[token]].existing[tokenId] == true);
        require(dex.nftokens[dex.nftokenIndex[token]].tradingToken[tokenId] != 0);

        return (dex.nftokens[dex.nftokenIndex[token]].batches[tokenId].timestamp[
            DexLib.updateBatchIndex(dex.nftokens[dex.nftokenIndex[token]].batches[tokenId].batchHead)],
            dex.nftokens[dex.nftokenIndex[token]].batches[tokenId].timestamp[
            DexLib.updateBatchIndex(dex.nftokens[dex.nftokenIndex[token]].batches[tokenId].batchHead)] + dex.lenPeriod);
    }
        
    function addToken (address addr, string name) public {
        require(msg.sender == dex.admin);
        require(!checkToken(name));
        dex.numToken++;
        dex.tokens[dex.numToken].initToken(addr, name);
        dex.tokenIndex[name] = dex.numToken;
        
        emit TokenAdded(name, addr, dex.numToken);
    }

    function addNFToken (address addr, string name) public {
        //require(msg.sender == dex.admin);
        require(!checkToken(name));
        dex.numNFToken++;
        dex.nftokens[dex.numNFToken].initNFToken(addr, name);
        dex.nftokenIndex[name] = dex.numNFToken;

        emit TokenAdded(name, addr, dex.numNFToken);
    }
    

    function depositEther() public payable {
        dex.balance[msg.sender][1] = dex.balance[msg.sender][1].add(msg.value);
        dex.freeBal[msg.sender][1] = dex.freeBal[msg.sender][1].add(msg.value);
        emit Deposit("ETH", msg.sender, msg.value, dex.balance[msg.sender][1]);
    }
    
    function withdrawalEther(uint amount) public {
        require(dex.freeBal[msg.sender][1] >= amount);
        dex.freeBal[msg.sender][1] = dex.freeBal[msg.sender][1].sub(amount);
        dex.balance[msg.sender][1] = dex.balance[msg.sender][1].sub(amount);
        msg.sender.transfer(amount);
        emit Withdrawal("ETH", msg.sender, amount, dex.balance[msg.sender][1]);
    }
    
    function depositToken(string name, uint amount) public {
        require(dex.tokenIndex[name] != 0);
        ERC20 token = ERC20(dex.tokens[dex.tokenIndex[name]].tokenAddr);
        require(token.transferFrom(msg.sender, address(this), amount) == true);
        dex.balance[msg.sender][dex.tokenIndex[name]] = dex.balance[msg.sender][dex.tokenIndex[name]].add(amount);
        dex.freeBal[msg.sender][dex.tokenIndex[name]] = dex.freeBal[msg.sender][dex.tokenIndex[name]].add(amount);
        emit Deposit(dex.tokens[dex.tokenIndex[name]].symbolName, msg.sender, amount, 
            dex.balance[msg.sender][dex.tokenIndex[name]]);
    }
    
    function withdrawalToken(string name, uint amount) public {
        require(dex.tokenIndex[name] != 0);
        require(dex.freeBal[msg.sender][dex.tokenIndex[name]] >= amount);
        ERC20 token = ERC20(dex.tokens[dex.tokenIndex[name]].tokenAddr);
        dex.balance[msg.sender][dex.tokenIndex[name]] = dex.balance[msg.sender][dex.tokenIndex[name]].sub(amount);
        dex.freeBal[msg.sender][dex.tokenIndex[name]] = dex.freeBal[msg.sender][dex.tokenIndex[name]].sub(amount);
        require(token.transfer(msg.sender, amount) == true);
        emit Withdrawal(dex.tokens[dex.tokenIndex[name]].symbolName, msg.sender, amount, 
            dex.balance[msg.sender][dex.tokenIndex[name]]);
    }

    function depositNFToken(string name, uint tokenId) public {
        require(dex.nftokenIndex[name] != 0);
        ERC721 token = ERC721(dex.nftokens[dex.nftokenIndex[name]].tokenAddr);
        token.transferFrom(msg.sender, address(this), tokenId);
        dex.nftokens[dex.nftokenIndex[name]].owner[tokenId] = msg.sender;
        dex.nftokens[dex.nftokenIndex[name]].existing[tokenId] = true;
        dex.nftokens[dex.nftokenIndex[name]].tradingToken[tokenId] = 0;
        dex.nftokens[dex.nftokenIndex[name]].batches[tokenId].initBatch();
        emit Deposit(dex.nftokens[dex.nftokenIndex[name]].symbolName, msg.sender, tokenId, 1);
    }

    function withdrawalNFToken(string name, uint tokenId) public {
        require(dex.nftokenIndex[name] != 0);
        require(dex.nftokens[dex.nftokenIndex[name]].existing[tokenId] == true);
        require(dex.nftokens[dex.nftokenIndex[name]].owner[tokenId] == msg.sender);
        ERC721 token = ERC721(dex.nftokens[dex.nftokenIndex[name]].tokenAddr);
        dex.nftokens[dex.nftokenIndex[name]].existing[tokenId] = false;
        token.transferFrom(address(this), msg.sender, tokenId);
        emit Withdrawal(dex.nftokens[dex.nftokenIndex[name]].symbolName, msg.sender, tokenId, 1);
    }

    //buy (volume) "tokenTo" with (volume * price) "tokenFrom" [tokenFrom][tokenTo] 
    function bidOrderERC20(string tokenFrom, string tokenTo, uint volume, uint price, 
        bytes32 nonce) public {
        require(checkToken(tokenFrom) && checkToken(tokenTo));

        uint8 idxFrom = dex.tokenIndex[tokenFrom];
        uint8 idxTo = dex.tokenIndex[tokenTo];
        require(idxFrom < idxTo); //different for ask

        require(dex.freeBal[msg.sender][idxFrom] >= volume.mul(price));
        DexLib.Order storage order;
        order.initOrder(msg.sender, volume, price, nonce, block.number);
        DexLib.insertOrder(dex.tokens[idxFrom].batches[idxTo], dex.currentPeriod(block.number), 
            order, DexLib.OrderType.Bid);
        dex.freeBal[msg.sender][idxFrom] = dex.freeBal[msg.sender][idxFrom].sub(volume.mul(price));

        emit NewOrder(tokenFrom, tokenTo, "Bid", price, volume);
    }
    
    //sell (volume) "tokenFrom" for (volume * price) "tokenTo" [tokenTo][tokenFrom]
    function askOrderERC20(string tokenFrom, string tokenTo, uint volume, uint price, 
        bytes32 nonce) public {
        require(checkToken(tokenFrom) && checkToken(tokenTo));

        uint8 idxFrom = dex.tokenIndex[tokenFrom];
        uint8 idxTo = dex.tokenIndex[tokenTo];
        require(idxFrom > idxTo); //different for bid

        require(dex.freeBal[msg.sender][idxFrom] >= volume);
        DexLib.Order storage order;
        order.initOrder(msg.sender, volume, price, nonce, block.number);
        DexLib.insertOrder(dex.tokens[idxTo].batches[idxFrom],dex.currentPeriod(block.number), 
            order, DexLib.OrderType.Ask);
        dex.freeBal[msg.sender][idxFrom] = dex.freeBal[msg.sender][idxFrom].sub(volume);

        emit NewOrder(tokenTo, tokenFrom, "Ask", price, volume);
    }

    //buy 1 NFT with (price) FT [NFT][FT] 
    function bidOrderERC721(string nft, string ft, uint tokenId, uint price, bytes32 nonce) public {
        require(dex.nftokenIndex[nft] != 0 && dex.tokenIndex[ft] != 0);

        uint8 idxnft = dex.nftokenIndex[nft];
        uint8 idxft = dex.tokenIndex[ft];

        require(dex.nftokens[idxnft].existing[tokenId] == true);
        require(dex.nftokens[idxnft].tradingToken[tokenId] == idxft);
        require(dex.freeBal[msg.sender][idxft] >= price);
        DexLib.Order storage order;
        order.initOrder(msg.sender, 1, price, nonce, block.number);
        DexLib.insertOrder(dex.nftokens[idxnft].batches[tokenId], 
            DexLib.currentPeriod(dex.lenPeriod, 
                dex.nftokens[idxnft].batches[tokenId].timestamp[DexLib.updateBatchIndex(dex.nftokens[idxnft].batches[tokenId].batchHead)],
                block.number), 
            order, DexLib.OrderType.Bid);
        dex.freeBal[msg.sender][idxft] = dex.freeBal[msg.sender][idxft].sub(price);

        emit NewOrder(nft, ft, "Bid", price, tokenId);
    }
    
    //sell 1 NFT for (price) FT [NFT][FT]
    function askOrderERC721(string nft, string ft, uint tokenId, uint price, bytes32 nonce) public {
        require(dex.nftokenIndex[nft] != 0 && dex.tokenIndex[ft] != 0);

        uint8 idxnft = dex.nftokenIndex[nft];
        uint8 idxft = dex.tokenIndex[ft];

        require(dex.nftokens[idxnft].existing[tokenId] == true);
        require(dex.nftokens[idxnft].owner[tokenId] == msg.sender);
        require(dex.nftokens[idxnft].tradingToken[tokenId] == 0 || 
            dex.nftokens[idxnft].tradingToken[tokenId] == idxft);
        dex.nftokens[idxnft].tradingToken[tokenId] = idxft;
        DexLib.Order storage order;
        order.initOrder(msg.sender, 1, price, nonce, block.number);
        DexLib.insertOrder(dex.nftokens[idxnft].batches[tokenId], block.number, order, DexLib.OrderType.Ask);

        emit NewOrder(nft, ft,  "Ask", price, tokenId);
    }


    //not supporting cancellation yet!!!

    function settleERC20(string tokenA, string tokenB, uint[] sortedBid, uint[] sortedAsk) public {
        require(checkToken(tokenA) && checkToken(tokenB));

        uint8 idxA = dex.tokenIndex[tokenA];
        uint8 idxB = dex.tokenIndex[tokenB];
        require(idxA < idxB);

        dex.settle(sortedBid, sortedAsk, idxA, idxB);
    }

    function settleERC721(string nft, uint tokenId, uint[] sortedBid, uint[] sortedAsk) public {
        require(dex.nftokenIndex[nft] != 0);
        uint8 idxnft = dex.nftokenIndex[nft];

        require(dex.nftokens[idxnft].existing[tokenId] == true);
        require(dex.nftokens[idxnft].tradingToken[tokenId] != 0);

        dex.settleNFT(sortedBid, sortedAsk, idxnft, tokenId);
    }

    //event Sort(string src, uint[] arr);
    //event OrderNumber(string src, uint num);
    //event Blocknumber(uint a, uint period, uint blocknumber);

    function settleERC721(string nft, uint tokenId) public returns (uint) {
        require(dex.nftokenIndex[nft] != 0);
        uint8 idxnft = dex.nftokenIndex[nft];

        require(dex.nftokens[idxnft].existing[tokenId] == true);
        require(dex.nftokens[idxnft].tradingToken[tokenId] != 0);

        return dex.settleNFT(idxnft, tokenId);
    }
}
