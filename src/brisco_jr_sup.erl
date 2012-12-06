-module(brisco_jr_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Callbacks
-export([init/1]).

%%
%% API
%%

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%%
%% Callbacks
%%

init([]) ->
    {ok, _Pid} = brisco_jr_http:start_link(),
    Consumer = {brisco_jr_consumer,
                {brisco_jr_consumer, start_link, []},
                permanent, brutal_kill, worker, [brisco_jr_consumer]},
    {ok, {{one_for_one, 1, 1}, [Consumer]}}.
