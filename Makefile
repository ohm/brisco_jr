FOREMAN = $(shell which foreman)

REBAR = ./rebar

default: test

build: clean deps compile
	rm -rf rel/package
	$(REBAR) generate -f

clean:
	$(REBAR) clean

compile:
	$(REBAR) compile

.PHONY: deps
deps:
	cd vendor && $(MAKE)
	$(REBAR) get-deps

run: deps compile
	$(FOREMAN) run erl -pa ebin deps/*/ebin -s brisco_jr

.PHONY: test
test: deps compile
	$(REBAR) eunit skip_deps=true

mrproper:
	cd vendor && $(MAKE) clean
	$(REBAR) clean
