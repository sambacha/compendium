pragma solidity ^0.4.24;
import "./SafeMath.sol";

library NFTLib {
    using SafeMath for uint;

	/**
	 * @title Tokens
	 * @dev Token data by id
	 * @param ownerOf Maps a token's id to its current owner
	 * @param approvedFor Maps a token's id to its current approved address
	 * @param URIOf Maps a token's id to its previous version (if it exists)
	 * @param ownerIndexOf Maps a token's id to its index in its owner's owned token list
	 */
	struct Tokens {
		mapping (uint => address) ownerOf;
		mapping (uint => address) approvedFor;
		mapping (uint => bytes32) URIOf;
		mapping (uint => bool) exists;
		mapping (uint => uint) ownerIndexOf;
	}

	/**
	 * @title Users
	 * @dev Data on tokens held by users, and user operator status
	 * @param isOperator Checks permission to move any token held by the owner
	 * @param tokensByOwner List of all tokens held by an owner
	 */
	struct Users {
		mapping (address => mapping (address => bool)) isOperator;
		mapping (address => uint[]) tokensByOwner;
	}

	struct NFTExt {
		mapping (address => uint) nonceOf;
	}

	/**
	 * @title NFT
	 * @dev Storage footprint for NFT records
	 * @param registry List of all created token ids so far
	 * @param tokens Per-token data fields (info on owner and approved addresses)
	 * @param users Per-user data (info on owned tokens and operator status)
	 */
	struct NFT {
    mapping (bytes4 => bool) interfaces;
		uint[] registry;
		Tokens tokens;
		Users users;
		NFTExt ext;
	}

	function nonceOf(NFT storage _nft, address _a) internal view returns (uint) {
		return _nft.ext.nonceOf[_a];
	}

	function setNonceOf(NFT storage _nft, address _a, uint _updated) internal {
		_nft.ext.nonceOf[_a] = _updated;
	}

	function totalSupply(NFT storage _nft) internal view returns (uint) {
		return _nft.registry.length;
	}

	function balanceOf(NFT storage _nft, address _owner) internal view returns (uint) {
		return _nft.users.tokensByOwner[_owner].length;
	}

	function ownerOf(NFT storage _nft, uint _tokenId) internal view returns (address) {
		return _nft.tokens.ownerOf[_tokenId];
	}

	function ownerIndexOf(NFT storage _nft, uint _tokenId) internal view returns (uint) {
		return _nft.tokens.ownerIndexOf[_tokenId];
	}

	function approvedFor(NFT storage _nft, uint _tokenId) internal view returns (address) {
		return _nft.tokens.approvedFor[_tokenId];
	}

	function setApprovedFor(NFT storage _nft, address _approved, uint _tokenId) internal {
		_nft.tokens.approvedFor[_tokenId] = _approved;
	}

  function supportsInterface(NFT storage _nft, bytes4 _id) internal view returns (bool) {
    return _nft.interfaces[_id];
  }

	function isOperator(NFT storage _nft, address _owner, address _operator) internal view returns (bool) {
		return _nft.users.isOperator[_owner][_operator];
	}

	function doesExist(NFT storage _nft, uint token) internal view returns(bool){
		return _nft.tokens.exists[token];
	}

	function setOperator(NFT storage _nft, address _owner, address _operator, bool _status) internal {
		_nft.users.isOperator[_owner][_operator] = _status;
	}

	function clearApproved(NFT storage _nft, uint _tokenId) internal {
		delete _nft.tokens.approvedFor[_tokenId];
	}

	function addToOwned(NFT storage _nft, address _owner, uint _tokenId) internal {
		_nft.tokens.ownerOf[_tokenId] = _owner;
		_nft.tokens.ownerIndexOf[_tokenId] = balanceOf(_nft, _owner);
		_nft.users.tokensByOwner[_owner].push(_tokenId);
	}

	function removeFromOwned(NFT storage _nft, address _owner, uint _tokenId) internal {
		// Get current balance of owner, ID of owner's last token,
		// and index from which _tokenId will be removed
		uint currentBal = balanceOf(_nft, _owner);
		uint lastToken = _nft.users.tokensByOwner[_owner][currentBal.sub(1)];
		uint removalIndex = ownerIndexOf(_nft, _tokenId);
		// Decrease user token balance. currentBal.sub checks for underflow
		// Delete final element in user token list. This is lastToken, and will
		// be moved to the removalIndex
		delete _nft.users.tokensByOwner[_owner][currentBal.sub(1)];
		_nft.users.tokensByOwner[_owner].length = currentBal.sub(1);
		// Update lastToken -> its new index is the index from which _tokenId is removed
		_nft.users.tokensByOwner[_owner][removalIndex] = lastToken;
		_nft.tokens.ownerIndexOf[lastToken] = removalIndex;
	}
}
