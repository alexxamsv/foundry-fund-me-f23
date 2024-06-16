// SPDX-License-Identifier: MIT

// 1. Deploy mocks when we are on a local anvil chain
// 2. Keep track of contract address accross different chains
// Sepolia ETH/USD
// Mainnet ETH/USD

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    // if we are on a local anvil, we deploy mocks
    // Otherwise, grab the existing address from the live network

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    NetworkConfig public activeNetworkConfig;

    struct NetworkConfig {
        address priceFeed; //ETH/USD price feed address
    }

    constructor() {
        if (block.chainid == 11155111) {
            // it's a global variable from Solidity; it refers to the chain's current id; every network has their own chain id
            activeNetworkConfig = getSepoliaConfig();
        } else if (block.chainid == 1) {
            activeNetworkConfig = getMainnetEthConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaConfig() public pure returns (NetworkConfig memory) {
        // we use the memory keyword because it's a special object
        // price feed address
        NetworkConfig memory sepoliaConfig = NetworkConfig({ //again we use the memory keyword
            priceFeed: 0xD7d3b2b62b983eC29fE079172cCa547B630610F8
        });
        return sepoliaConfig;
    }

    function getMainnetEthConfig() public pure returns (NetworkConfig memory) {
        // we use the memory keyword because it's a special object
        // price feed address
        NetworkConfig memory ethConfig = NetworkConfig({ //again we use the memory keyword
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306 // from Chainlink price feed addresses ETH / USD
        });
        return ethConfig;
    }

    function getOrCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        // price feed address
        if(activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }

        // 1. Depoy the mocks (a mock contract is like a fake contract)
        // 2. Return the mock address

        vm.startBroadcast(); // this way we can deploy these mocks contracts to the chain we're workig with; we should inherit from Script to have access to vm keyword
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE); // from the constructor of MockV3Aggregator
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig ({
            priceFeed: address(mockPriceFeed)
        });
        return anvilConfig;
    }
}
