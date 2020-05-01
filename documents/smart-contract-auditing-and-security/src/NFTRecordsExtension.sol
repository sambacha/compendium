pragma solidity ^0.4.24;
import "./NFTStandard.sol";

contract NFTExtended is NFTGetters {
    using SafeMath for uint;

    bytes4 internal constant TRANSFER_SEL = bytes4(keccak256('Transfer(address,address,uint256)'));
    bytes4 internal constant CREATE_OWNER_SEL = bytes4(keccak256('CreateRecordOwner(bytes32,address)'));
    bytes4 internal constant CREATE_PARTICIPANT_SEL = bytes4(keccak256('CreateRecordParticipant(bytes32,address)'));
    bytes4 internal constant VERSION_SIGNED_SEL = bytes4(keccak256('VersionRecord(bytes32,bytes32)'));
    string internal constant GETH_STRING = "\x19Ethereum Signed Message:\n32";

    event RecordCreated(uint indexed locator, address owner, address participant);
    event RecordUpdated(uint indexed record, uint indexed updated, address owner);

	using NFTLib for NFTLib.NFT;


	/**
     * @dev Transfers an NFT token if the message representing the transaction was signed by _from
     * @param _from The address that should own NFT at the start of the transaction
     * @param _to The recipient of the transfer
     * @param _tokenId The id of the token to be transferred
     * @param _sig The signature that may authorize the transfer
     */
	function signedTransfer(address _from, address _to, uint _tokenId, bytes _sig) external {
		NFTLib.NFT storage nft = getBase();
		address owner = nft.ownerOf(_tokenId);
		// _from must be the owner, and owner and _to must be nonzero addresses
        require(owner == _from && owner != 0 && _to != 0);
        uint nonce = nft.nonceOf(_from);
        // Construct the hash of the message that should have been signed
        bytes32 signHash = getHash(nonce, TRANSFER_SEL, _from, _to, bytes32(_tokenId));

        // Ensure that the `_from` address signed the correct message
        require(ecrecoverWithSig(signHash, _sig) == _from);
        // Increment the from address's nonce
    	nft.setNonceOf(_from, nonce.add(1));
        // Transfer the token and emit event
        _transferFrom(nft, _from, _to, _tokenId);
        emit Transfer(_from, _to, _tokenId);
	}

	function createRecord(bytes32 _record, address _participant, bytes _sOwner, bytes _sPart) external {
		NFTLib.NFT storage nft = getBase();
		require(nft.doesExist(uint(_record)) == false);

		uint ownerNonce = nft.nonceOf(msg.sender);
		uint partNonce = nft.nonceOf(_participant);
		bytes32 ownerSignHash = getHash(ownerNonce, CREATE_OWNER_SEL, msg.sender, _participant, _record);
		bytes32 partSignHash = getHash(partNonce, CREATE_PARTICIPANT_SEL, msg.sender, _participant, _record);

		require(ecrecoverWithSig(ownerSignHash, _sOwner) == msg.sender);
		require(ecrecoverWithSig(partSignHash, _sPart) == _participant);

		nft.tokens.exists[uint(_record)] = true;
		nft.addToOwned(msg.sender, uint(_record));
	}

	 function versionRecord(bytes32 _record, bytes32 _updated) external{
		 NFTLib.NFT storage nft = getBase();
		 require((msg.sender == nft.ownerOf(uint(_record))) || (msg.sender == nft.approvedFor(uint(_record))),
		 					"The sender must be the owner");
		 require(!nft.doesExist(uint(_updated)), "Record Already Exists");

		 nft.tokens.exists[uint(_updated)] = true;
 		 nft.addToOwned(msg.sender, uint(_updated));
		 nft.removeFromOwned(msg.sender, uint(_record));
		 nft.tokens.URIOf[uint(_updated)] = _record;
	 }

	 function versionRecordSigned(bytes32 _record, bytes32 _updated, bytes _sig) external{
		NFTLib.NFT storage nft = getBase();
		require(!nft.doesExist(uint(_updated)), "Record Already Exists");
		address _owner = nft.ownerOf(uint(_record));

		bytes4 sel = VERSION_SIGNED_SEL;
        uint owner_nonce = nft.nonceOf(_owner);
        bytes32 message_hash;
		assembly{
		 	let free_ptr := mload(0x40)
			// Place the nonce, address of this contract, selector, _record, and _updated at the free memory pointer
			mstore(free_ptr, owner_nonce)
			mstore(add(free_ptr, 0x20), address)
			mstore(add(free_ptr, 0x40), sel)
			mstore(add(free_ptr, 0x44), _record)
			mstore(add(free_ptr, 0x64), _updated)
			// Compute the hash of the message
			message_hash := keccak256(free_ptr, 0x84)
			// Zero out the memory that was placed to compute the hash
			codecopy(free_ptr, codesize, 0x84)
		}
		message_hash = keccak256(abi.encodePacked(GETH_STRING, message_hash));
		address signer = ecrecoverWithSig(message_hash, _sig);
		require((_owner == signer) || (nft.approvedFor(uint(_record)) == signer),
		 					"Must be singed by the owner or approved address");

		nft.tokens.exists[uint(_updated)] = true;
 		nft.addToOwned(msg.sender, uint(_updated));
		nft.removeFromOwned(msg.sender, uint(_record));
		nft.tokens.URIOf[uint(_updated)] = _record;
	 }

	function getHash(uint _nonce, bytes4 _func, address _a, address _b, bytes32 _record) internal view returns (bytes32 h) {
		assembly {
			let ptr := mload(0x40)
			mstore(ptr, _nonce)
			mstore(add(0x20, ptr), address)
			mstore(add(0x40, ptr), _func)
			mstore(add(0x44, ptr), _a)
			mstore(add(0x64, ptr), _b)
			mstore(add(0x84, ptr), _record)
			h := keccak256(ptr, 0xa4)
		}
		h = keccak256(abi.encodePacked(GETH_STRING, h));
	}

	function ecrecoverWithSig(bytes32 _hash, bytes memory _sig) internal pure returns (address) {
		bytes32 r;
  	bytes32 s;
  	uint8 v;
		require(_sig.length == 65);
  	assembly {
    	s := mload(add(_sig, 0x20))
    	r := mload(add(_sig, 0x40))
    	v := mload(add(_sig, 0x41)) // NOTE - should we clean this?
  	}
  	if(v < 27){
    	v += 27;
  	}
  	return ecrecover(_hash, v, s, r);
	}
}
