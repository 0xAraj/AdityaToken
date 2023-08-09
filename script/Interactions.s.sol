//SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

import {Script} from "forge-std/Script.sol";
import {AdityaToken} from "../src/AdityaToken.sol";

contract BalanceOf is Script {
    address sepoliaSmartContractAddress =
        0x9B31Fdc5f7aDd0Ad73EE941c6E8c1B122696A35F;

    function balanceOf(address owner) public view returns (uint256) {
        AdityaToken adityaToken = AdityaToken(sepoliaSmartContractAddress);

        uint256 amount = adityaToken.balanceOf(owner);
        return amount;
    }
}

contract Transfer is Script {
    address sepoliaSmartContractAddress =
        0x9B31Fdc5f7aDd0Ad73EE941c6E8c1B122696A35F;

    address deployerAddress = 0x1AA18da866Bc70A78111b4C3F65883Dc8D8A0D96;

    function transfer(address recipient, uint amount) public {
        AdityaToken adityaToken = AdityaToken(sepoliaSmartContractAddress);
        vm.prank(deployerAddress); //address which deployed the contract
        adityaToken.transfer(recipient, amount);
    }
}

contract ApproveAndAllowance is Script {
    address sepoliaSmartContractAddress =
        0x9B31Fdc5f7aDd0Ad73EE941c6E8c1B122696A35F;

    address deployerAddress = 0x1AA18da866Bc70A78111b4C3F65883Dc8D8A0D96;

    function approve(address spender, uint amount) public returns (uint256) {
        AdityaToken adityaToken = AdityaToken(sepoliaSmartContractAddress);
        vm.prank(deployerAddress);
        adityaToken.approve(spender, amount);

        uint256 approvedAmount = adityaToken.allowance(
            deployerAddress,
            spender
        );
        return approvedAmount;
    }
}

contract TransferFrom is Script {
    address sepoliaSmartContractAddress =
        0x9B31Fdc5f7aDd0Ad73EE941c6E8c1B122696A35F;

    function transferFrom(
        address owner,
        address spender,
        uint256 amount
    ) public {
        AdityaToken adityaToken = AdityaToken(sepoliaSmartContractAddress);

        adityaToken.transferFrom(owner, spender, amount);
    }
}
