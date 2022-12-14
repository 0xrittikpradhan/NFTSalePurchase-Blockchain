//SPDX-License-Identifier: None

pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PurchaseToken20 is ERC20, Ownable {

    constructor() ERC20 ("PurchaseToken20", "PT20") {
    }

    //Only DeX contract can call mint function.
    function mint(address owner, uint256 amount) external onlyOwner {
        _mint(owner, amount);
    }

    //Only DeX contract can call burn function.
    function burn(address owner, uint256 amount) external onlyOwner {
        _burn(owner, amount);
    }
}