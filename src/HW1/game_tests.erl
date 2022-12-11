%%%-------------------------------------------------------------------
%%% @author shema
%%% @copyright (C) 2022, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. נוב׳ 2022 22:42
%%%-------------------------------------------------------------------
-module(game_tests).

-include_lib("eunit/include/eunit.hrl").

canWin_test() ->
  [
    ?assert(game:canWin(1)),
    ?assert(game:canWin(2)),
    ?assertNot(game:canWin(3)),
    ?assert(game:canWin(4)),
    ?assert(game:canWin(5)),
    ?assertNot(game:canWin(6)),

    ?assertException(error, _, game:canWin(0)),
    ?assertException(error, _, game:canWin(-1)),
    ?assertException(error, _, game:canWin(-2))
  ].

nextMove_test() ->
  [
    ?assertEqual({true, 1}, game:nextMove(1)),
    ?assertEqual({true, 2}, game:nextMove(2)),
    ?assertEqual(false, game:nextMove(3)),
    ?assertEqual({true, 1}, game:nextMove(4)),
    ?assertEqual({true, 2}, game:nextMove(5)),
    ?assertEqual(false, game:nextMove(6)),

    ?assertException(error, _, game:nextMove(0)),
    ?assertException(error, _, game:nextMove(-1)),
    ?assertException(error, _, game:nextMove(-2))
  ].
