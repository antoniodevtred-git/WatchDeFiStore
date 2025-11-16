// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

/*
 * Auditor contract: keeps a full record of all marketplace purchases.
 * Demonstrates the usage of tx.origin, events and cross-contract communication.
 */

contract Auditor {

    // ------ STRUCT ------
    struct PurchaseRecord {
        address buyer;        // address that called buyWatch()
        address origin;       // original EOA (tx.origin)
        address seller;       // watch seller
        uint256 watchId;      // ID of the watch purchased
        uint256 priceWei;     // price in WEI
        uint256 timestamp;    // block timestamp when the purchase happened
    }

    // ------ STORAGE ------
    uint256 public totalPurchases;
    mapping(uint256 => PurchaseRecord) public purchaseHistory;

    // ------ EVENTS ------
    event PurchaseLogged(
        uint256 indexed id,
        address buyer,
        address origin,
        address seller,
        uint256 watchId,
        uint256 priceWei,
        uint256 timestamp
    );

    // ------ FUNCTIONS ------

    /**
     * @notice Records a purchase operation coming from the Marketplace.
     * @dev Called by Marketplace after every buyWatch().
     */
    function recordPurchase(
        address buyer,
        address seller,
        uint256 watchId,
        uint256 priceWei
    ) external {

        purchaseHistory[totalPurchases] = PurchaseRecord({
            buyer: buyer,
            origin: tx.origin,
            seller: seller,
            watchId: watchId,
            priceWei: priceWei,
            timestamp: block.timestamp
        });

        emit PurchaseLogged(
            totalPurchases,
            buyer,
            tx.origin,
            seller,
            watchId,
            priceWei,
            block.timestamp
        );

        totalPurchases++;
    }

    /**
     * @notice Returns a specific purchase record.
     */
    function getPurchase(uint256 id) external view returns (PurchaseRecord memory) {
        return purchaseHistory[id];
    }
}
