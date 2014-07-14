-module(eryoed_handler_yoback).
-behavior(gen_event).

-record(state, {token}).

%% gen_event callbacks
-export([init/1, handle_event/2, handle_call/2, handle_info/2, terminate/2, code_change/3]).

init(InitArgs) ->
    State = #state{token = proplists:get_value(token, InitArgs)},
    {ok, State}.

handle_event({yo, Username}, State) ->
    io:format("Yoing back ~p\n", [Username]),
    Uri = "http://api.justyo.co/yo/",
    Body = "api_token=" ++ http_uri:encode(State#state.token)
        ++ "&username=" ++ http_uri:encode(binary_to_list(Username)),
    {ok, {{Version, Status, ReasonPhrase}, _Headers, ResponseBody}} =
        httpc:request(post, {Uri, [], "application/x-www-form-urlencoded", Body}, [], []),
    io:format("Got ~p ~p ~p; ~p\n", [Version, Status, ReasonPhrase, ResponseBody]),
    {ok, State};

handle_event(_Event, State) ->
    {ok, State}.

handle_call(_Request, State) ->
    {ok, ok, State}.

handle_info(_Info, State) ->
    {ok, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

