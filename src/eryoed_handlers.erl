-module(eryoed_handlers).

-export([start_link/1, handle/1]).

start_link(Opts) ->
    {ok, Pid} = gen_event:start_link({local, eryoed_handlers}),
    
    Handlers = proplists:get_value(handlers, Opts),
    lists:foreach(fun (E) -> add_handler_from_conf(E) end, Handlers),

    {ok, Pid}.

add_handler_from_conf([Name,Opts|_]) ->
    io:format("Adding handler ~p\n", [[Name | Opts]]),
    ok = gen_event:add_handler(eryoed_handlers, Name, Opts).

handle(Username) ->
    gen_event:notify(eryoed_handlers, {yo, Username}),
    ok.

