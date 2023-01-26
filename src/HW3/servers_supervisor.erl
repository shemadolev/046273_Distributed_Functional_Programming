%% This is a supervisor module for running instances of fun_severs
-module(servers_supervisor).
-behaviour(supervisor).

%% API
-export([init/1, start/0, stop_all/0]).

start() ->
  {ok, SupervisorPid} = supervisor:start_link({local, ?MODULE}, ?MODULE, []),
  unlink(SupervisorPid).

init([]) ->
  Servers = [
    {ServerName, {fun_server, start_link, [ServerName]}, permanent, brutal_kill, worker, [fun_server]}
    || ServerName <- [server1, server2, server3]],
  {ok, {{one_for_one, 10, 10}, Servers}}.

stop_all() ->
  exit(whereis(?MODULE), kill).
