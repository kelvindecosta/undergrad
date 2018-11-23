/* STUDENT */
student('S001', 'AAA').
student('S002', 'BBB').
student('S003', 'CCC').
student('S004', 'DDD').
student('S005', 'EEE').

/* SKILL */
skill('S001', 'MUSIC').
skill('S002', 'SWIMMING').
skill('S001', 'DANCE').
skill('S004', 'DANCE').
skill('S001', 'SWIMMING').
skill('S003', 'MUSIC').
skill('S005', 'MUSIC').

/* LANGUAGE */
language('S001', 'TAMIL').
language('S002', 'KANNADA').
language('S002', 'PUNJABI').
language('S004', 'HINDI').
language('S001', 'TELUGU').
language('S003', 'URDU').
language('S005', 'KONKANI').

/* Headings */
header1:-write('SKEY'),write('  '),write('NAME'),nl.
header2:-write('SKEY'),write('  '),write('SKILL'),nl.
header3:-write('SKEY'),write('  '),write('LANGUAGE'),nl.

/* Listings */
list1(X):-header1,student(X,Y),write(X),write('  '),write(Y),nl.
list2(X):-header2,skill(X,Y),write(X),write('  '),write(Y),nl.
list3(X):-header3,language(X,Y),write(X),write('  '),write(Y),nl.

/* Queries */
query1 :- bagof(X, list1(X), _), nl.
query2 :- bagof(X, list2(X), _), nl.
query3 :- bagof(X, list3(X) ,_), nl.
query4(X) :- bagof(X, list2(X), _), nl, bagof(X, list3(X) ,_), nl.