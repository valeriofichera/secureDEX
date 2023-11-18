// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/console.sol";
import "forge-std/Script.sol";
import { USDC } from '../src/USDC.sol';
import { ETHER } from '../src/ETHER.sol';

contract ContractScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        
        // Provide the address of the initialOwner here
        address initialOwner = 0xe2D3C55a61BE30ce58324Be5bd188F1bEAc06f58; // Replace with the actual address
        
        // Deploy the USDC & ETH contract with the provided initialOwner address
        USDC usdc = new USDC(initialOwner);
        ETHER eth = new ETHER(initialOwner);

        // // Mint tokens (if needed) using the mint function in the deployed USDC contract
        // usdc.mint(initialOwner, 100000 ether);
        // eth.mint(initialOwner, 100000 ether);

        uint256 usdcBalance = usdc.balanceOf(initialOwner);
        uint256 ethBalance = eth.balanceOf(initialOwner);
        console.log("USDC balance: %s", usdcBalance /10 ** 18);
        console.log("ETH balance: %s", ethBalance /10 ** 18);

        vm.stopBroadcast();
    }
}