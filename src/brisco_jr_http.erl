-module(brisco_jr_http).

%% API
-export([start_link/0]).

%%
%% API
%%

start_link() -> {ok, listener(brisco_jr_config:http_port())}.

%%
%% Private
%%

listener(Port) ->
    {ok, Pid} = cowboy:start_http(http_listener, 100, [{port, Port}], [
        {dispatch, routes()}
    ]),
    link(Pid),
    Pid.

routes() ->
    [{'_', [
        static([], [{file, <<"index.html">>}]),
        {[<<"counters.json">>], brisco_jr_handler, []},
        static(['...'], [])
    ]}].

static(Match, Opts) ->
    {Match, cowboy_static, [
        {directory, {priv_dir, brisco_jr, [<<"www">>]}},
        {mimetypes, {fun mimetypes:path_to_mimes/2, default}} | Opts
    ]}.
