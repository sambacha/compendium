# DeFi Threat Matrix

The DeFi Threat Registry (DeFiTR) is a fork of SWC-Registry and is an implementation of the weakness classification scheme proposed in [EIP-1470](https://github.com/ethereum/EIPs/issues/1469). It is loosely aligned to the terminologies and structure used in the Common Weakness Enumeration ([CWE](https://cwe.mitre.org)) while overlaying a wide range of weakness variants that are specific to smart contracts and [ATTACK](https://attack.mitre.org) which are 

The goals of this project are as follows:

- Provide a straightforward way to classify security issues in smart contract systems.
- Define a common language for describing security issues in smart contract systems' architecture, design, or code.
- Serve as a way to train and increase performance for smart contract security analysis tools.

## Create a new entry

Create a file with a new DeFiTR ID in the [entries](./entries) directory. Use the [template](./entries/template.md) and describe all weakness attributes. These should be just numbered in the following format:
`xyy.md` where as `x` is the category identifier and `yy` is the entry identifier. 

```
# Title 
Pick a meaningful title.

## Relationships
Link a CWE Base or Class type to the CWS variant. 
e.g.  [CWE-682: Incorrect Calculation](https://cwe.mitre.org/data/definitions/682.html)

## Description 
Describe the nature and potential impact of the weakness on the contract system. 

## Remediation
Describe ways on how to fix the weakness. 

## References 
Link to external references that contain useful additional information on the issue. 

```

## Contributing

Before you create a PR for the first time make sure you have read:

- the sections [Create a new DeFi entry](#create-a-new-defi-entry)

### Scope of Weaknesses 

DeFi-Sec should be concerned with attacks beyond source code, but rather effects of market, economic, trading, etc. 

## Table of Contents


| **Protocol / Interaction Based** | **Blockchain Transaction Based** | **Non-Blockchain Sources** | **Blockchain Sources** | **Contract Language**                                   |
|----------------------------------|----------------------------------|----------------------------|------------------------|---------------------------------------------------------|
| Market Attacks                   | Economic Attack                  | Off\-Chain                 | On\-Chain              | Solidity                                                |
| Front\-Running                   | Front\-Running                   | Price Feed                 | Timestamp Dependence   | Integer Overflow and Underflow                          |
| Coordinated Attack               | Insufficient gas griefing        | Quote Stuffing             | Admin Key              | DoS with \(Unexpected\) revert                          |
| Liquidity Pocket                 | Token Inflation                  | Spoofing                   | Timelock               | DoS with Block Gas Limit                                |
| Quote Stuffing                   | Circulating Supply Attack        | Credential Access          | Lateral Movements      | Arithmetic Over/Under Flows                             |
| Wash Trading                     | Gas Griefing \(DoS\)             | Reentrancy                 | Multi\-Sig Keys        | Forcibly Sending Ether to a Contract                    |
| Ramping The Market               | Network Congestion \(uDoS\)      | Privilage Esclation        | Miner Cartel           | Delegatecall                                            |
| Cornering The Market             |                                  | Credential Access          | Finality               | Entropy Illusion                                        |
| Churning                         |                                  | Encryption Protections     |                        | Short Address/Parameter Attack                          |
| Flash Loans                      |                                  | Phishing                   |                        | Uninitialised Storage Pointers                          |
| Aggregated Transactions          |                                  | Unicode Exploits           |                        | Floating Points and Numerical Precision                 |
| Bulge Bracket Transactions       |                                  | API                        |                        | Right\-To\-Left\-Override control character \(U\+202E\) |
| Layering                         |                                  | DNS Attacks                |                        | Delegatecall to Untrusted Callee                        |
| Spoofing                         |                                  | Transaction Pool           | Transaction Pool       | Requirement Violation                                   |
| Order Book                       |                                  | Checksum Address           |                        | Shadowing State Variables                               |
| Market Index Calculation Attack  |                                  |                            |                        | Transaction Order Dependence                            |
| Flash Crash                      |                                  |                            |                        | Assert Violation                                        |
| Repo                             |                                  |                            |                        | Uninitialized Storage Pointer                           |
| Excessive Leverage               |                                  |                            |                        | Unprotected Ether Withdrawal                            |
| "Breaking the ""Buck"""          |                                  |                            |                        | Floating Pragma                                         |
| """Fake"" News"                  |                                  |                            |                        | Outdated Compiler Version                               |
| Nested Bot                       |                                  |                            |                        | Function Default Visibility                             |
| Audience of Bots                 |                                  |                            |                        |                                                         |
| Arb\. Exploit                    |                                  |                            |                        |                                                         |
| Slippage Exploit                 |                                  |                            |                        |                                                         |
| Safety Check Exploits            |                                  |                            |                        |                                                         |
| Circulating Supply Dump          |                                  |                            |                        |                                                         |
| Governance Cartel                |                                  |                            |                        |                                                         |
| "Flash ""Straddle"" "            |                                  |                            |                        |                                                         |
| Structuring                      |                                  |                            |                        |                                                         |



## Contact

## License 


