%% Helper functions for spawning and managing processes
-module(proc_utils).

%% API
-export([spawn_send/2, start_supervised_register/4]).

%% Spawn a new process to run Func(), and send its result back in a message to Pid
spawn_send(Func, Pid) ->
  spawn(fun() -> Result = Func(), Pid ! Result end).

%% Create a supervisor to run ChildFun(), and register the worker's process under RegName
start_supervised_register(Module, ModFunc, Args, RegName) ->
  spawn(fun() -> restarter(Module, ModFunc, Args, RegName) end).

restarter(Module, ModFunc, Args, RegName) ->
  process_flag(trap_exit, true),
  Pid = spawn_link(Module, ModFunc, Args),
  register(RegName, Pid),
  receive
    {'EXIT', Pid, normal} -> ok;
    {'EXIT', Pid, shutdown} -> ok;
    {'EXIT', Pid, _} ->
      restarter(Module, ModFunc, Args, RegName)
  end.
