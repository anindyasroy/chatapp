// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract MyToken is ERC721, ERC721Enumerable, Ownable {
    using Counters for Counters.Counter;
    uint public price = 1 * 10 ** 15;
    Counters.Counter private _tokenIdCounter;

    constructor() ERC721("MyToken", "MTK") {}

    struct message {
        uint ID;
        address sender;
        uint nftID;
        string sentMessage;
        uint timestamp;
    }

    message[] public Messages;

    uint public totalMessages = 0;

    function addMessage(
        string memory messageToSend,
        uint nftID
    ) public returns (bool) {
        require(ownerOf(nftID) == msg.sender, "You don't own that NFT");

        Messages.push(
            message(
                totalMessages,
                msg.sender,
                nftID,
                messageToSend,
                block.timestamp
            )
        );

        totalMessages += 1;
        return true;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "google.com";
    }

    function getMessage(uint index) public view returns (message memory) {
        return Messages[index];
    }

    function safeMint(address to) public payable {
        require(msg.value == price, "Not the right about of ETH");
        address payable owner = payable(owner());
        (bool tryToSend, ) = owner.call{value: msg.value}("");
        require(tryToSend == true, "Error in Sending Funds");

        uint256 tokenId = _tokenIdCounter.current();
        require(tokenId <= 10000, "No more NFTs can be minted");
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId,
        uint256 batchSize
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
