//SPDX-License-Identifier: MIT

pragma solidity 0.8.20;
import {Script} from "forge-std/Script.sol";
import {AdityaToken} from "../src/AdityaToken.sol";

contract DeployAdityaToken is Script {
    AdityaToken adityaToken;

    function run() external returns (AdityaToken) {
        vm.startBroadcast();
        adityaToken = new AdityaToken();
        vm.stopBroadcast();
        return adityaToken;
    }
}
