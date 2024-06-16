// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol"; // Script is a base contract provided by Foundry that includes utility functions and variables for scripting and testing.
import {FundMe} from "../src/FundMe.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployFundMe is Script {
    function run() external returns (FundMe) {
        // Before startBroadcast -> It's not going to send a "real" transaction
        HelperConfig helperConfig = new HelperConfig();
        address ethUsdPriceFeed = helperConfig.activeNetworkConfig(); // we use the "activeNetworkConfig()" with brackets "()"in this case because it's like a getter from another contract
        // when we return a struct it have to be in (): (address ethUsdPriceFeed) = helperConfig.activeNetworkConfig();

        // After startBroadcast -> A real transaction!
        vm.startBroadcast(); // a Foundry-specific function that begins broadcasting transactions. This means that any subsequent contract deployments or transactions will be sent to the network (or a simulated network).
        FundMe fundMe = new FundMe(ethUsdPriceFeed); //This address is likely needed for the contract to interact with another contract or service (such as a price feed or oracle).
        vm.stopBroadcast(); //ends the broadcasting of transactions. This ensures that no further transactions are sent to the network after this point.
        return fundMe;
    }
}
