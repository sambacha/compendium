pragma solidity ^0.4.10;

import "openzeppelin-solidity/contracts/math/SafeMath.sol";

library DexLib {

    using SafeMath for uint;

    uint constant MAXORDER = 2**12;
    uint constant MAXTOKEN = 2**7;
    uint constant MAXBATCH = 2**7;

    enum OrderType {Bid, Ask}

    event SettledOrder(string tokenA, string tokenB, uint price, uint volume);

    //order fee not implemented!!!

    struct Order {
        uint volume;
        uint price;
        address trader;
        bytes32 nonce;
        uint timestamp;
    }

    struct OrderBook {
        uint numOrder;
        Order[MAXORDER] orders;
    }

    struct Batch {
        uint batchHead; //the actual head - 1
        uint batchTail; //the actual tail
        uint[MAXBATCH] timestamp;
        OrderBook[MAXBATCH] bidBook;
        OrderBook[MAXBATCH] askBook;
    }

    struct Token {
        string symbolName;
        address tokenAddr;
        Batch[MAXTOKEN] batches;
    }

    struct NFToken {
        string symbolName;
        address tokenAddr;
        mapping (uint => bool) existing;
        mapping (uint => uint8) tradingToken;
        mapping (uint => Batch) batches;
        mapping (uint => address) owner;
    }

    struct Dex {
        uint8 numToken;
        uint8 numNFToken;
        Token[MAXTOKEN] tokens;
        NFToken[MAXTOKEN] nftokens;
        mapping (string => uint8) tokenIndex;
        mapping (string => uint8) nftokenIndex;

        mapping (address => mapping (uint8 => uint)) balance;
        mapping (address => mapping (uint8 => uint)) freeBal;

        address admin;
        uint lenPeriod;
        uint staPeriod;
    }

    function initOrder(Order storage self, address trader, uint volume, uint price, 
            bytes32 nonce, uint timestamp) internal {
        self.trader = trader;
        self.volume = volume;
        self.price = price;
        self.nonce = nonce;
        self.timestamp = timestamp;
    }

    function copyOrder(Order storage self, Order storage origin) internal{
        initOrder(self, origin.trader, origin.volume, origin.price, origin.nonce, origin.timestamp);
    }

    function initBatch(Batch storage self) internal {
        self.batchHead = 0;
        self.batchTail = 0;
    }

    function initToken(Token storage self, address addr, string name) internal {
        self.symbolName = name;
        self.tokenAddr = addr;

        for (uint i = 0; i < MAXTOKEN; i++) {
            initBatch(self.batches[i]);
        }
    }

    function initNFToken(NFToken storage self, address addr, string name) internal {
        self.symbolName = name;
        self.tokenAddr = addr;
    }

    function initDex (Dex storage self, address admin_, uint lenPeriod) internal {
        self.admin = admin_;
        self.lenPeriod = lenPeriod;
        self.staPeriod = block.number;

        self.numToken = 1;        
        initToken(self.tokens[self.numToken], 0, "ETH");
        self.tokenIndex["ETH"] = self.numToken;

        self.numNFToken = 0;
    }

    function updateBatchIndex(uint idx) public pure returns (uint) {
        if (idx == MAXBATCH - 1) {
            return 0;
        } else {
            return idx + 1;
        }
    }

    function currentPeriod(Dex storage dex, uint cur) public view returns(uint) {
        return ((cur - dex.staPeriod) / dex.lenPeriod) * dex.lenPeriod + dex.staPeriod;
    }

    function currentPeriod(uint period, uint sta, uint cur) public view returns (uint) {
        return ((cur - sta) / period) * period + sta;
    }

    /*    function updatePeriod(Dex storage self) public {
    //Handle who is responsible for gas cost in this function!!!
    if (self.curPeriod + self.lenPeriod <= block.number) {
    self.curPeriod += self.lenPeriod;

    for (uint i = 0; i < self.numToken; i++) {
    for (uint j = 0; j < i; j++) {
    self.tokens[i].batches[j].batchTail = updateBatchIndex(
    self.tokens[i].batches[j].batchTail);
    self.tokens[i].batches[j].timeTail += self.lenPeriod;
    self.tokens[i].batches[j].bidBook[self.tokens[i].batches[j].batchTail].numOrder = 0;
    self.tokens[i].batches[j].askBook[self.tokens[i].batches[j].batchTail].numOrder = 0;
    }
    }
    }
    }
     */

    //event OrderNumber(string src, uint num);

    function insertOrder(Batch storage self, uint timestamp, Order storage order, 
            OrderType t) internal {
        if (self.batchHead == self.batchTail || self.timestamp[self.batchTail] < timestamp) {
            self.batchTail = updateBatchIndex(self.batchTail);
            self.timestamp[self.batchTail] = timestamp;
            self.bidBook[self.batchTail].numOrder = 0;
            self.askBook[self.batchTail].numOrder = 0;
        }
        if (t == OrderType.Bid) {
            copyOrder(self.bidBook[self.batchTail].orders[self.bidBook[self.batchTail].numOrder], 
                    order);
            self.bidBook[self.batchTail].numOrder++;
            //emit OrderNumber("inserOrder bid", self.bidBook[self.batchTail].numOrder);
        } else {
            copyOrder(self.askBook[self.batchTail].orders[self.askBook[self.batchTail].numOrder], 
                    order);
            self.askBook[self.batchTail].numOrder++;
            //emit OrderNumber("insertOrder ask",self.bidBook[self.batchTail].numOrder);
        }
    }

    //check whether priceA < priceB
    function compareOrder(Order storage orderA, Order storage orderB) 
        public view returns(bool) {
            return (orderA.price < orderB.price || 
                    (orderA.price == orderB.price && orderA.nonce < orderB.nonce));
        }

    //bids price in descending order, asks price in ascending order
    function checkSortedBook(OrderBook storage self, uint[] sortedOrder, OrderType t)
        public view returns(bool) {
            if (self.numOrder != sortedOrder.length) return false;
            for (uint i = 1; i < sortedOrder.length; i++) {
                if (sortedOrder[i] == sortedOrder[i - 1]) return false;
                if (t == OrderType.Bid) {
                    if (compareOrder(self.orders[sortedOrder[i - 1]], 
                                self.orders[sortedOrder[i]])) return false;
                } else {
                    if (compareOrder(self.orders[sortedOrder[i]],
                                self.orders[sortedOrder[i - 1]])) return false;
                }
            }
            return true;
        }

    function checkSorting(Batch storage self, uint[] sortedBid, uint[] sortedAsk) 
        public view returns(bool) {
            uint next = updateBatchIndex(self.batchHead);
            return (checkSortedBook(self.bidBook[next], sortedBid, OrderType.Bid)
                    && checkSortedBook(self.askBook[next], sortedAsk, OrderType.Ask));
        }

    function sortOrderBook(OrderBook storage self, OrderType t) internal returns(uint[]) {
        
        //emit OrderNumber("sortOrderBook", self.numOrder);

        uint[] memory sortedOrder = new uint[](MAXORDER);
        for (uint i = 0; i < self.numOrder; i++) {
            sortedOrder[i] = i;
        }

        //emit Sort("sortOrderBook:init",sortedOrder);

        uint k;
        for (i = 0; i < self.numOrder; i++) {
            for (uint j = i; j < self.numOrder; j++) {
                if (t == OrderType.Bid) {
                    if (compareOrder(self.orders[sortedOrder[i]], self.orders[sortedOrder[j]])) {
                        k = sortedOrder[i];
                        sortedOrder[i] = sortedOrder[j];
                        sortedOrder[j] = k;
                    }
                } else {
                    if (!compareOrder(self.orders[sortedOrder[i]], self.orders[sortedOrder[j]])) {
                        k = sortedOrder[i];
                        sortedOrder[i] = sortedOrder[j];
                        sortedOrder[j] = k;                        
                    }
                }
            }
        }

        //emit Sort("sortOrderBook:after",sortedOrder);

        return sortedOrder;
    }

    function min(uint a, uint b) public pure returns(uint) {
        if (a < b) return a; else return b;
    }

    function firstPriceAuction(Dex storage dex, uint[] sortedBid, uint[] sortedAsk, 
            uint8 tokenA, uint8 tokenB) internal {
        Batch storage self = dex.tokens[tokenA].batches[tokenB];
        uint cur = updateBatchIndex(self.batchHead);
        uint i = 0;
        uint j = 0;
        Order storage orderBid;
        if (i < self.bidBook[cur].numOrder) orderBid = self.bidBook[cur].orders[sortedBid[i]];
        Order storage orderAsk;
        if (j < self.askBook[cur].numOrder) orderAsk = self.askBook[cur].orders[sortedAsk[j]];

        for (; i < self.bidBook[cur].numOrder && j < self.askBook[cur].numOrder;) {
            if (orderBid.price >= orderAsk.price) {
                //how to set the settlement price when bid and ask prices are not equal???
                uint price = (orderBid.price + orderAsk.price) / 2;
                uint volume = min(orderBid.volume, orderAsk.volume);

                //buy (volume) "tokenTo" with (volume * price) "tokenFrom" [tokenFrom][tokenTo] 
                dex.balance[orderBid.trader][tokenA] = dex.balance[orderBid.trader][tokenA].sub(volume.mul(price));
                dex.balance[orderBid.trader][tokenB] = dex.balance[orderBid.trader][tokenB].add(volume);
                dex.freeBal[orderBid.trader][tokenB] = dex.freeBal[orderBid.trader][tokenB].add(volume);
                orderBid.volume -= volume;
                if (orderBid.volume == 0) {
                    i++;
                    if (i < self.bidBook[cur].numOrder) orderBid = self.bidBook[cur].orders[sortedBid[i]];
                }

                //sell (volume) "tokenFrom" for (volume * price) "tokenTo" [tokenTo][tokenFrom]
                dex.balance[orderAsk.trader][tokenA] = dex.balance[orderAsk.trader][tokenA].add(volume.mul(price));
                dex.freeBal[orderAsk.trader][tokenA] = dex.freeBal[orderAsk.trader][tokenA].add(volume.mul(price));
                dex.balance[orderAsk.trader][tokenB] = dex.balance[orderAsk.trader][tokenB].sub(volume);
                orderAsk.volume -= volume;
                if (orderAsk.volume == 0) {
                    j++;
                    if (j < self.askBook[cur].numOrder) orderAsk = self.askBook[cur].orders[sortedAsk[j]];
                }

                emit SettledOrder(dex.tokens[tokenA].symbolName, dex.tokens[tokenB].symbolName, price, volume);
            } else {
                break;
            }
        }

        if (i < self.bidBook[cur].numOrder || j < self.askBook[cur].numOrder) {
            if (cur == self.batchTail) {
                self.batchTail = updateBatchIndex(self.batchTail);
                self.timestamp[self.batchTail] = currentPeriod(dex, block.number);
                self.bidBook[self.batchTail].numOrder = 0;
                self.askBook[self.batchTail].numOrder = 0;
            }
            uint next = updateBatchIndex(cur);
            for (; i < self.bidBook[cur].numOrder; i++) {
                orderBid = self.bidBook[cur].orders[sortedBid[i]];
                copyOrder(self.bidBook[next].orders[self.bidBook[next].numOrder], orderBid);
                self.bidBook[next].numOrder++;
            }
            for (; j < self.askBook[cur].numOrder; j++) {
                orderAsk = self.askBook[cur].orders[sortedAsk[j]];
                copyOrder(self.askBook[next].orders[self.askBook[next].numOrder], orderAsk);
                self.askBook[next].numOrder++;
            }

        }
        self.batchHead = cur;
    }    

    function firstPriceAuctionNFT(Dex storage dex, uint[] sortedBid, uint[] sortedAsk, 
            uint8 nft, uint tokenId) internal returns(uint) {
        uint8 ft = dex.nftokens[nft].tradingToken[tokenId];

        Batch storage self = dex.nftokens[nft].batches[tokenId];
        uint cur = updateBatchIndex(self.batchHead);
        if (self.bidBook[cur].numOrder > 0 && self.askBook[cur].numOrder > 0 &&
            self.bidBook[cur].orders[sortedBid[0]].price >= 
            self.askBook[cur].orders[sortedAsk[0]].price) {
            Order storage orderBid = self.bidBook[cur].orders[sortedBid[0]];
            Order storage orderAsk = self.askBook[cur].orders[sortedAsk[0]];

            //how to set the settlement price when bid and ask prices are not equal???
            uint price = orderBid.price;

            //buy 1 NFT with (price) FT [NFT][FT] 
            dex.balance[orderBid.trader][ft] = dex.balance[orderBid.trader][ft].sub(price);
            dex.nftokens[nft].owner[tokenId] = orderBid.trader;

            //sell 1 NFT for (price) FT [NFT][FT]
            dex.balance[orderAsk.trader][ft] = dex.balance[orderAsk.trader][ft].add(price);

            emit SettledOrder(dex.nftokens[nft].symbolName, dex.tokens[ft].symbolName, price, tokenId);

            dex.nftokens[nft].tradingToken[tokenId] = 0;
            initBatch(self);

            return price;
        } else {
            if (0 < self.bidBook[cur].numOrder || 0 < self.askBook[cur].numOrder) {
                if (cur == self.batchTail) {
                    self.batchTail = updateBatchIndex(self.batchTail);
                    self.timestamp[self.batchTail] = currentPeriod(dex.lenPeriod, self.timestamp[cur], block.number);
                    self.bidBook[self.batchTail].numOrder = 0;
                    self.askBook[self.batchTail].numOrder = 0;
                }
                uint next = updateBatchIndex(cur);
                uint i;
                for (i = 0; i < self.bidBook[cur].numOrder; i++) {
                    orderBid = self.bidBook[cur].orders[sortedBid[i]];
                    copyOrder(self.bidBook[next].orders[self.bidBook[next].numOrder], orderBid);
                    self.bidBook[next].numOrder++;
                }
                for (i = 0; i < self.askBook[cur].numOrder; i++) {
                    orderAsk = self.askBook[cur].orders[sortedAsk[i]];
                    copyOrder(self.askBook[next].orders[self.askBook[next].numOrder], orderAsk);
                    self.askBook[next].numOrder++;
                }

            }
            self.batchHead = cur;
            return 0;
        }
    }    

    function settle(Dex storage dex, uint[] sortedBid, uint[] sortedAsk, 
            uint8 tokenA, uint8 tokenB) internal {
        Batch storage self = dex.tokens[tokenA].batches[tokenB];
        require(self.batchHead != self.batchTail);
        require(self.timestamp[updateBatchIndex(self.batchHead)] + dex.lenPeriod <= block.number);

        require(checkSorting(self, sortedBid, sortedAsk));
        firstPriceAuction(dex, sortedBid, sortedAsk, tokenA, tokenB);
    }

    function settleNFT(Dex storage dex, uint[] sortedBid, uint[] sortedAsk, 
            uint8 nft, uint tokenId) internal {
        Batch storage self = dex.nftokens[nft].batches[tokenId];
        require(self.batchHead != self.batchTail);
        require(self.timestamp[updateBatchIndex(self.batchHead)] + dex.lenPeriod <= block.number);

        require(checkSorting(self, sortedBid, sortedAsk));
        firstPriceAuctionNFT(dex, sortedBid, sortedAsk, nft, tokenId);
    }

    //event Sort(string src, uint[] arr);
    event Blocknumber(uint a, uint period, uint blocknumber);

    function settleNFT(Dex storage dex, uint8 nft, uint tokenId) internal returns(uint) {
        Batch storage self = dex.nftokens[nft].batches[tokenId];
        require(self.batchHead != self.batchTail);
        require(self.timestamp[updateBatchIndex(self.batchHead)] + dex.lenPeriod <= block.number);
        emit Blocknumber(self.timestamp[updateBatchIndex(self.batchHead)], dex.lenPeriod, block.number);

        uint next = updateBatchIndex(self.batchHead);
        uint[] memory sortedBid = sortOrderBook(self.bidBook[next], OrderType.Bid);
        //emit Sort("settleNFT", sortedBid);
        uint[] memory sortedAsk = sortOrderBook(self.askBook[next], OrderType.Ask);
        return firstPriceAuctionNFT(dex, sortedBid, sortedAsk, nft, tokenId);
    }

}
