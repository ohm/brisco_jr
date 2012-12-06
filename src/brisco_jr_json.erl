-module(brisco_jr_json).

%% API
-export([decode/1,
         encode/1,
         parse/2]).

%%
%% API
%%

decode(Value) -> jiffy:decode(Value).

encode(Value) -> jiffy:encode(Value).

parse(Payload, Search) ->
    case decode(Payload) of
        {error, _} -> unmatched;
        Decoded -> value_for_key(Decoded, Search)
    end.

%%
%% Private
%%

value_for_key({[{Key, Value}]}, Search) ->
    case Key of
        Search -> Value;
        _ when is_tuple(Value) -> value_for_key(Value, Search);
        _ -> unmatched
    end;
value_for_key({[H|T]}, Search) ->
    case value_for_key({[H]}, Search) of
        unmatched -> value_for_key({T}, Search);
        Value -> Value
    end.
