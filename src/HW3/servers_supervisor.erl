%% This is a supervisor module for running instances of fun_severs
-module(servers_supervisor).
-behaviour(supervisor).

%% API
-export([init/1, start_link/0]).

start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
  Server1 = {server1,{fun_server, start_link, [server1]},
  permanent, brutal_kill, worker, [fun_server]},
  Server2 = {server2,{fun_server, start_link, [server2]},
  permanent, brutal_kill, worker, [fun_server]},
  Server3 = {server3,{fun_server, start_link, [server3]},
  permanent, brutal_kill, worker, [fun_server]},
  {ok,{{one_for_one,1,1}, [Server1, Server2, Server3]}}.

