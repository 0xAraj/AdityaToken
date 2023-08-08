//SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {DeployAdityaToken} from "../../script/DeployAdityaToken.s.sol";
import {AdityaToken} from "../../src/AdityaToken.sol";
import {BalanceOf, Transfer, ApproveAndAllowance, TransferFrom} from "../../script/Interactions.s.sol";

contract AdityaTokenIntegrationTest is Test {
    AdityaToken adityaToken;

    function setUp() external {
        DeployAdityaToken deployAdityaToken = new DeployAdityaToken();
        adityaToken = deployAdityaToken.run();
    }

    function testIntegrationOfAdityaToken() public {
        //BalanceOf funcition is testing

        BalanceOf balanceOf = new BalanceOf();
        uint amount = balanceOf.balanceOf(
            0x1AA18da866Bc70A78111b4C3F65883Dc8D8A0D96
        );
        assert(amount == 100000000);

        // Tansfer function is testing

        Transfer transfer = new Transfer();
        uint256 transferAmount = 1000;
        transfer.transfer(
            0x83fD3360Bf77a6E0E27e3F8a31759Ff7d37CB534,
            transferAmount
        );

        uint256 value = balanceOf.balanceOf(
            0x83fD3360Bf77a6E0E27e3F8a31759Ff7d37CB534
        );
        assert(value == transferAmount);

        // Approve and Allowance funciton is testing

        ApproveAndAllowance approveAndAllownace = new ApproveAndAllowance();
        uint256 approvedAmount = approveAndAllownace.approve(
            0x83fD3360Bf77a6E0E27e3F8a31759Ff7d37CB534,
            300
        );
        assert(approvedAmount == 300);

        // TransferFrom function is testing

        TransferFrom transferFrom = new TransferFrom();
        transferFrom.transferFrom(
            0x1AA18da866Bc70A78111b4C3F65883Dc8D8A0D96,
            0x83fD3360Bf77a6E0E27e3F8a31759Ff7d37CB534,
            300
        );

        uint balanceOfSpender = balanceOf.balanceOf(
            0x83fD3360Bf77a6E0E27e3F8a31759Ff7d37CB534
        );

        console.log(balanceOfSpender);
        assert(balanceOfSpender == 1300); // Above we transfered 1000 and here 300, so total 1000+300 = 1300
    }
}
