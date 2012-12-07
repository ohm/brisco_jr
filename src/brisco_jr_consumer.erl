-module(brisco_jr_consumer).

-behaviour(gen_server).

-include("brisco_jr.hrl").

%% API
-export([start_link/0]).

%% Callbacks
-export([init/1,
         handle_call/3,
         handle_cast/2,
         handle_info/2,
         code_change/3,
         terminate/2]).

%%
%% API
%%

start_link() ->
    case gen_server:start_link({local, ?MODULE}, ?MODULE, [], []) of
        {ok, Pid} ->
            gen_server:cast(Pid, {subscribe, brisco_jr_config:amqp_uri()}),
            {ok, Pid};
        Error -> error(Error)
    end.

%%
%% Callbacks
%%

init([]) ->
    {ok, #consumer_state{exchange_name = brisco_jr_config:exchange_name(),
                         json_key = brisco_jr_config:json_key(),
                         routing_key = brisco_jr_config:routing_key()}}.

handle_call(_Request, _From, _State) -> ok.

handle_cast({subscribe, Uri}, State = #consumer_state{exchange_name = Exchange, routing_key = RoutingKey}) ->
    Connection = brisco_jr_amqp:connect(Uri),
    ok = brisco_jr_amqp:create_bindings(RoutingKey, Exchange, Connection),
    {noreply, State#consumer_state{connection = Connection}}.

handle_info(Info, State = #consumer_state{connection = Connection, json_key = Key}) ->
    case brisco_jr_amqp:receive_message(Info) of
        {DeliveryTag, Payload} ->
            brisco_jr_amqp:acknowledge(Connection, DeliveryTag),
            increment_counter(Payload, Key);
        _ -> ok
    end,
    {noreply, State}.

code_change(_OldVsn, State, _Extra) -> {ok, State}.

terminate(_Reason, #consumer_state{connection = Connection}) ->
    brisco_jr_amqp:disconnect(Connection).

%%
%% Private
%%

increment_counter(Payload, Key) ->
    case brisco_jr_json:parse(Payload, Key) of
        unmatched -> lager:error("failed to parse payload.");
        Counter ->
            lager:info("incrementing counter ~p.", [Counter]),
            brisco_jr_counter:increment(Counter)
    end.
