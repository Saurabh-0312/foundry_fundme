// SPDX-Licence-identifier: MIT

pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/fundme.sol";

contract fundfundme is Script {
    uint256 constant send_value = 0.01 ether;

    function startFundme(address mostrecent) public {
        vm.startBroadcast();
        FundMe(payable(mostrecent)).fund{value: send_value}();
        vm.stopBroadcast();
        console.log("funded fundme with 0.01 ether");
    }

    function run() external {
        address mostrecent = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        vm.startBroadcast();
        startFundme(mostrecent);
        vm.stopBroadcast();
    }
}

contract withdrawfundme is Script {
    function startwithdrawFundme(address mostrecent) public {
        vm.startBroadcast();
        FundMe(payable(mostrecent)).withdraw();
        vm.stopBroadcast();

        console.log("withdrawl all the funds");
    }

    function run() external {
        address mostrecent = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        vm.startBroadcast();
        startwithdrawFundme(mostrecent);
        vm.stopBroadcast();
    }
}
