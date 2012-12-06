-module(brisco_jr_config).

%% API
-export([amqp_uri/0,
         http_port/0,
         json_key/0
        ]).

%%
%% API
%%

amqp_uri() ->
    read_env_var("AMQP_URI").

http_port() ->
    list_to_integer(read_env_var("PORT")).

json_key() ->
    list_to_binary(read_env_var("JSON_KEY")).

%%
%% Private
%%

read_env_var(Name) ->
    case os:getenv(Name) of
        false -> error({env_var_unset, Name});
        Value -> Value
    end.
