-module(brisco_jr_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_Type, _Args) ->
    brisco_jr_sup:start_link().

stop(_State) ->
    ok.
