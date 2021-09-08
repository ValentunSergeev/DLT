// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract Calculator {


    function plus(uint256 first, uint256 second) public pure returns (uint256) {
        return first + second;
    }

    function minus(uint256 first, uint256 second) public pure returns (uint256) {
        return first - second;
    }

    function div(uint256 first, uint256 second) public pure returns (uint256) {
        return first / second;
    }

    function mul(uint256 first, uint256 second) public pure returns (uint256) {
        return first * second;
    }
}