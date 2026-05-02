SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract awdevStaking {

    IERC721 public nft;

    struct StakeInfo {
        address owner;
        uint256 time;
    }

    mapping(uint256 => StakeInfo) public stakes;

    constructor(address _nft) {
        nft = IERC721(_nft);
    }

    function stake(uint256 tokenId) public {
        require(nft.ownerOf(tokenId) == msg.sender, "bukan owner");

        nft.transferFrom(msg.sender, address(this), tokenId);

        stakes[tokenId] = StakeInfo(msg.sender, block.timestamp);
    }

    function unstake(uint256 tokenId) public {
        StakeInfo memory s = stakes[tokenId];
        require(s.owner == msg.sender, "bukan staker");

        uint256 reward = (block.timestamp - s.time) * 1e14;

        delete stakes[tokenId];

        nft.transferFrom(address(this), msg.sender, tokenId);

        payable(msg.sender).transfer(reward);
    }

    receive() external payable {}
}