-include config.mk

.PHONY: help clean chains tokens
help:
	cat Makefile

chains: 
	mkdir -p workdir
	mkdir -p build/chains
	git clone --depth 1 https://github.com/cosmos/chain-registry.git workdir/chain-registry
	find workdir/chain-registry -name "chain.json" -type f -exec cat {} + | jq -s '.' > build/chains/cosmos.json	

	wget -O build/chains/substrate.json https://raw.githubusercontent.com/paritytech/ss58-registry/main/ss58-registry.json

	wget -O build/chains/evm.json https://chainid.network/chains.json

tokens:
	mkdir -p workdir
	mkdir -p build/tokens
	git clone --depth 1 https://github.com/cardano-foundation/cardano-token-registry.git workdir/cardano-token-registry
	cat workdir/cardano-token-registry/mappings/*.json | jq -s '.' > build/tokens/cardano-mainnet.json

	git clone --depth 1 https://github.com/ethereum-lists/tokens.git workdir/ethereum-tokens
	cat workdir/ethereum-tokens/tokens/eth/*.json | jq -s '.' > build/tokens/ethereum-mainnet.json

deploy:
	scp -r build/ $(DEPLOY_URL)

all: chains tokens

clean:
	rm -rf build/* workdir/*
