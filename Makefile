
.PHONY: help clean 
help:
	cat Makefile

chains/cosmos.json:
	git clone --depth 1 https://github.com/cosmos/chain-registry.git cosmos
	cd cosmos; find . -name "chain.json" -type f -exec cat {} + | jq -s '.' > ../chains/cosmos.json	

chains/substrate.json:
	wget -O chains/substrate.json https://raw.githubusercontent.com/paritytech/ss58-registry/main/ss58-registry.json

chains/evm.json:
	wget -O chains/evm.json https://chainid.network/chains.json

all: chains/cosmos.json chains/substrate.json chains/evm.json

clean:
	rm -rf cosmos chains/*.json tokens/*.json
