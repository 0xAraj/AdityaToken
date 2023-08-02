//SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {DeployAdityaToken} from "../../script/DeployAdityaToken.s.sol";
import {AdityaToken} from "../../src/AdityaToken.sol";

contract AdityaTokenTest is Test {
    AdityaToken adityaToken;
    address USER1 = makeAddr("user1");
    address USER2 = makeAddr("user2");

    event Transfer(
        address indexed from,
        address indexed to,
        uint indexed amount
    );

    function setUp() external {
        DeployAdityaToken deployAdityaToken = new DeployAdityaToken();
        adityaToken = deployAdityaToken.run();
    }

    function testDecimalIsSetToEight() public view {
        uint decimal = adityaToken.i_decimal();
        assert(decimal == 8);
    }

    function testTotalSupplyIsSetToTenCrore() public view {
        uint totalSupply = adityaToken.i_totalSupply();
        assert(totalSupply == 100000000);
    }

    function testOwnerIsToMsgSender() public view {
        address owner = adityaToken.i_owner();
        assert(owner == msg.sender);
    }

    function testTotalSupplyIsSetToOwner() public view {
        uint totalSupply = adityaToken.i_totalSupply();
        address owner = adityaToken.i_owner();
        uint initialOwnerBalance = adityaToken.balanceOf(owner);
        assert(initialOwnerBalance == totalSupply);
    }

    function testTransferFailIfOwnerHasNotZeroBalance() public {
        uint initialBalanceOfUser1 = adityaToken.balanceOf(USER1);
        uint initialBalanceOfUser2 = adityaToken.balanceOf(USER2);
        assert(initialBalanceOfUser1 == 0);
        assert(initialBalanceOfUser2 == 0);

        vm.prank(USER1);
        vm.expectRevert();
        adityaToken.transfer(USER2, 20);

        uint finalBalanceOfUser2 = adityaToken.balanceOf(USER2);
        assert(finalBalanceOfUser2 == initialBalanceOfUser2);
    }

    function testTransferFailIfOwnerHasNotEnoughBalance() public {
        vm.prank(msg.sender);
        adityaToken.transfer(USER1, 200);

        uint initialBalanceOfUser1 = adityaToken.balanceOf(USER1);
        uint initialBalanceOfUser2 = adityaToken.balanceOf(USER2);
        assert(initialBalanceOfUser1 == 200);
        assert(initialBalanceOfUser2 == 0);

        vm.prank(USER1);
        vm.expectRevert();
        adityaToken.transfer(USER2, 300);

        uint finalBalanceOfUser2 = adityaToken.balanceOf(USER2);
        uint finalBalanceOfUser1 = adityaToken.balanceOf(USER1);
        assert(finalBalanceOfUser2 == initialBalanceOfUser2);
        assert(finalBalanceOfUser1 == initialBalanceOfUser1);
    }

    function testTransferPassAndUpdateMappings() public {
        uint initialBalanceOfUser1 = adityaToken.balanceOf(USER1);
        uint initialBalanceOfOwner = adityaToken.balanceOf(msg.sender);
        uint totalSupply = adityaToken.i_totalSupply();

        assert(initialBalanceOfOwner == totalSupply);
        assert(initialBalanceOfUser1 == 0);

        vm.prank(msg.sender);
        adityaToken.transfer(USER1, 200);

        uint finalBalanceOfUser1 = adityaToken.balanceOf(USER1);
        uint finalBalanceOfOwner = adityaToken.balanceOf(msg.sender);

        assert(finalBalanceOfUser1 == 200);
        assert(
            finalBalanceOfOwner == initialBalanceOfOwner - finalBalanceOfUser1
        );
    }

    function testTransferShouldEmitWhenItsSuccess() public {
        vm.prank(msg.sender);
        vm.expectEmit(address(adityaToken));
        emit Transfer(msg.sender, USER1, 200);
        adityaToken.transfer(USER1, 200);
    }
}
