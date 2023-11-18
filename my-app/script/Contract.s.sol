// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import { USDC } from '../src/USDC.sol';
import { ETHER } from '../src/ETHER.sol';

contract ContractScript is Script {
    function setUp() public {}

    function run() public {
        vm.broadcast();
        
        // Provide the address of the initialOwner here
        address initialOwner = 0xe2D3C55a61BE30ce58324Be5bd188F1bEAc06f58; // Replace with the actual address
        
        // Deploy the USDC contract with the provided initialOwner address
        USDC usdc = new USDC(initialOwner);
        ETHER eth = new ETHER(initialOwner);

        // Mint tokens (if needed) using the mint function in the deployed USDC contract
        usdc.mint(initialOwner, 100000 * 10 ** usdc.decimals());
        eth.mint(initialOwner, 100000 * 10 ** eth.decimals());
    }
}