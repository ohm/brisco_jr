-module(brisco_jr_http).

%% API
-export([start_link/0]).

%%
%% API
%%

start_link() ->
    {ok, listener(brisco_jr_config:http_port())}.

%%
%% Private
%%

listener(Port) ->
    {ok, Pid} = cowboy:start_http(http_listener, 100, [{port, Port}], [
        {dispatch, [
                    {'_', [
                           {[], brisco_jr_handler, []}
                          ]}
                   ]}
    ]),
    link(Pid),
    Pid.
