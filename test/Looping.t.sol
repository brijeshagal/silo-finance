// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Silo} from "silo-contracts-v2/silo-core/contracts/Silo.sol";
import {ERC20} from "@openzeppelin/token/ERC20/ERC20.sol";
import {ISiloConfig} from "silo-contracts-v2/silo-core/contracts/SiloConfig.sol";

contract LoopingTest is Test {
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

    function testDeposit() public {
        // address USER = address(0x1);

        vm.deal(USDC_WHALE, 1000 ether);

        // Approve token1 (USDC) to the silo1
        approveTokens(USDC_WHALE, address(silo1), address(token1));

        uint256 _borrowableAmount = silo0.maxBorrowShares(USDC_WHALE);
        console.log("Max borrowable amount before deposit: ", _borrowableAmount);

        // Deposit token1 into silo (USDC)
        depositIntoSilo(
            USDC_WHALE,
            silo1,
            (10 ** 6) * (10 ** token1.decimals())
        );

        // Get max borrowable amount for token0
        uint256 borrowableAmount = silo0.maxBorrowShares(USDC_WHALE);
        console.log("Max borrowable amount after deposit: ", borrowableAmount);

        // Borrow token0 into silo (SONIC)
        borrowFromSilo(USDC_WHALE, silo0, borrowableAmount);

        uint256 borrowableAmountAfterBorrow = silo0.maxBorrowShares(USDC_WHALE);
        console.log("Max borrowable amount after borrow: ", borrowableAmountAfterBorrow);

        uint sonicBalance = token0.balanceOf(USDC_WHALE);
        console.log("Sonic balance after borrow: ", sonicBalance);

    }

    function approveTokens(address owner, address to, address token) internal {
        vm.startPrank(owner);
        ERC20(token).approve(to, type(uint256).max);
        vm.stopPrank();
    }

    function depositIntoSilo(
        address depositor,
        Silo silo,
        uint256 amount
    ) internal {
        vm.startPrank(depositor);
        silo.deposit(amount, depositor);
        vm.stopPrank();
    }

    function borrowFromSilo(
        address borrower,
        Silo silo,
        uint256 amount
    ) internal {
        vm.startPrank(borrower);
        silo.borrow(amount, borrower, borrower);
        vm.stopPrank();
    }
}
