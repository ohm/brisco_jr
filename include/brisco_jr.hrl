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
                         json_key :: binary() | undefined}).
