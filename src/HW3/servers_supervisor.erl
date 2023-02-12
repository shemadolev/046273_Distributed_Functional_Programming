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
    #{id => ServerName, % child id
      start => {fun_server, start_link, [ServerName]}, %  unction call used to start the child process
      restart => permanent, % when a terminated child process is to be restarted
      shutdown => brutal_kill, % how a child process is to be terminated
      type => worker, % whether a supervisor or worker
      modules => [fun_server]} % [callback_module] if the child process is a supervisor / gen_server
    || ServerName <- [server1, server2, server3]],
  {ok, {
    #{strategy => one_for_one, % one_for_all | one_for_one | rest_for_one | simple_one_for_one
      % If more than <intensity> number of restarts occur in the last <period> seconds, the supervisor terminates
      intensity => 10,
      period => 10},
    Servers}}. % Child specs

stop_all() ->
  exit(whereis(?MODULE), kill).
