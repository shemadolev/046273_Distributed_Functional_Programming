%% API module for the application of 3 supervised severs that can run tasks in parallel, by request.
-module(loadBalance).

%% API
-export([startServer/0, stopServers/0, numberOfRunningFunctions/1, calcFun/3, test/0]).

serverNumToAtom(ServerNumber) ->
  list_to_atom(string:concat("server", integer_to_list(ServerNumber))).

%% Starts all servers.
startServer() ->
  servers_supervisor:start().

%% Stops all servers.
stopServers() ->
  servers_supervisor:stop_all().

%% Gets the number of one of the servers; Returns the number of functions that server is running now.
numberOfRunningFunctions(ServerNumber) ->
  ServerName = serverNumToAtom(ServerNumber),
  fun_server:get_current_functions_count(ServerName).

%% Gets the client's PID, a function, and some MsgRef; Returns ok, executes the function on the least busy server and
%% when done sends a message back to the client's PID with {MsgRef, Result}, where Result is the returned value from the
%% function.
calcFun(ClientPID, ClientFun, MsgRef) ->
  % Get number of running functions for each server
  AllRunning = [{serverNumToAtom(ServerNum), numberOfRunningFunctions(ServerNum)} || ServerNum <- lists:seq(1, 3)],
  % Sort servers by their number of running functions, ascending order
  SortedServers = lists:sort(fun({_ServName1, FunCount1}, {_ServName2, FunCount2}) -> FunCount1 < FunCount2 end, AllRunning),
  % First server is the one with the least running functions - execute the function there
  [{ChosenSever, _FunCount} | _Others] = SortedServers,
  fun_server:calc_fun(ChosenSever, ClientPID, ClientFun, MsgRef),
  ok.

