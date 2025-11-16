// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

/*
 * WatchCatalog: stores the seller's luxury watches.
 * Prices are stored in WEI (1 ETH = 1e18 wei).
 * The Marketplace contract will interact with this contract to handle purchases.
 */

contract WatchCatalog {

    // ------ ERRORS ------
    error NotSeller();
    error WatchNotFound();
    error AlreadySold();

    // ------ ROLES ------
    address public seller;  // Only this address is allowed to create/update watches

    constructor(address _seller) {
        seller = _seller;
    }

    modifier onlySeller() {
        if (msg.sender != seller) revert NotSeller();
        _;
    }

    // ------ STRUCT ------
    struct Watch {
        uint256 id;
        string marca;
        string modelo;
        uint256 priceWei;     // Price stored in WEI (not ETH)
        bool sold;            // true = already sold
    }

    // ------ STORAGE ------
    uint256 public totalWatches;
    mapping(uint256 => Watch) public watches;

    // ------ EVENTS ------
    event WatchAdded(uint256 id, string marca, string modelo, uint256 priceWei);
    event WatchSold(uint256 id);

    // ------ FUNCTIONS ------

    /**
     * @notice Adds a new watch to the catalog. Only the seller can call this.
     * @dev Price must be provided in WEI.
     * @param marca Brand of the watch (e.g., Rolex)
     * @param modelo Model of the watch (e.g., Submariner)
     * @param priceWei Price of the watch in WEI
     */
    function addWatch(
        string memory marca,
        string memory modelo,
        uint256 priceWei
    ) external onlySeller {

        watches[totalWatches] = Watch({
            id: totalWatches,
            marca: marca,
            modelo: modelo,
            priceWei: priceWei,   // Price stored in WEI
            sold: false
        });

        emit WatchAdded(totalWatches, marca, modelo, priceWei);

        totalWatches++;
    }

    /**
     * @notice Returns the watch data for a given ID.
     */
    function getWatch(uint256 id) external view returns (Watch memory) {
        if (id >= totalWatches) revert WatchNotFound();
        return watches[id];
    }

    /**
     * @notice Marks a watch as sold. This will be called by the Marketplace contract.
     * @param id The ID of the watch to mark as sold.
     */
    function markAsSold(uint256 id) external {
        if (id >= totalWatches) revert WatchNotFound();
        if (watches[id].sold) revert AlreadySold();

        watches[id].sold = true;
        emit WatchSold(id);
    }
}
