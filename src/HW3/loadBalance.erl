%% API module for the application of 3 supervised severs that can run tasks in parallel, by request.
-module(loadBalance).

%% API
-export([startServer/0, stopServers/0, numberOfRunningFunctions/1, calcFun/3]).

%% Starts all servers.
startServer() ->
  erlang:error(not_implemented).

%% Stops all servers.
stopServers() ->
  erlang:error(not_implemented).

%% Gets the number of one of the servers; Returns the number of functions that server is running now.
numberOfRunningFunctions(_ServerNumber) ->
  erlang:error(not_implemented).

%% Gets the client's PID, a function, and some MsgRef; Returns ok, executes the function on the least busy server and
%% when done sends a message back to the client's PID with {MsgRef, Result}, where Result is the returned value from the
%% function.
calcFun(_ClientPID, _ClientFun, _MsgRef) ->
  erlang:error(not_implemented).
