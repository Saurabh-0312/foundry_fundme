// SPDX-Licence-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/fundme.sol";
import {deploy} from "../script/deploy.s.sol";

contract fundmeTest is Test {
    FundMe fundme;

    address user = makeAddr("user");
    uint256 constant sendvalue = 0.1 ether;
    uint256 constant balance = 10 ether;

    function setUp() external {
        // fundme = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        deploy deployfundeme = new deploy();
        fundme = deployfundeme.run();
        vm.deal(user, balance);
    }

    function testminimumdollarisfive() public {
        assertEq(fundme.MINIMUM_USD(), 5e18);
    }

    function testownerissender() public {
        assertEq(fundme.getowner(), msg.sender);
    }

    function testpricefeedversion() public {
        uint256 version = fundme.getVersion();
        assertEq(version, 4);
    }

    function testfundfail() public {
        vm.expectRevert();
        fundme.fund();
    }

    modifier funded() {
        vm.prank(user);
        fundme.fund{value: sendvalue}();
        _;
    }

    function testfundupdated() public funded {
        uint256 amountfunded = fundme.getaddresstoamountfunded(user);
        assertEq(amountfunded, sendvalue);
    }

    function testaddfunder() public funded {
        address funder = fundme.getfunder(0);
        assertEq(funder, user);
    }

    function testonlyownerwithdraw() public funded {
        vm.expectRevert();
        vm.prank(user);
        fundme.withdraw();
    }

    function testwithdrawsingle() public funded {
        //arrange
        uint256 startingownerbalance = fundme.getowner().balance;
        uint256 startingfundmebalance = address(fundme).balance;

        //Act
        vm.prank(fundme.getowner());
        fundme.withdraw();

        //assert

        uint256 endingownerbalance = fundme.getowner().balance;
        uint256 endingfundmebalance = address(fundme).balance;

        assertEq(endingfundmebalance, 0);
        assertEq(
            startingfundmebalance + startingownerbalance,
            endingownerbalance
        );
    }

    function testwithdrawmutiplefunder() public funded {
        //arrange
        uint160 numberoffunder = 10;
        uint160 startingindex = 1;

        for (uint160 i = startingindex; i < numberoffunder; i++) {
            hoax(address(i), sendvalue);
            fundme.fund{value: sendvalue}();
        }

        uint256 startingownerbalance = fundme.getowner().balance;
        uint256 startingfundmebalance = address(fundme).balance;

        vm.startPrank(fundme.getowner());
        fundme.withdraw();
        vm.stopPrank();

        assert(address(fundme).balance == 0);
        assertEq(
            startingfundmebalance + startingownerbalance,
            fundme.getowner().balance
        );
    }

    //cheaper

    function testwithdrawmutiplefundercheaper() public funded {
        //arrange
        uint160 numberoffunder = 10;
        uint160 startingindex = 1;

        for (uint160 i = startingindex; i < numberoffunder; i++) {
            hoax(address(i), sendvalue);
            fundme.fund{value: sendvalue}();
        }

        uint256 startingownerbalance = fundme.getowner().balance;
        uint256 startingfundmebalance = address(fundme).balance;

        vm.startPrank(fundme.getowner());
        fundme.cheaperwithdraw();
        vm.stopPrank();

        assert(address(fundme).balance == 0);
        assertEq(
            startingfundmebalance + startingownerbalance,
            fundme.getowner().balance
        );
    }
}
