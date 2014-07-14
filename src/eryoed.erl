-module(eryoed).

-behaviour(application).

%% Application callbacks
-export([start/0, start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start() ->
    inets:start(),
    application:start(eryoed).

start(_StartType, _StartArgs) ->
    eryoed_sup:start_link().

stop(_State) ->
    ok.
