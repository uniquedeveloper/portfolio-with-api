
# How to start ?

## Setup your environment

1. <b>Clone</b> this repository.
2. Run

```bash
npm install
```

3. Setup your own `.env` file by running :

```bash
cp .env.example .env
```

4. If you need a new plugin, run :

```bash
npx nx generate @sonarwatch/portfolio-plugins:plugin my-super-protocol
```

5. Depending on what you're trying to achieve, either create a `Job` or a `Fetcher` (see commands below)

## Import your fetchers and jobs

Once you're down writing the logic on your `Job` or `Fetcher` :

1. Add your `Job`(s) and `Fetcher`(s) to your `index.ts` file in your `plugin` folder
2. Add your `Fetchers` and `Jobs` to the `packages\plugins\src\index.ts` file

## Test your job/fetcher

Before anything, you need to run the <b>Cache</b> on your local network, simply run :

```bash
npx nx run plugins:serve-cache
```

If you are adding a liquidity protocol
You're now ready to try your `Fetcher` or `Job` by running the following commands :

- Job :

```bash
npx nx run plugins:run-job jobId
```

Example :

```bash
# Run the job mango-banks
npx nx run plugins:run-job mango-banks
```

- Fetcher (remember to provide an address):

```bash
npx nx run plugins:run-fetcher fetcherId userAddress
```

Example :

```bash
# Run the fetcher mango-collateral on the address Demo...tKG
npx nx run plugins:run-fetcher kamino-farms D4iLWA42jbruHXUTdKTzCFUkzhyesYHYyFS2z5NHN7tu
```

# Useful commands

Here is a list of useful command that can help you during your integration.

```bash
# Getting started
npm install
cp .env.example .env
# Set your RPCs

# Generate a plugin
npx nx generate @sonarwatch/portfolio-plugins:plugin my-super-protocol

# Generator a job
npx nx generate @sonarwatch/portfolio-plugins:job --jobName=myJob --pluginId=my-super-protocol

# Generator a fetcher
npx nx generate @sonarwatch/portfolio-plugins:fetcher --fetcherName=myFetcher --pluginId=my-super-protocol

# Serve cache in background
npx nx run plugins:serve-cache

# Run a job
npx nx run plugins:run-job mango-banks
npx nx run plugins:run-job wallet-tokens-aptos

# Run a fetcher
npx nx run plugins:run-fetcher mango-collateral DemoSX9F2zXfQLtBr56Yr5he15P7viZWsYJpSDAX3tKG
npx nx run plugins:run-fetcher marinade-tickets DemoSX9F2zXfQLtBr56Yr5he15P7viZWsYJpSDAX3tKG
npx nx run plugins:run-fetcher wallet-tokens-aptos \"0xaa3fca2b46efb0c9b63e9c92ee31a28b9f22ca52a36967151416706f2ca138c6\"
npx nx run plugins:run-fetcher wallet-tokens-aptos aa3fca2b46efb0c9b63e9c92ee31a28b9f22ca52a36967151416706f2ca138c6
npx nx run plugins:run-fetcher wallet-tokens-ethereum-top \"0xd8dA6BF26964aF9D7eEd9e03E53415D37aA96045\"
npx nx run plugins:run-fetcher wallet-tokens-ethereum-top d8dA6BF26964aF9D7eEd9e03E53415D37aA96045

# Run a airdrop fetcher
npx nx run plugins:run-airdrop-fetcher drift-airdrop-1 DemoSX9F2zXfQLtBr56Yr5he15P7viZWsYJpSDAX3tKG

# Run transactions
npx nx run tx-parser:run DemoSX9F2zXfQLtBr56Yr5he15P7viZWsYJpSDAX3tKG
```

## Build

```bash
npx nx run core:build
npx nx run plugins:build
npx nx run tx-parser:build
```

## Deploy

```bash
npx nx run core:version --releaseAs=patch
npx nx run plugins:version --releaseAs=patch
npx nx run tx-parser:version --releaseAs=patch

npx nx run core:version --releaseAs=minor
npx nx run plugins:version --releaseAs=minor
npx nx run tx-parser:version --releaseAs=minor

npm run nx:version
```
