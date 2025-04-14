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
        Silo(payable(0xf55902DE87Bd80c6a35614b48d7f8B612a083C12)); // SONIC silo
    Silo public silo1 =
        Silo(payable(0x322e1d5384aa4ED66AeCa770B95686271de61dc3)); // USDC silo

    ISiloConfig public marketConfig =
        ISiloConfig(0x062A36Bbe0306c2Fd7aecdf25843291fBAB96AD2);

    address USDC_WHALE = 0x578Ee1ca3a8E1b54554Da1Bf7C583506C4CD11c6;

    uint256 public MIN_BORROW_THRESHOLD = 100 * 1e18; // 100 Sonic

    function testLeveragedLooping() public {
        vm.deal(USDC_WHALE, 1000 ether);
        approveTokens(USDC_WHALE, address(silo1), address(token1));
        // approveTokens(USDC_WHALE, address(silo0), address(token0));

        // Initial deposit 1M $USDC
        depositIntoSilo(USDC_WHALE, silo1, 1000000 * token1.decimals());

        uint256 loopCount = 0;
        while (true) {
            uint256 borrowable = silo0.maxBorrowShares(USDC_WHALE);
            console.log("Borrowable SONIC: ", borrowable);

            if (borrowable < MIN_BORROW_THRESHOLD) {
                console.log("Borrowable amount below threshold. Exiting loop.");
                break;
            }

            borrowFromSilo(USDC_WHALE, silo0, borrowable);
            uint256 sonicBalance = token0.balanceOf(USDC_WHALE);

            console.log("Borrowed SONIC: ", sonicBalance);

            // Swap Sonic -> USDC (stub) @TODO implement later
            uint256 usdcReceived = swapSonicToUSDC(USDC_WHALE, sonicBalance);

            console.log("USDC received after swap: ", usdcReceived);

            depositIntoSilo(USDC_WHALE, silo1, usdcReceived);

            loopCount++;
            console.log("Loop count: ", loopCount);
        }

        console.log("Final SONIC balance: ", token0.balanceOf(USDC_WHALE));
        console.log("Final USDC balance: ", token1.balanceOf(USDC_WHALE));
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

    // Stub function to simulate Sonic -> USDC swap
    function swapSonicToUSDC(
        address user,
        uint256 sonicAmount
    ) internal returns (uint256 usdcReceived) {
        vm.startPrank(user);

        // Burn Sonic and mint USDC (mock)
        token0.transfer(address(0xdead), sonicAmount);
        uint256 mockedUSDC = sonicAmount / 1e12; // Convert 18 -> 6 decimals
        deal(address(token1), user, token1.balanceOf(user) + mockedUSDC);

        vm.stopPrank();
        return mockedUSDC;
    }
}
