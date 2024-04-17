//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;

contract Lottery{
    address payable[] public players;
    address public manager;

    constructor() {
        manager = msg.sender;
    }

    receive() external payable {
        require(msg.value == 0.1 ether, "You should send 0.1 ether to participate.");
        players.push(payable(msg.sender));
     }

    function getBalance() public view returns(uint) {
        require(msg.sender == manager, "You are not the manager.");
        return address(this).balance;
    }

    function pickWinner() public payable {
        require(msg.sender == manager, "You are not the manager.");
        require(players.length >= 3, "There must be 3 or more players.");

        uint index = random() % players.length;
        address payable winner = players[index];

        winner.transfer(getBalance());
        
        delete players;
    }
    
    function random() internal view returns (uint256) {
    return uint256(keccak256(abi.encodePacked(
        tx.origin,
        block.timestamp,
        players.length
      )));
    }
}