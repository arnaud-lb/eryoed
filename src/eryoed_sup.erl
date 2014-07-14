-module(eryoed_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->

    ElliOpts = [{callback, eryoed_http_callback}, {port, 3000}],
    ElliSpec = {
      eryoed_http,
      {elli, start_link, [ElliOpts]},
      permanent,
      5000,
      worker,
      [elli]},

    Handlers = case application:get_env(eryoed, handlers) of
        {ok, HandlerList} -> HandlerList;
        _ -> []
    end,
    HandlersOpts = [{handlers, Handlers}],
    HandlersSpec = {
      eryoed_handlers,
      {eryoed_handlers, start_link, [HandlersOpts]},
      permanent,
      5000,
      worker,
      dynamic},

    {ok, { {one_for_one, 5, 10}, [HandlersSpec, ElliSpec]} }.

