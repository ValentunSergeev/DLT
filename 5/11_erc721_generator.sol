// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract SimpleCollectible is ERC721 {
    uint256 public tokenCounter;
    string baseUri_;

    constructor (string memory name, string memory symbol, string memory baseUri) ERC721 (name, symbol){
        tokenCounter = 0;
        baseUri_ = baseUri;
    }

    function createCollectible() public returns (uint256) {
        uint256 newItemId = tokenCounter;
        _safeMint(msg.sender, newItemId);
        tokenCounter = tokenCounter + 1;
        return newItemId;
    }

    function _baseURI() internal view override returns (string memory) {
        return baseUri_;
    }
}

contract SimpleCollectibleDeployer {
    mapping(address => ERC721) public adresess;

    constructor () {
    }

     function createToken (string memory name, string memory symbol, string memory baseUri) public {
         ERC721 c = new SimpleCollectible(name, symbol, baseUri);
         adresess[msg.sender]= c;
    }

}