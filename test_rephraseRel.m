clear;
relation = [ rel(1, 1, 0, 2)   rel(1, -2, 2,[2 2]) ...
     rel(2,-2, 1, [2 2]) ];

[adderRel, multRel] = rephraseRel( relation );