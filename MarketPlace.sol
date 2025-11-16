// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "./WatchCatalog.sol";
import "./Auditor.sol";

/*
 * Marketplace: handles the purchase of watches using ETH.
 * This contract interacts with WatchCatalog to complete the sale.
 */
 
contract Marketplace {

    // ------ ERRORS ------
    error NotEnoughETH();
    error TransferFailed();
    error WatchDoesNotExist();

    // ------ STORAGE ------
    Auditor public auditor;
    address public seller;
    WatchCatalog public catalog;

    constructor(address _seller, address _catalogAddress, address _auditorAddress) {
        seller = _seller;
        catalog = WatchCatalog(_catalogAddress);
        auditor = Auditor(_auditorAddress);
    }


    // ------ EVENTS ------
    event WatchPurchased(address buyer, uint256 watchId, uint256 priceWei);

    /**
     * @notice Allows a user to buy a watch by paying the exact amount in WEI.
     * @param watchId The ID of the watch being purchased.
     */
    function buyWatch(uint256 watchId) external payable {
        // Record purchase in Auditor
        auditor.recordPurchase(msg.sender, seller, watchId, msg.value);

        // Get watch info
        WatchCatalog.Watch memory w = catalog.getWatch(watchId);

        // Validate watch exists
        if (watchId >= catalog.totalWatches()) revert WatchDoesNotExist();

        // Validate correct ETH amount
        if (msg.value < w.priceWei) revert NotEnoughETH();

        // Mark the watch as sold in the catalog
        catalog.markAsSold(watchId);

        // Transfer ETH to seller (recommended: call)
        (bool success, ) = payable(seller).call{value: msg.value}("");
        if (!success) revert TransferFailed();

        emit WatchPurchased(msg.sender, watchId, msg.value);
    }

    // ------ RECEIVE & FALLBACK ------

    // Receive ETH sent directly
    receive() external payable {}

    // Fallback for non-existing function calls
    fallback() external payable {}
}
