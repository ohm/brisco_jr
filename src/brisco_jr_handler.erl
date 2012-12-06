-module(brisco_jr_handler).

%% Callbacks
-export([init/3, handle/2, terminate/2]).

%%
%% Callbacks
%%

init(_Transport, Req, []) -> {ok, Req, undefined}.

handle(Req, State) ->
    {ok, Req2} = cowboy_req:reply(200, [], counter_json(), Req),
    {ok, Req2, State}.

terminate(_Req, _State) -> ok.

%%
%% Private
%%

counter_json() ->
    brisco_jr_json:encode(brisco_jr_counter:list()).
