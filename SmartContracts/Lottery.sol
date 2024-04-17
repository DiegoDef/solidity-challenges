//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;

contract Lottery{
    address payable[] public players;
    address payable public manager;

    constructor() {
        manager = payable(msg.sender);
    }

    receive() external payable {
        require(msg.sender != manager, "The manager cannot participate in the lottery.");
        require(msg.value == 0.1 ether, "You should send 0.1 ether to participate.");
        players.push(payable(msg.sender));
     }

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

    function pickWinner() public payable {
        require(players.length >= 10, "There must be 10 or more players.");

        uint index = random() % players.length;
        address payable winner = players[index];

        transferFeeManager();
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

    function transferFeeManager() private {
        uint feeManager = getBalance() / 10;
        manager.transfer(feeManager);
    }
}