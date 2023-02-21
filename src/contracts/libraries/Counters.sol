// SPDX-License-Identifier: MIT
pragma solidity >=0.4.0 < 0.9.0;
import './SafeMath.sol';


library Counters {
    // A(library) of B(data)
    using SafeMath for uint256;

    // keep track the change on struct code
    struct Counter {
        // customizing self variance
        uint256 _value;
    }
    
    // find current value / storage => keep tracking(not vanishing) on struct Counter
    function current(Counter storage counter) view internal returns(uint256) {
        return counter._value;
    }

    // always + 1 / change state : no view
    function increaseOne(Counter storage counter) internal {
        // x:_value, y:1
        // counter._value = counter._value.add(1); / adding 1 can not make overflow
        counter._value += 1;
    }

    // always - 1
    function decreaseOne(Counter storage counter) internal {
        // x:_value, y:1
        counter._value = counter._value.sub(1);
    }
}
