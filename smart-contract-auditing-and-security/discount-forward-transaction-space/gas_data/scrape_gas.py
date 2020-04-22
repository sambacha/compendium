""" WARNING CRAP CODE BELOW """

from web3 import Web3
import os, binascii

OUT = "gas_data"
WRITE_EVERY = 10000 #writeout every 1k blocks

START_BLOCK = 5965500 #Jul-14-2018 11:34:05 PM +UTC
END_BLOCK = 0

curr_block = START_BLOCK

my_provider = Web3.IPCProvider('/home/geth/parity_mainnet/jsonrpc.ipc')
w3 = Web3(my_provider)
outhandle = open(OUT, "w")
outhandle.write("blocknum,txhash,value,gas,gasprice")
outhandle.flush()
buffer = ""

while curr_block >= END_BLOCK:
    while True:
        try:
            block = w3.eth.getBlock(curr_block, full_transactions=True)
            break
        except:
            pass
    for tx in block['transactions']:
        outstr = (str(curr_block) + "," + str(binascii.hexlify(tx['hash'])).replace("b'", "").replace("'", "") + "," + str(tx['value']) + "," + str(tx['gas']) + "," + str(tx['gasPrice']))
        buffer += outstr + "\n"

    if curr_block % WRITE_EVERY == 0:
        print("Writing " + str(curr_block) + "\n")
        outhandle.write(buffer)
        buffer = ""
        outhandle.flush()

    print("Done", curr_block)
    curr_block -= 100

