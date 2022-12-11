%% Unit tests for matrix_mul module
-module(matrix_mul_test).

-include_lib("eunit/include/eunit.hrl").

matrix_mul(Mat1, Mat2) ->
  % Return here Mat1 multiplied by Mat2
%%  erlang:error(not_implemented).
  matrix_mul(Mat1, Mat2).

simple_test() ->
  ?assertEqual({{1}}, matrix_mul({{1}}, {{1}})),
  ?assertEqual({{11}}, matrix_mul({{1, 2}}, {{3}, {4}})).

mul3x3_test() ->
  A = {{11, 7, 2, 0}, {13, 1, 4, 13}, {0, 10, 3, 5}, {12, 4, 3, 11}},
  B = {{14, 2, 5, 8}, {10, 10, 4, 4}, {11, 17, 11, 19}, {9, 18, 13, 1}},
  C = {{2, 12, 15, 20}, {2, 1, 1, 18}, {3, 19, 18, 16}, {13, 15, 19, 10}},

  %%Expected results:
  AA = {{212, 104, 56, 101}, {312, 184, 81, 176}, {190, 60, 64, 200}, {316, 162, 82, 188}},
  AB = {{246, 126, 105, 154}, {353, 338, 282, 197}, {178, 241, 138, 102}, {340, 313, 252, 180}},
  AC = {{42, 177, 208, 378}, {209, 428, 515, 472}, {94, 142, 159, 278}, {184, 370, 447, 470}},
  BA = {{276, 182, 75, 139}, {288, 136, 84, 194}, {570, 280, 180, 485}, {345, 215, 132, 310}},
  BB = {{343, 277, 237, 223}, {320, 260, 186, 200}, {616, 721, 491, 384}, {458, 437, 273, 392}},
  BC = {{151, 385, 454, 476}, {104, 266, 308, 484}, {336, 643, 741, 892}, {106, 388, 406, 722}},
  CA = {{418, 256, 157, 451}, {251, 97, 65, 216}, {472, 284, 184, 513}, {458, 336, 173, 400}},
  CB = {{493, 739, 483, 369}, {211, 355, 259, 57}, {574, 790, 497, 458}, {631, 679, 464, 535}},
  CC = {{333, 621, 692, 696}, {243, 314, 391, 255}, {306, 637, 692, 850}, {243, 682, 742, 934}},

  ?assertEqual(AA, matrix_mul(A, A)),
  ?assertEqual(AB, matrix_mul(A, B)),
  ?assertEqual(AC, matrix_mul(A, C)),
  ?assertEqual(BA, matrix_mul(B, A)),
  ?assertEqual(BB, matrix_mul(B, B)),
  ?assertEqual(BC, matrix_mul(B, C)),
  ?assertEqual(CA, matrix_mul(C, A)),
  ?assertEqual(CB, matrix_mul(C, B)),
  ?assertEqual(CC, matrix_mul(C, C)).

mul_various_test() ->
  M1x3 = {{23, 12, 20}},
  M3x3 = {{5, 8, 25}, {21, 1, 21}, {0, 3, 9}},
  M3x2 = {{29, 11}, {1, 23}, {13, 24}},
  M2x1 = {{5}, {15}},

  ?assertEqual({{939, 1009}}, matrix_mul(M1x3, M3x2)),
  ?assertEqual({{367, 256, 1007}}, matrix_mul(M1x3, M3x3)),
  ?assertEqual({{193, 123, 518}, {126, 232, 735}, {63, 30, 144}}, matrix_mul(M3x3, M3x3)),
  ?assertEqual({{478, 839}, {883, 758}, {120, 285}}, matrix_mul(M3x3, M3x2)),
  ?assertEqual({{310}, {350}, {425}}, matrix_mul(M3x2, M2x1)),
  ?assertEqual({{115, 60, 100}, {345, 180, 300}}, matrix_mul(M2x1, M1x3)).
