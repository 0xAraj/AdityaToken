//SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {DeployAdityaToken} from "../../script/DeployAdityaToken.s.sol";
import {AdityaToken} from "../../src/AdityaToken.sol";

contract AdityaTokenTest is Test {
    AdityaToken adityaToken;

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
}
