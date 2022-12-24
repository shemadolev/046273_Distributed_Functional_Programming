%% Helper functions for spawning and managing processes
-module(proc_utils).

%% API
-export([spawn_send/2, start_supervised_register/2]).

%% Spawn a new process to run Func(), and send its result back in a message to Pid
spawn_send(Func, Pid) ->
  spawn(fun() -> Result = Func(), Pid ! Result end).

%% Create a supervisor to run ChildFun(), and register the worker's process under RegName
start_supervised_register(ChildFun, RegName) ->
  spawn(fun() -> restarter(ChildFun, RegName) end).

restarter(ChildFun, RegName) ->
  process_flag(trap_exit, true),
  Pid = spawn_link(ChildFun),
  register(RegName, Pid),
  receive
    {'EXIT', Pid, normal} -> ok;
    {'EXIT', Pid, shutdown} -> ok;
    {'EXIT', Pid, _} -> restarter(ChildFun, RegName)
  end.
