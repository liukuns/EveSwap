// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract EveSwapERC20 is ERC20{

    //25个token用 25 * 1e18
    constructor(string memory name_,string memory symbol)ERC20(name_,symbol){}

    function mint(uint256 amount)external {
        _mint(msg.sender, amount);
    }
}
