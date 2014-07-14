-module(eryoed_http_callback).
-export([handle/2, handle_event/3]).

-include_lib("elli/include/elli.hrl").
-behaviour(elli_handler).

handle(Req, Args) ->
    handle(Req#req.method, elli_request:path(Req), Req, Args).

handle('GET',[<<"yoed">>], _Req, _Args) ->
    Username = elli_request:get_arg(<<"username">>, _Req),
    io:format("got a request with username: ~p\n", [Username]),
    eryoed_handlers:handle(Username),
    {ok, [], <<"ok">>};

handle(_, _, _Req, _Args) ->
    {404, [], <<"Not Found">>}.

%% @doc: Handle request events, like request completed, exception
%% thrown, client timeout, etc. Must return 'ok'.
handle_event(_Event, _Data, _Args) ->
    case _Event of
        request_error ->
            error_logger:format("request_error: ~p, ~p\n", [_Data, _Args]);
        _ -> ok
    end,
    ok.
