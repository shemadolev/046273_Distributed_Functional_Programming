%% Unit tests for matrix_mul module
-module(matrix_mul_test).

-include_lib("eunit/include/eunit.hrl").

mul3x3_test() ->
  A = {{11, 7, 2, 0}, {13, 1, 4, 13}, {0, 10, 3, 5}, {12, 4, 3, 11}},
  B = {{14, 2, 5, 8}, {10, 10, 4, 4}, {11, 17, 11, 19}, {9, 18, 13, 1}},
  C = {{2, 12, 15, 20}, {2, 1, 1, 18}, {3, 19, 18, 16}, {13, 15, 19, 10}},

  %%Expected results:
  AA = {{212, 104, 56}, {312, 184, 81}, {190, 60, 64}, {316, 162, 82}},
  AB = {{246, 126, 105}, {353, 338, 282}, {178, 241, 138}, {340, 313, 252}},
  AC = {{42, 177, 208}, {209, 428, 515}, {94, 142, 159}, {184, 370, 447}},
  BA = {{276, 182, 75}, {288, 136, 84}, {570, 280, 180}, {345, 215, 132}},
  BB = {{343, 277, 237}, {320, 260, 186}, {616, 721, 491}, {458, 437, 273}},
  BC = {{151, 385, 454}, {104, 266, 308}, {336, 643, 741}, {106, 388, 406}},
  CA = {{418, 256, 157}, {251, 97, 65}, {472, 284, 184}, {458, 336, 173}},
  CB = {{493, 739, 483}, {211, 355, 259}, {574, 790, 497}, {631, 679, 464}},
  CC = {{333, 621, 692}, {243, 314, 391}, {306, 637, 692}, {243, 682, 742}},

  ?assertEqual(AA, matrix_mul:multiply(A, A)),
  ?assertEqual(AB, matrix_mul:multiply(A, B)),
  ?assertEqual(AC, matrix_mul:multiply(A, C)),
  ?assertEqual(BA, matrix_mul:multiply(B, A)),
  ?assertEqual(BB, matrix_mul:multiply(B, B)),
  ?assertEqual(BC, matrix_mul:multiply(B, C)),
  ?assertEqual(CA, matrix_mul:multiply(C, A)),
  ?assertEqual(CB, matrix_mul:multiply(C, B)),
  ?assertEqual(CC, matrix_mul:multiply(C, C)).

mul_various_test() ->
  M1x3 = {{23, 12, 20}},
  M3x3 = {{5, 8, 25}, {21, 1, 21}, {0, 3, 9}},
  M3x2 = {{29, 11}, {1, 23}, {13, 24}},
  M2x1 = {{5}, {15}},

  ?assertEqual({{939, 1009}}, matrix_mul:multiply(M1x3, M3x2)),
  ?assertEqual({{367, 256, 1007}}, matrix_mul:multiply(M1x3, M3x3)),
  ?assertEqual({{193, 123, 518}, {126, 232, 735}, {63, 30, 144}}, matrix_mul:multiply(M3x3, M3x3)),
  ?assertEqual({{478,839},{883,758},{120,285}}, matrix_mul:multiply(M3x3, M3x2)),
  ?assertEqual({{310},{350},{425}}, matrix_mul:multiply(M3x2, M2x1)),
  ?assertEqual({{115,60,100},{345,180,300}}, matrix_mul:multiply(M2x1, M1x3)).
