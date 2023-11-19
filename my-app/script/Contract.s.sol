// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/console.sol";
import "forge-std/Script.sol";
import { USDC } from '../src/USDC.sol';
import { ETHER } from '../src/ETHER.sol';
import { secureDEX } from '../src/secureDEX.sol';

contract ContractScript is Script {
    function setUp() public {}

    function run() public {
        vm.startBroadcast();
        
        // Provide the address of the initialOwner here
        address initialOwner = msg.sender; // Replace with the actual address
        
        // Deploy the USDC contract with the provided initialOwner address
        USDC usdc = new USDC(initialOwner);
        ETHER eth = new ETHER(initialOwner);

        // Send the whole USDC supply to the initialOwner
        usdc.transfer(initialOwner, usdc.totalSupply());

        // Send the whole ETH supply to the initialOwner
        eth.transfer(initialOwner, eth.totalSupply());

        // Set the proxyAddress as given
        address proxyAddress = 0xe2D3C55a61BE30ce58324Be5bd188F1bEAc06f58;

        // Deploy secureDEX
        secureDEX secureDEXContract = new secureDEX(proxyAddress);

        // Token Approvals
        usdc.approve(address(secureDEXContract), 100000 ether);
        eth.approve(address(secureDEXContract), 100000 ether);

        // Pass the contract addresses of USDC and ETH to createPool function
        secureDEXContract.createPool(address(usdc), address(eth));

        // Add liquidity, specifying the amounts in Ether
        secureDEXContract.addLiquidity(10 ether, 19617.225 ether);

        console.log("secureDEX contract address: %s", address(secureDEXContract));


        // gotta make the rest manually for now
        // // Good Swap with in-range slippage to prove it works under normal conditions 
        // secureDEXContract.userProtectedSwap(address(eth), 1 ether, 1961.7225 ether, 10);

        // if (usdc.balanceOf(initialOwner) == 19617.225 ether && eth.balanceOf(initialOwner) == 10 ether) {
        //     console.log("tx success ; gonna rebalance now");

        //     // Rebalance the pool to the previous state
        //     secureDEXContract.swap(address(usdc), 1961.7225 ether);
        // }
        // else {
        //     console.log("wrong configuration of guard");
        // }

        // console.log("USDC balance: %s", usdc.balanceOf(initialOwner) / 10 ** 18);
        // console.log("ETH balance: %s", eth.balanceOf(initialOwner) / 10 ** 18);

        // // Bad Swap with out-of-range slippage to prove it fails if under wrong conditions
        // secureDEXContract.userProtectedSwap(address(eth), 1 ether, 20000.225 ether, 1);

        // if (usdc.balanceOf(initialOwner) == 19617.225 ether && eth.balanceOf(initialOwner) == 10 ether) {
        //     console.log("tx failed, wrong configuration");
        // }
        // else {
        //     console.log("success");
        // }

        vm.stopBroadcast();
    }
}