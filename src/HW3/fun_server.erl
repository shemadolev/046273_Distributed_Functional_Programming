%% Implements a single server that can perform several tasks in parallel.
-module(fun_server).
-behaviour(gen_server).

%% API
-export([init/1, handle_call/3, handle_cast/2, start_link/0, get_current_functions_count/0, calc_fun/3]).

%% ------ Interface Routines -------

%% Get the number of currently running functions on this server
get_current_functions_count() ->
  gen_server:call(fun_server, fun_count).

%% Start a new function on this server, and send its return value in a message to ClientPid: {MsgRef, ReturnValue}
calc_fun(ClientPid, ClientFun, MsgRef) ->
  gen_server:cast(fun_server, {calc_fun, ClientPid, ClientFun, MsgRef}).

%% ------ gen_server Callback Routines -------

start_link() ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init(_Args) ->
  erlang:error(not_implemented).

handle_call(_Request, _From, _State) ->
  erlang:error(not_implemented).

handle_cast(_Request, _State) ->
  erlang:error(not_implemented).
