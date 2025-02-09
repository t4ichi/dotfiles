all: init brew defaults link 

init: .bin/init.sh
	@echo "Running init.sh..."
	@if [ ! -x .bin/init.sh ]; then chmod +x .bin/init.sh; fi
	@.bin/init.sh

brew: .bin/brew.sh
	@echo "Running brew.sh..."
	@if [ ! -x .bin/brew.sh ]; then chmod +x .bin/brew.sh; fi
	@.bin/brew.sh

defaults: .bin/defaults.sh
	@echo "Running defaults.sh..."
	@if [ ! -x .bin/defaults.sh ]; then chmod +x .bin/defaults.sh; fi
	@.bin/defaults.sh

link: .bin/link.sh
	@echo "Running link.sh..."
	@if [ ! -x .bin/link.sh ]; then chmod +x .bin/link.sh; fi
	@.bin/link.sh
