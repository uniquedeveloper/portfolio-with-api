# SonarWatch Portfolio

[![Core NPM Version](https://img.shields.io/npm/v/@sonarwatch/portfolio-core?color=33cd56&label=npm%20core)](https://www.npmjs.com/package/@sonarwatch/portfolio-core)
[![Plugins NPM Version](https://img.shields.io/npm/v/@sonarwatch/portfolio-plugins?color=33cd56&label=npm%20plugins)](https://www.npmjs.com/package/@sonarwatch/portfolio-plugins)

Useful links:

- [Github repository](https://github.com/sonarwatch/portfolio)
- [API Rest](https://portfolio-api.sonar.watch/api)
- [Documentation](https://sonarwatch.github.io/portfolio/)
- [Integration Documentation](https://docs.sonar.watch/open-source/list-your-project)

This repository powers SonarWatch website by fetching all DeFi assets for a wallet on multiple chains, it covers:

- Tokens value
- NFTs (listed included)
- LP Tokens value
- Lending and borrowing amount
- Spot accounts
- Native stake accounts
- many other to come!

# How does it works?

Anyone can contribute to this repository to help us cover more protocols and create a better coverage for the user.

This repository is divided in <b>plugins</b>, each plugin can have :

- <b>Job(s)</b> : they retrieve common data for all users and store it in the <b>Cache</b>
- <b>Fetcher(s)</b> : they retrieve information for a single user and send back a list of assets

## What is a Job ?

A <b>Job</b> will store data into our <b>Cache</b>, those data are usually common data for all users (information about the amounts of a tokens on a lending protocol, liquidity pools prices, etc..)

To add data to the Cache, you will mainly use the following methods on the `cache` object :

- Add a price for a specific Token address (token, lp, etc...) : `cache.setTokenPriceSource()`
- Add any item : `cache.setItem()`

<u><b>Warning</b></u> If your Job is adding prices for tokens, make sure to verify those prices by :

1. Running your local cache.
2. Running your Job, this will add prices into your local cache.
3. Running the Fetcher `wallet-tokens-<networkId>`, this will fetch all tokens within the wallet and get the prices from the Cache (local + distant). (see below for commands)

You can create as many <b>Jobs</b> as needed by plugins.

## What is a Fetcher ?

A <b>Fetcher</b> is were the logic stand, it usually (not necessarily) recover some data from the <b>Cache</b>, then use it to compute the value of the assets deposited by a user on a protocol.

Some examples of <b>Fetchers</b> :

- Get all Concentrated Liquidity Positions of a user from an AMM
- Get all deposits and loans of a user on a Lending protocol
- Get all listed NFTs for a user on a marketplace
- etc...

You can create as many <b>Fetchers</b> as needed by plugins, each <b>Fetcher</b> being entitled to a Networkd (Solana, Sui, Aptos etc..).

You always need to provide a <b>user address</b> to run a fetcher.
