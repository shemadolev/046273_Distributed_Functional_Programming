%% This is a supervisor module for running instances of fun_severs
-module(servers_supervisor).
-behaviour(supervisor).

%% API
-export([init/1, start_link/0]).

start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
  erlang:error(not_implemented).
