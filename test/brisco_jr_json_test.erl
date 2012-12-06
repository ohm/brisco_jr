-module(brisco_jr_json_test).

-include_lib("eunit/include/eunit.hrl").

-define(SUBJECT, brisco_jr_json).

unnested_test() ->
    Payload = <<"{\"body\":123}">>,
    ?assertEqual(123, ?SUBJECT:parse(Payload, <<"body">>)).

unnested_siblings_test() ->
    Payload = <<"{\"abc\":1, \"body\":123}">>,
    ?assertEqual(123, ?SUBJECT:parse(Payload, <<"body">>)).

nested_siblings_test() ->
    Payload = <<"{\"x\":{\"abc\":1, \"body\":123}}">>,
    ?assertEqual(123, ?SUBJECT:parse(Payload, <<"body">>)).
