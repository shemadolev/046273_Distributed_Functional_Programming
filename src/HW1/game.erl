-module(game).

%% API
-export([canWin/1, nextMove/1, explanation/0]).

canWin(1) -> true; % by taking 1 match
canWin(2) -> true; % by taking 2 matches
canWin(N) -> % I can win if by one of my moves the opponent can't win
  not(canWin(N - 1) andalso canWin(N - 2)).

nextMove(1) -> {true, 1};
nextMove(2) -> {true, 2};
nextMove(N) ->
  case canWin(N - 1) of
    false -> {true, 1}; % Opponent loses if I'll take 1
    true -> case canWin(N - 2) of
              false -> {true, 2}; % Opponent loses if I'll take 2
              true -> false % No matter what I'll do, the opponent can win => I must lose
            end
  end.

explanation() ->
  {"As each function depends on a calculation of 2 steps before, an implementation with tail recursion needs to pass a state of the two previous results."}.
