// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

contract OneWayFinder {
    bytes32 public destination_digest;
    address private owner;
    uint256 public reward = 5 ether;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can call this function");
        _;
    }

    function setDestinationDigest(uint256 input) external onlyOwner {
        destination_digest = keccak256(abi.encodePacked(uint256(input)));
    }

    function getRevealedDigest() public view returns (bytes32) {
        return destination_digest;
    }

    function tryInputHash(uint256 input) public {
        bytes32 digest = keccak256(abi.encodePacked(uint256(input)));
        require(digest == destination_digest, "Incorrect Input hash. Gambare gambare~");
        address payable challengerAccount = payable(msg.sender);
        require(address(this).balance >= reward, "Insufficient contract balance");
        challengerAccount.transfer(reward);
    }
}
