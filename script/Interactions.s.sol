//SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";
import {AdityaToken} from "../src/AdityaToken.sol";

contract BalanceOf is Script {
    function balanceOf(address owner) public view returns (uint256) {
        AdityaToken adityaToken = AdityaToken(
            0x9B31Fdc5f7aDd0Ad73EE941c6E8c1B122696A35F //sepolia address where smart contract is deployed
        );

        uint256 amount = adityaToken.balanceOf(owner);
        return amount;
    }
}

contract Transfer is Script {
    function transfer(address recipient, uint amount) public {
        AdityaToken adityaToken = AdityaToken(
            0x9B31Fdc5f7aDd0Ad73EE941c6E8c1B122696A35F
        );
        vm.prank(0x1AA18da866Bc70A78111b4C3F65883Dc8D8A0D96); //address which deployed the contract
        adityaToken.transfer(recipient, amount);
    }
}
