REBAR = $(shell which rebar)

default: test

clean:
	$(REBAR) clean

compile:
	$(REBAR) compile

.PHONY: deps
deps:
	$(REBAR) get-deps

run: deps compile
	AMQP_URI="amqp://guest:guest@localhost:5672/%2F" JSON_KEY="user_id" PORT=8080 exec erl -pa ebin deps/*/ebin -s brisco_jr

.PHONY: test
test:
	$(REBAR) eunit skip_deps=true
