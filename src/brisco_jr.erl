-module(brisco_jr).

%% API
-export([start/0]).

%%
%% API
%%

start() -> start(?MODULE).

%%
%% Private
%%

start(App) ->
    start_with_dependencies(App, application:start(App, permanent)).

start_with_dependencies(App, {error, {not_started, Dependency}}) ->
    start(Dependency),
    start(App);
start_with_dependencies(_App, {error, {already_started, _App}}) -> ok;
start_with_dependencies(_App, ok) ->  ok;
start_with_dependencies(App, {error, Reason}) ->
    exit("Application '~s' start failed with ~p", [App, Reason]).
