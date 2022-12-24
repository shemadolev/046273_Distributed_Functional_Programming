-module(matrix_server).

%% API
-export([start_server/0, shutdown/0, mult/2, get_version/0, explanation/0, loop/0]).
% todo we don't want to export loop, but get an 'unused error' if not exported

%% ---- API functions

%%todo add doc'
start_server() ->
  proc_utils:start_supervised_register(?MODULE, loop, [], matrix_server).

%%todo add doc'
shutdown() ->
  matrix_server ! shutdown.

%%todo add doc'
mult(Mat1, Mat2) ->
  Pid = self(),
  MsgRef = make_ref(),
  matrix_server ! {Pid, MsgRef, {multiple, Mat1, Mat2}},
  receive
    {MsgRef, Mat} -> Mat
  end.

%%todo add doc'
explanation() ->
  erlang:error(not_implemented).

%%todo add doc'
get_version() ->
  Pid = self(),
  MsgRef = make_ref(),
  matrix_server ! {Pid, MsgRef, get_version},
  receive
    {MsgRef, VersionIdentifier} -> VersionIdentifier
  end.

%% ---- Internal functions

%% Spawns a process that calculates Mat1*Mat2 using matrix_mul module, and sends a response back to the client
mult_job(ClientPid, MsgRef, Mat1, Mat2) ->
  proc_utils:spawn_send(fun() -> Mat = matrix_mul:multiply(Mat1, Mat2), {MsgRef, Mat} end, ClientPid).

%% Main server loop, keeping its state in S
loop() ->
  receive
    shutdown -> ok;
    {Pid, MsgRef, get_version} ->
      Pid ! {MsgRef, version_6},
      loop();
    {Pid, MsgRef, {multiple, Mat1, Mat2}} ->
      mult_job(Pid, MsgRef, Mat1, Mat2),
      loop();
    sw_upgrade ->
      ?MODULE:loop();
    _ ->
      %Unknown msg, ignore it
       loop()
  end.
