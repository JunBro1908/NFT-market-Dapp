// SPDX-License-Identifier: MIT
pragma solidity >=0.4.0 < 0.9.0;

library SafeMath{

    // pure : no search and no modify, internal : only (inherited or own) contract can access
    function add (uint256 x, uint256 y) internal pure returns(uint256) {
        uint256 r = x + y;
        require(r >= x, 'ADD OVERFLOW ERORR');
        return r;
    }

    function sub (uint256 x, uint256 y) internal pure returns(uint256) {
        uint256 r = x - y;
        require(r >= x, 'SUB OVERFLOW ERORR');
        return r;
    }

    function mul (uint256 x, uint256 y) internal pure returns(uint256) {
        // gas optimization
        if (x==0) {
            return 0;
        }
        uint256 r = x * y;
        require(r/x == y, 'MUL OVERFLOW ERROR');
        return r;
    }

    function divide(uint256 x, uint256 y) internal pure returns(uint256) {
        require(y > 0, 'DIVIDE OVERFLOW ERROR');
        return x / y;
    }

    function mod(uint256 x, uint256 y) internal pure returns(uint256) {
        require(y > 0,'MOD OVERFLOW ERROR');
        return x % y;
    }
}