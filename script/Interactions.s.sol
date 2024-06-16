// SPDX-License-Identifier: MIT

// Fund
// Withdraw

pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script {
    uint256 constant SEND_VALUE = 0.01 ether;

    function fundFundMeFunc(address mostRecentlyDeployed) public {
        //vm.startBroadcast();
        vm.prank(msg.sender);
        FundMe(payable(mostRecentlyDeployed)).fund{value: SEND_VALUE}();
        //vm.stopBroadcast();
        console.log("Funded FundMe with %s", SEND_VALUE);
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        vm.startBroadcast();
        fundFundMeFunc(mostRecentlyDeployed);
        vm.stopBroadcast();
    }
}

contract WithdrawFundMe is Script {
    uint256 constant SEND_VALUE = 0.01 ether;

    function withdrawFundMeFunc(address mostRecentlyDeployed) public {
        //vm.startBroadcast();
        vm.prank(msg.sender);
        FundMe(payable(mostRecentlyDeployed)).withdraw();
        //vm.stopBroadcast();
        console.log("Withdrew funds");
    }

    function run() external {
        vm.startBroadcast();
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        withdrawFundMeFunc(mostRecentlyDeployed);
        vm.stopBroadcast();
    }
}
