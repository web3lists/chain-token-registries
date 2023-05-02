
.PHONY: help clean chains tokens
help:
	cat Makefile

workdir/:
	mkdir workdir

chains/cosmos.json: workdir/
	git -C workdir/chain-registry pull || git clone --depth 1 https://github.com/cosmos/chain-registry.git workdir/chain-registry
	find workdir/chain-registry -name "chain.json" -type f -exec cat {} + | jq -s '.' > chains/cosmos.json	

chains/substrate.json: 
	wget -O chains/substrate.json https://raw.githubusercontent.com/paritytech/ss58-registry/main/ss58-registry.json

chains/evm.json:
	wget -O chains/evm.json https://chainid.network/chains.json

tokens/cardano-mainnet.json: workdir/
	git -C workdir/cardano-token-registry pull || git clone https://github.com/cardano-foundation/cardano-token-registry.git workdir/cardano-token-registry
	cat workdir/cardano-token-registry/mappings/*.json | jq -s '.' > tokens/cardano-mainnet.json

tokens/ethereum-mainnet.json:
	git -C workdir/ethereum-tokens pull || git clone https://github.com/ethereum-lists/tokens.git workdir/ethereum-tokens
	cat workdir/ethereum-tokens/tokens/eth/*.json | jq -s '.' > tokens/ethereum-mainnet.json

chains: chains/cosmos.json chains/substrate.json chains/evm.json 

tokens: tokens/cardano-mainnet.json tokens/ethereum-mainnet.json

all: chains tokens

clean:
	rm -rf chains/*.json tokens/*.json workdir/*
