-module(game).

%% API
-export([canWin/1, nextMove/1, explanation/0]).

canWin(1) -> true;
canWin(2) -> true;
canWin(3) -> false;
canWin(N) -> not canWin(N-1) or not canWin(N-2). 

% nextMove(1) -> 1;
% nextMove(2) -> 2;
% nextMove(N) ->
%   case canWin(N) of
%     true -> 
%       case not canWin(N-1) of
%         true -> {true,1};
%         _ -> {true,2}
%       end;
%     _ -> false
%   end.

nextMove(1) -> {true,1};
nextMove(2) -> {true,2};
nextMove(3) -> false;
nextMove(N) ->
  case nextMove(N-1) of
    false -> {true,1};
    _ ->
      case nextMove(N-2) of
        false -> {true,2};
        _ -> false
      end
  end.
explanation() ->
  erlang:error(not_implemented).
