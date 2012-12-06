SOURCE = $(shell pwd)/sparsehash-2.0.2

DESTINATION = $(shell pwd)/../c_src/sparsehash-2.0.2

$(DESTINATION):
	cd $(SOURCE) && ./configure --prefix $(DESTINATION) && $(MAKE) && $(MAKE) install

.PHONY: clean
clean:
	cd $(SOURCE) && $(MAKE) clean
	rm -rf $(DESTINATION)
