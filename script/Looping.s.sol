// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {Silo} from "silo-contracts-v2/silo-core/contracts/Silo.sol";
import {ERC20} from "@openzeppelin/token/ERC20/ERC20.sol";
import {ISiloConfig} from "silo-contracts-v2/silo-core/contracts/SiloConfig.sol";

contract CounterScript is Script {
    // Sonic
    ERC20 public token0 = ERC20(0x039e2fB66102314Ce7b64Ce5Ce3E5183bc94aD38);
    // USDC
    ERC20 public token1 = ERC20(0x29219dd400f2Bf60E5a23d13Be72B486D4038894);
    Silo public silo0 =
        Silo(payable(0xf55902DE87Bd80c6a35614b48d7f8B612a083C12));
    Silo public silo1 =
        Silo(payable(0x322e1d5384aa4ED66AeCa770B95686271de61dc3));

    ISiloConfig public marketConfig =
        ISiloConfig(0x062A36Bbe0306c2Fd7aecdf25843291fBAB96AD2);

    address USDC_WHALE = 0x578Ee1ca3a8E1b54554Da1Bf7C583506C4CD11c6;

    function setUp() public {}

    function run() public {
        // address USER = address(0x1);

        vm.startBroadcast();
    
        vm.stopBroadcast();
    }
}
