-module(brisco_jr_counter_test).

-include_lib("eunit/include/eunit.hrl").

-define(SUBJECT, brisco_jr_counter).

list_test() ->
    ?assertEqual([], ?SUBJECT:list()).

increment_test() ->
    ?assertEqual(ok, ?SUBJECT:increment(123)),
    ?assertEqual([[123, 1]], ?SUBJECT:list()).
