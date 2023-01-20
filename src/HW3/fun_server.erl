%% Implements a single server that can perform several tasks in parallel.
-module(fun_server).
-behaviour(gen_server).

%% API
-export([handle_call/3, handle_cast/2, get_current_functions_count/1, calc_fun/4, start_link/1, init/1]).

%% ------ Interface Routines -------

%% Get the number of currently running functions on this server
get_current_functions_count(ServerName) ->
  gen_server:call(ServerName, fun_count).

%% Start a new function on this server, and send its return value in a message to ClientPid: {MsgRef, ReturnValue}
calc_fun(ServerName, ClientPid, ClientFun, MsgRef) ->
  gen_server:cast(ServerName, {calc_fun, ServerName, ClientPid, ClientFun, MsgRef}).

%% ------ gen_server Callback Routines -------

% Starts the server and registers it (locally) under the name ServerName
start_link(ServerName) ->
  gen_server:start_link({local, ServerName}, ?MODULE, [], []).

% State is the number of currently running functions
init([]) ->
  {ok, 0}.

handle_call(fun_count, _From, State) ->
  {reply, State, State}.

handle_cast({calc_fun, ServerName, ClientPid, ClientFun, MsgRef}, State) ->
  spawn_link( %todo spawn or spawn_link?
    fun() ->
      Res = catch ClientFun(),
      gen_server:cast(ServerName, fun_finished), % signal the server the function has finished
      ClientPid ! {MsgRef, Res}
    end),
  {noreply, State + 1};

handle_cast(fun_finished, State) ->
  {noreply, State - 1}.
