%%
%% Parse transforms
%%

-compile([{parse_transform, lager_transform}]).

%%
%% Records
%%

-record(amqp_state, {connection :: pid() | undefined,
                     channel :: pid() | undefined}).

-record(consumer_state, {connection = #amqp_state{},
                         exchange_name :: binary() | undefined,
                         json_key :: binary() | undefined,
                         routing_key :: binary() | undefined}).
