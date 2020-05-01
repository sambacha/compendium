pragma solidity ^0.4.24;
import "./NFTBase.sol";

/// @dev Note: the ERC-165 identifier for this interface is 0x150b7a02.
interface ERC721TokenReceiver {
    /// @notice Handle the receipt of an NFT
    /// @dev The ERC721 smart contract calls this function on the recipient
    ///  after a `transfer`. This function MAY throw to revert and reject the
    ///  transfer. Return of other than the magic value MUST result in the
    ///  transaction being reverted.
    ///  Note: the contract address is always the message sender.
    /// @param _operator The address which called `safeTransferFrom` function
    /// @param _from The address which previously owned the token
    /// @param _tokenId The NFT identifier which is being transferred
    /// @param _data Additional data with no specified format
    /// @return `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
    ///  unless throwing
    function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes _data) external returns(bytes4);
}

contract NFTBase {

	event Approval(address indexed _owner, address indexed _approved, uint256 indexed _tokenId);
  event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
  event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);

	address master;
	address controller;
	bool paused;
	// mapping (bytes32 => mapping(bytes4 => address)) targets;

	bytes32 constant NFT_BASE = keccak256("NFT_BASE");

	mapping (bytes32 => NFTLib.NFT) state;

	function getBase() internal view returns (NFTLib.NFT storage nft) {
		return state[NFT_BASE];
	}
}

contract NFTTransfers is NFTBase {

	using NFTLib for NFTLib.NFT;

	function safeTransferFrom(address _from, address _to, uint _tokenId) external payable {
		NFTLib.NFT storage nft = getBase();
		address owner = nft.ownerOf(_tokenId);
		require(owner == _from && owner != 0 && _to != 0);
		require(senderCanTransfer(nft, owner, _from, _tokenId));
		_transferFrom(nft, _from, _to, _tokenId);
		if (isContract(_to))
			require(ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, "") == bytes4(keccak256("onERC721Received(address,address,uint256,bytes)")));
		emit Transfer(_from, _to, _tokenId);
	}

	function safeTransferFrom(address _from, address _to, uint _tokenId, bytes _data) external payable {
		NFTLib.NFT storage nft = getBase();
		address owner = nft.ownerOf(_tokenId);
		require(owner == _from && owner != 0 && _to != 0);
		require(senderCanTransfer(nft, owner, _from, _tokenId));
		_transferFrom(nft, _from, _to, _tokenId);
		if (isContract(_to))
			require(ERC721TokenReceiver(_to).onERC721Received(msg.sender, _from, _tokenId, _data) == bytes4(keccak256("onERC721Received(address,address,uint256,bytes)")));
		emit Transfer(_from, _to, _tokenId);
	}

	function transferFrom(address _from, address _to, uint _tokenId) external payable {
		NFTLib.NFT storage nft = getBase();
		address owner = nft.ownerOf(_tokenId);
		require(owner == _from && owner != 0 && _to != 0);
		require(senderCanTransfer(nft, owner, _from, _tokenId));
		_transferFrom(nft, _from, _to, _tokenId);
		emit Transfer(_from, _to, _tokenId);
	}

	function senderCanTransfer(NFTLib.NFT storage _nft, address _owner, address _from, uint _tokenId) internal view returns (bool) {
		return (
			_owner == msg.sender ||
			_nft.approvedFor(_tokenId) == msg.sender ||
			_nft.isOperator(_from, msg.sender)
		);
	}

	function _transferFrom(NFTLib.NFT storage _nft, address _from, address _to, uint _tokenId) internal {
		_nft.clearApproved(_tokenId);
		_nft.removeFromOwned(_from, _tokenId);
		_nft.addToOwned(_to, _tokenId);
	}
	//Checks if an account is a contract or is being constructed
	function isContract(address _addr) private view returns (bool){
      uint32 size;
      assembly {
        size := extcodesize(_addr)
      }
      return (size > 0);
    }
}

contract NFTApprovals is NFTTransfers {

	using NFTLib for NFTLib.NFT;

	function approve(address _approved, uint _tokenId) external payable {
		NFTLib.NFT storage nft = getBase();
		address owner = nft.ownerOf(_tokenId);
		require(owner == msg.sender || nft.isOperator(owner, msg.sender));
		nft.setApprovedFor(_approved, _tokenId);
		emit Approval(owner, _approved, _tokenId);
	}

	function setApprovalForAll(address _operator, bool _approved) external {
		NFTLib.NFT storage nft = getBase();
		nft.setOperator(msg.sender, _operator, _approved);
		emit ApprovalForAll(msg.sender, _operator, _approved);
	}
}

contract NFTGetters is NFTApprovals {

	using NFTLib for NFTLib.NFT;

	function name() external pure returns (string) {
		return "Bill of Lading";
	}

	function symbol() external pure returns (string) {
		return "BOL";
	}

	function totalSupply() external view returns (uint) {
		return getBase().totalSupply();
	}

	/**
   * @dev Count all of the nfts owned by the _owner
   * @notice Throws if owner is zero address
   * @param _owner The owner of the nfts
   * @return Returns a count of the nfts owned by the _owner
   */
  function balanceOf(address _owner) external view returns (uint) {
    require(_owner != address(0));
		return getBase().balanceOf(_owner);
  }

  /**
   * @dev Get the approved address of the specified token
   * @notice Throws if the token is invalid
   * @param _tokenId The token being queried
   * @return The approved address of the specified token
   */
  function getApproved(uint _tokenId) external view returns (address) {
    require(getBase().ownerOf(_tokenId) != address(0));
    return getBase().approvedFor(_tokenId);
  }

  function supportsInterface(bytes4 _id) external view returns (bool) {
    return getBase().supportsInterface(_id); 
  }

  /**
   * @notice Query if an address is an authorized operator for another address
   * @param _owner The address that owns the NFTs
   * @param _operator The address that acts on behalf of the owner
   * @return True if `_operator` is an approved operator for `_owner`, false otherwise
   */
  function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
		return getBase().isOperator(_owner, _operator);
  }

  /**
   * @dev Returns the owner address of the specified token
   * @notice Throws if the specified token is invalid
   * @param _tokenId The id of the specified nft token
   * @return The address of the owner of the token
   */
  function ownerOf(uint256 _tokenId) external view returns (address) {
		address owner = getBase().ownerOf(_tokenId);
  	require(owner != 0);
    return owner;
  }

  /// @notice Enumerate valid NFTs
  /// @dev Throws if `_index` >= `totalSupply()`.
  /// @param _index A counter less than `totalSupply()`
  /// @return The token identifier for the `_index`th NFT,
  ///  (sort order not specified)
  function tokenByIndex(uint256 _index) external view returns (uint256){
    NFTLib.NFT storage nft = getBase();
    require(nft.totalSupply() > _index , "That index doesn\'t exist");
    return(nft.registry[_index]);
  }

  /// @notice Enumerate NFTs assigned to an owner
  /// @dev Throws if `_index` >= `balanceOf(_owner)` or if
  ///  `_owner` is the zero address, representing invalid NFTs.
  /// @param _owner An address where we are interested in NFTs owned by them
  /// @param _index A counter less than `balanceOf(_owner)`
  /// @return The token identifier for the `_index`th NFT assigned to `_owner`,
  ///   (sort order not specified)
  function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256){
    require(_owner != address(0), "Please select a valid index");
    NFTLib.NFT storage nft = getBase();
    require(nft.users.tokensByOwner[_owner].length > _index , "That token doesn\'t exist for this owner");
    return(nft.users.tokensByOwner[_owner][_index]);
  }
}
