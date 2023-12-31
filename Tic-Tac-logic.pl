valid_symbol(x).
valid_symbol(o).


initialize_list(N, InitValue, Row) :-
    length(Row, N),
    findall(InitValue, between(1, N, _), Row).

create_list(N, List) :-
    %N1 is N+2,
    length(List, N),  % create a list of N items
    create_sublists(N, List).  % create sublists of N items each

create_sublists(_, []).
create_sublists(N, [Row|Rows]) :-
    initialize_list(N,'*',Row), % create a sublist of N items with init value
    create_sublists(N, Rows).  % create sublists of N items each

size(N):-
   create_list(N,_).


fixed_cell(I,J,S):-
    fixed(I,J,S,_,_).

fixed(0,0,S,[[_|TH]|T],[[S|TH]|T]).

fixed(0,J,S,[[H|TH]|T],[[H|THl]|Tl]):-
    J1 is J-1,
    J1>=0,
    fixed(0,J1,S,[TH|T],[THl|Tl]);
    fixed(0,0,S,[[_|TH]|T],[[S|TH]|T]).


fixed(I,J,S,[H|T],[H|Tl]):-
    I1 is I-1,
    I1>=0,
    fixed(I1,J,S,T,Tl).


solved_cell(I,J,S):-
    solved(I,J,S,_,_).

solved(0,0,S,[[_|TH]|T],[[S|TH]|T]).

solved(0,J,S,[[H|TH]|T],[[H|THl]|Tl]):-
    J1 is J-1,
    J1>=0,
    fixed(0,J1,S,[TH|T],[THl|Tl]);
    fixed(0,0,S,[[_|TH]|T],[[S|TH]|T]).


solved(I,J,S,[H|T],[H|Tl]):-
    I1 is I-1,
    I1>=0,
    fixed(I1,J,S,T,Tl).

countx_row([],0).
countx_row([x|T],N):- countx_row(T,N1), N is N1+1.
countx_row([X|T],N):- X\=x, countx_row(T,N).

counto_row([],0).
counto_row([o|T],N):- counto_row(T,N1), N is N1+1.
counto_row([X|T],N):- X\=o, counto_row(T,N).

x_equal_o_row(L):- countx_row(L,N1), counto_row(L,N2), N1 = N2.

% get column
get_column([],_,[]).
get_column([H|T],I,[C|Tc]):-
    nth1(I,H,C),
    get_column(T,I,Tc).


:- use_module(library(clpfd)).
transpose_matrix(Matrix, Transposed) :- transpose(Matrix, Transposed).

% ?- transpose_matrix([[1,2,3],[4,5,6],[7,8,9]], T).


% all cells have value
filled_have_value([]).

filled_have_value([[]|T]):-
    filled_have_value(T).

filled_have_value([[H|Th]|T]):-
    H = *, !, fail;
    filled_have_value([Th|T]).


%
consecutive([X,X,X|_]).
consecutive([_|T]) :- consecutive(T).

no_triple([]).
no_triple([H|T]) :- \+ consecutive(H), no_triple(T).

%
duplicate(X, [X|_]).
duplicate(X, [_|T]) :- duplicate(X, T).

no_duplicate_sublists([]).
no_duplicate_sublists([H|T]) :- \+ duplicate(H, T), no_duplicate_sublists(T).

%

print_under(0).
print_under(N):-
   N1 is N-1,
    write('-'),
    print_under(N1).

print_grid([]).
print_grid([[]|T]):-
    write('|'),
    nl,
%    print_under(10),
%    nl,
    print_grid(T).

print_grid([[H|Th]|T]):-
    write('|'),write(H),
    print_grid([Th|T]).

all_cells_filled(List):-
    filled_have_value(List);
    nl,write("there is cells empty"),nl,fail.

no_tripple(List):-
    no_triple(List),
    transpose_matrix(List, C),
    no_triple(C);
    nl,write("there is tripple sympole"),nl,fail.


no_repeat(List):-
    no_duplicate_sublists(List),
    transpose_matrix(List, C),
    no_duplicate_sublists(C);
    nl,write("there is duplicated Row or Column"),nl,fail.


symbol_count_correct(List):-
    x_equal_o_row(List),
    x_equal_o_row(_).

solved(List):-
 all_cells_filled(List),!
 no_tripple(List),
 symbol_count_correct(List),
 no_repeat(List).

level1:-
    create_list(6,List1),

    write("Game building just a secound:"),nl,nl,
    fixed(0,2,x,List1,List2),
    fixed(1,2,x,List2,List3),
    fixed(2,0,x,List3,List4),
    write(List4),nl,nl,

    fixed(2,5,x,List4,List5),
    fixed(3,2,x,List5,List6),
    fixed(4,1,x,List6,List7),
    write(List7),nl,nl,

    fixed(4,5,x,List7,List8),
    fixed(5,0,o,List8,List9),
    fixed(5,4,o,List9,List10),
    print_grid(List10),nl,nl,

    write("Now we will solve the puzzle Row by Row"),nl,nl,
    solved(0,1,o,List10,List11),
    solved(0,3,o,List11,List12),
    solved(0,4,x,List12,List13),
    solved(0,5,o,List13,List14),
    write(List14),nl,nl,

    solved(1,0,o,List14,List15),
    solved(1,1,x,List15,List16),
    solved(1,3,o,List16,List17),
    solved(1,4,x,List17,List18),
    solved(1,5,o,List18,List19),
    write(List19),nl,nl,

    solved(2,1,o,List19,List20),
    solved(2,2,o,List20,List21),
    solved(2,3,x,List21,List22),
    solved(2,4,o,List22,List23),
    write(List23),nl,nl,

    solved(3,0,o,List23,List24),
    solved(3,1,x,List24,List25),
    solved(3,3,o,List25,List26),
    solved(3,4,x,List26,List27),
    solved(3,5,o,List27,List28),
    write(List28),nl,nl,

    solved(4,0,o,List28,List29),
    solved(4,2,x,List29,List30),
    solved(4,3,o,List30,List31),
    solved(4,4,o,List31,List32),
    write(List32),nl,nl,

    solved(5,1,x,List32,List33),
    solved(5,2,o,List33,List34),
    solved(5,3,x,List34,List35),
    solved(5,5,x,List35,List36),
    solved(0,0,x,List36,List37),
    print_grid(List37),nl,nl,

    solved(List37),
    nl,nl,write("puzzle solved correctly"),nl,nl,!;
    nl,nl,write("puzzle wrong"),nl,nl,fail.
























