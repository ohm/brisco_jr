FOREMAN = $(shell which foreman)

REBAR = $(shell which rebar)

default: test

build: deps compile
	rm -rf rel/package
	$(REBAR) generate -f

clean:
	$(REBAR) clean

compile:
	$(REBAR) compile

.PHONY: deps
deps:
	$(REBAR) get-deps

run: deps compile
	$(FOREMAN) run erl -pa ebin deps/*/ebin -s brisco_jr

.PHONY: test
test: deps compile
	$(REBAR) eunit skip_deps=true
