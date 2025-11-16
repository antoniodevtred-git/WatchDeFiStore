🛒 LuxuryWatch Marketplace — Solidity Smart Contract System
Decentralized Buy/Sell System Using ETH (Native Coin)

A complete multi-contract project demonstrating essential Solidity concepts.

📌 Overview

LuxuryWatch Marketplace is a three-contract decentralized application built entirely in Solidity.
It simulates a real watch shop where:

A seller lists luxury watches.

A buyer pays using ETH (native coin) on a local blockchain.

Purchases are automatically audited and recorded on-chain.

The project focuses on the core concepts learned in the training block:

✔ msg.sender
✔ tx.origin
✔ Contract-to-contract calls
✔ Native coin transfers (payable, call, receive, fallback)
✔ Custom errors
✔ Require validations
✔ Events and state updates
✔ ETH balance flow
✔ Role-based permissions

This makes it a perfect portfolio project to demonstrate mastery of Solidity fundamentals.

🧩 Architecture

The system consists of three smart contracts, each with a single responsibility:
               ┌─────────────────────────┐
               │       WatchCatalog       │
               │  - Stores watches        │
               │  - Seller-only CRUD      │
               │  - Marks watch as sold   │
               └──────────────┬──────────┘
                              │
                              ▼
               ┌─────────────────────────┐
               │       Marketplace        │
               │  - Handles payments      │
               │  - Uses payable          │
               │  - Transfers ETH to      │
               │    seller                │
               │  - Calls Catalog         │
               │  - Calls Auditor         │
               └──────────────┬──────────┘
                              │
                              ▼
               ┌─────────────────────────┐
               │         Auditor          │
               │  - Logs purchases        │
               │  - Uses tx.origin        │
               │  - Stores full history   │
               └─────────────────────────┘
📝 Smart Contracts
1️⃣ WatchCatalog.sol

Stores all watches listed for sale.

Features:

Seller-only watch creation

Price stored in wei

Custom errors

Returns watch details

Marks watches as sold

Emits events

Main Concepts Demonstrated:

Role-based access (onlySeller)

Struct/mapping storage

Validation

Proper state updates

2️⃣ Marketplace.sol

Handles the purchase process.

Features:

buyWatch() is payable

Buyer sends ETH in wei

Validates payment

Transfers funds to seller

Uses call{value: ...}() for safe ETH transfer

Calls WatchCatalog to mark watches as sold

Calls Auditor to register purchase

Implements receive() & fallback()

Main Concepts Demonstrated:

Native coin vs tokens

msg.value

send / transfer / call (used: call)

Contract-to-contract calls

Input validation with custom errors

ETH balance flows

3️⃣ Auditor.sol

Keeps a complete on-chain purchase history.

Stored Data:

Buyer (msg.sender)

Origin EOA (tx.origin)

Seller address

Watch ID

Price (wei)

Timestamp

Main Concepts Demonstrated:

tx.origin usage

Event logging

Struct-based historical records

External calls from Marketplace

💸 Payment System

The project uses native ETH, not ERC-20 tokens.

When a buyer calls:
buyWatch(watchId)

They must set the Value (wei) field in Remix.

Example for 1 ETH:
1000000000000000000

Marketplace then:

Validates the amount

Sends ETH to the seller

Marks the item as sold

Logs everything in the Auditor

🧪 How to Test (Using Remix VM)

1️⃣ Deploy Auditor.sol

(any account)

2️⃣ Deploy WatchCatalog.sol

Using AOC #1
seller = <AOC #1>

3️⃣ Deploy Marketplace.sol

Using AOC #1
_seller = <AOC #1>
_catalogAddress = <WatchCatalog address>
_auditorAddress = <Auditor address>

4️⃣ Add watches

From AOC #1:
addWatch("Rolex", "Submariner", 1000000000000000000)

5️⃣ Buy a watch

Switch to AOC #2
Set Value (wei) = watch price
Call:
buyWatch(0)

6️⃣ Check Audit Log

In Auditor:
getPurchase(0)

🌟 What This Project Demonstrates

This project shows strong understanding of Solidity fundamentals:

✔ Multi-contract architecture
✔ ETH-based payments
✔ Roles & permissions
✔ On-chain audit logging
✔ Secure state updates
✔ Contract safety patterns
✔ Native coin handling
✔ Struct-based storage
✔ Understanding of EVM behavior (msg.sender, tx.origin)
