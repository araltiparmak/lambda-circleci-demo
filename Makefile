ZIP=lambda.zip
SRC_DIR=src
DIST_DIR=dist

.PHONY: clean build package

all: clean build package

clean:
	rm -rf $(DIST_DIR) $(ZIP)

build:
	@echo "🔧 Building TypeScript..."
	npm ci
	node build.mjs   # src/index.ts -> dist/index.cjs

package: clean build
	@echo "Packaging Lambda ZIP..."
	cd $(DIST_DIR) && zip -j ../$(ZIP) index.cjs
	@echo "$(ZIP) created."
