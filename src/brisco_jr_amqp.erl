-module(brisco_jr_amqp).

-include("brisco_jr.hrl").

-include_lib("amqp_client/include/amqp_client.hrl").

%% API
-export([acknowledge/2,
         connect/1,
         disconnect/1,
         receive_message/1,
         create_bindings/3]).

%%
%% API
%%

acknowledge(#amqp_state{channel = Channel}, DeliveryTag) ->
    amqp_channel:cast(Channel, #'basic.ack'{delivery_tag = DeliveryTag}).

connect(Uri) ->
    {ok, Connection} = amqp_connection:start(parse_uri(Uri)),
    {ok, Channel} = amqp_connection:open_channel(Connection),
    #amqp_state{connection = Connection, channel = Channel}.

create_bindings(Exchange, Queue, #amqp_state{channel = Channel}) ->
    #'exchange.declare_ok'{} = declare_exchange(Channel, Exchange),
    #'queue.declare_ok'{} = declare_queue(Channel, Queue),
    #'queue.bind_ok'{} = bind_queue(Channel, Exchange, Queue, Queue),
    #'basic.consume_ok'{} = amqp_channel:subscribe(Channel, #'basic.consume'{queue = Queue}, self()),
    ok.

receive_message({#'basic.deliver'{delivery_tag = Tag},
        #amqp_msg{payload = Payload}}) ->
    lager:info("received payload: ~p", [Payload]),
    {Tag, Payload};
receive_message(_Any) ->
    unknown.

disconnect(#amqp_state{connection = Connection, channel = Channel}) ->
    catch amqp_channel:close(Channel),
    catch amqp_connection:close(Connection),
    ok.

%%
%% Private
%%

parse_uri(Uri) ->
    case amqp_uri:parse(Uri) of
        {ok, Params = #amqp_params_network{}} -> Params;
        {error, Reason} -> error(Reason)
    end.

declare_exchange(Channel, Exchange) ->
    Declare = #'exchange.declare'{exchange = Exchange, durable = true},
    amqp_channel:call(Channel, Declare).

declare_queue(Channel, Queue) ->
    Declare = #'queue.declare'{queue = Queue, auto_delete = true},
    amqp_channel:call(Channel, Declare).

bind_queue(Channel, Exchange, Queue, RoutingKey) ->
    Bind = #'queue.bind'{exchange = Exchange, queue = Queue, routing_key = RoutingKey},
    amqp_channel:call(Channel, Bind).
