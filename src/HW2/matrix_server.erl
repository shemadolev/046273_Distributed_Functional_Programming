-module(matrix_server).

%% API
-export([start_server/0, shutdown/0, mult/2, get_version/0, explanation/0]).

%% ---- API functions

%%todo add doc'
start_server() ->
  erlang:error(not_implemented).

%%todo add doc'
shutdown() ->
  erlang:error(not_implemented).

%%todo add doc'
mult(_Mat1, _Mat2) ->
  erlang:error(not_implemented).

%%todo add doc'
explanation() ->
  erlang:error(not_implemented).

%%todo add doc'
get_version() ->
  erlang:error(not_implemented).

%% ---- Internal functions

%% Spawns a process that calculates Mat1*Mat2 using matrix_mul module, and sends a response back to the client
%%mult_job(ClientPid,MsgRef,Mat1, Mat2) ->
%%  erlang:error(not_implemented).
%%
%%%% Main server loop, keeping its state in S
%%loop(S) -> %%TODO do we really need S?
%%  erlang:error(not_implemented).
