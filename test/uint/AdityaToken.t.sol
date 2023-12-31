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
    event Approval(
        address indexed owner,
        address indexed spender,
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

    function testApproveFailsIfOwnerHasNotEnoughBalance() public {
        vm.prank(msg.sender);
        adityaToken.transfer(USER1, 200);

        vm.prank(USER1);
        vm.expectRevert();
        adityaToken.approve(USER2, 300);
    }

    function testApproveIfOwnerHasEnoughBalance() public {
        uint initialApprovalOfUser1 = adityaToken.allowance(msg.sender, USER1);
        assert(initialApprovalOfUser1 == 0);

        vm.prank(msg.sender);
        adityaToken.approve(USER1, 100);

        uint finalApprovalOfUser1 = adityaToken.allowance(msg.sender, USER1);
        assert(finalApprovalOfUser1 == 100);
    }

    function testApprovalShouldEmitWhenItsSuccess() public {
        vm.prank(msg.sender);
        vm.expectEmit(address(adityaToken));
        emit Approval(msg.sender, USER1, 100);
        adityaToken.approve(USER1, 100);
    }

    function testTransferFromFailsIfNotEnoughBalanceIsApproved() public {
        vm.prank(msg.sender);
        adityaToken.approve(USER1, 100);

        vm.prank(USER2);
        vm.expectRevert();
        adityaToken.transferFrom(msg.sender, USER1, 200);
    }

    function testTransferFromFailsIfOwnerHasNotEnoughBalance() public {
        vm.prank(msg.sender);
        adityaToken.approve(USER1, 100);

        uint balalceOfOwner = adityaToken.balanceOf(msg.sender);

        vm.prank(msg.sender);
        adityaToken.transfer(USER2, balalceOfOwner);

        vm.expectRevert();
        adityaToken.transferFrom(msg.sender, USER1, 100);
    }

    function testTransferFromPassWhenOwnerHasEnoughBalanceAndApproved() public {
        vm.prank(msg.sender);
        adityaToken.approve(USER1, 100);

        uint initialBalanceOfOwner = adityaToken.balanceOf(msg.sender);
        uint initialBalanceOfUser1 = adityaToken.balanceOf(USER1);

        adityaToken.transferFrom(msg.sender, USER1, 100);

        uint finalBalanceOfOwner = adityaToken.balanceOf(msg.sender);
        uint finalBalamceOfUser1 = adityaToken.balanceOf(USER1);

        assert(finalBalamceOfUser1 == initialBalanceOfUser1 + 100);
        assert(
            finalBalanceOfOwner == initialBalanceOfOwner - finalBalamceOfUser1
        );
    }
}
