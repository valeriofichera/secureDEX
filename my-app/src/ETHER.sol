// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "ERC20.sol";

contract ETH is ERC20 {
    constructor(address initialAccount) ERC20("Ether", "ETH") {
        _mint(initialAccount, 100000 * (10 ** uint256(decimals())));
    }
}