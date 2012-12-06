-module(brisco_jr_counter).

-on_load(init/0).

%% API
-export([increment/1,
         list/0]).

%%
%% API
%%

increment(_Counter) -> exit("NIF not loaded").

list() -> exit("NIF not loaded").

%%
%% Private
%%

init() ->
    PrivDir = case code:priv_dir(brisco_jr) of
        {error, _} ->
            EbinDir = filename:dirname(code:which(?MODULE)),
            AppPath = filename:dirname(EbinDir),
            filename:join(AppPath, "priv");
        Path -> Path
    end,
    erlang:load_nif(filename:join(PrivDir, "brisco_jr_counter_nif"), 0).
