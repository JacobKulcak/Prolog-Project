% #1. List Product - list_prod(+List, -Number) =============================================================

% Base case for an empty list
list_prod([], 0).

% Base case for a single-element list
list_prod([X], X).

% Recursive case: product of a non-empty list with more than one element
list_prod([H|T], Product) :-
    list_prod(T, TailProduct),
    Product is H * TailProduct.

%===========================================================================================================




% #2. Is Prime - is_prime(+Integer) - Uses Helper Function has_divisor(+Integer, +Divisor) =================

% Base case: numbers less than or equal to 1 are not prime.
is_prime(N) :-
    N =< 1,
    !,
    fail.

% Base case: 2 is prime.
is_prime(2).

% Recursive case: check if N has any divisors from 2 up to the square root of N.
is_prime(N) :-
    N > 2,
    \+ has_divisor(N, 2).

% Helper predicate to check if there exists a divisor for N starting from Div.
has_divisor(N, Div) :-
    Div * Div =< N,        % Only check up to the square root of N
    (N mod Div =:= 0;      % If N is divisible by Div, then it's not prime
     NextDiv is Div + 1,   % Otherwise, increment Div
     has_divisor(N, NextDiv)).  % Continue checking the next divisor

%===========================================================================================================




% #3. Second Minimum - secondMin(+List, -Min2) =============================================================
% Uses helpers check_number(+Int), remove_duplicates(+List, -List), min_element(+List, -Min) ===============

% Predicate to check if an element is a number.
check_number(X) :- number(X), !.
check_number(X) :-
    format("ERROR: ~w is not a number.~n", [X]),
    fail.

% Predicate to remove duplicates from a list.
remove_duplicates([], []).
remove_duplicates([H|T], Result) :-
    member(H, T),
    remove_duplicates(T, Result), !.
remove_duplicates([H|T], [H|Result]) :-
    remove_duplicates(T, Result).

% Helper to find the minimum of a list.
min_element([H|T], Min) :-
    min_element(T, H, Min).
min_element([], Min, Min).
min_element([H|T], CurrentMin, Min) :-
    H < CurrentMin, min_element(T, H, Min).
min_element([H|T], CurrentMin, Min) :-
    H >= CurrentMin, min_element(T, CurrentMin, Min).

% Main predicate secondMin/2 to find the second minimum unique element.
secondMin(List, Min2) :-

    % Ensure all elements are numbers.
    maplist(check_number, List),

    % Remove duplicates.
    remove_duplicates(List, UniqueList),

    % Check if there are at least two unique elements.
    length(UniqueList, Length),
    Length >= 2, !,

    % Find the first minimum.
    min_element(UniqueList, Min1),

    % Remove the first minimum from the list.
    delete(UniqueList, Min1, RemainingList),
    
    % Find the second minimum in the remaining list.
    min_element(RemainingList, Min2).

% Error case for lists with fewer than two unique elements.
secondMin(List, _) :-
    remove_duplicates(List, UniqueList),
    length(UniqueList, Length),
    Length < 2,
    writeln("ERROR: List has fewer than two unique elements."),
    fail.

%=======================================================================================================




% #4. Classify - classify(+Pred, +List, -List1, -List2) ================================================
% Uses helper even(+Int) in case no built-in even predicate ============================================

% Base case: an empty list should result in two empty lists.
classify(_, [], [], []).

% Recursive case: if the head of the list satisfies Pred, add it to List1.
classify(Pred, [H|T], [H|List1], List2) :-
    call(Pred, H), % Check if Pred holds for H
    classify(Pred, T, List1, List2).

% Recursive case: if the head of the list does not satisfy Pred, add it to List2.
classify(Pred, [H|T], List1, [H|List2]) :-
    \+ call(Pred, H), % Check if Pred does not hold for H
    classify(Pred, T, List1, List2).

even(X) :-
    0 is X mod 2.

%=======================================================================================================




% #5. Bookends - bookends(+Prefix, +Suffix, +List3) ====================================================
% Uses Helpers is_prefix(+Prefix, +List3) and is_suffix(+Suffix, +List3) ===============================

bookends(Prefix, Suffix, List3) :-
    is_prefix(Prefix, List3),
    is_suffix(Suffix, List3).

is_prefix([], _).

is_prefix([H1|T1], [H2|T2]) :-
    H1 =:= H2,
    is_prefix(T1, T2).

is_suffix([], _).

is_suffix(Suffix, List3) :-
    length(Suffix, N),
    last_n(Suffix, N, LastN1),
    last_n(List3, N, LastN2),
    LastN1 = LastN2.

last_n(List, N, List) :-
    length(List, N).

last_n([_|T], N, LastN) :-
    length([_|T], Length),
    Length > N,
    last_n(T, N, LastN).

%========================================================================================================




% #6. Subslice - subslice(+Sub, +List) ==================================================================

subslice([], _).

subslice(_, []) :-
    fail.

subslice([H1|T1], [H2|T2]) :-
    H1 = H2,
    subslice(T1, T2).

subslice(List, [_|T1]) :-
    subslice(List, T1).

%========================================================================================================




% #7. Rotate - rotate(+InputList, +Integer, -RotatedList) ===============================================
% Uses helper split_at() ================================================================================

% For base case, first list is empty, return empty list in third parameter
rotate([], 0, []).

% For base case where Num is 0, make rotated equal to List
rotate(List, 0, List).

% For case where num is positive, move head of list to end of result list
rotate(List, Num, Result) :-
    Num > 0,
    length(List, Len),           % Get the length of the list
    NewNum is Num mod Len,       % Handle cases where Num is larger than the list length
    split_at(NewNum, List, Front, Back),  % Split the list at the NewNum position
    append(Back, Front, Result).   % Concatenate the back part and the front part

% For case where Num is negative, meaning the list needs to be shifted the opposite direction. Combat this by shifting the other direction by L + -N times.
rotate(List, Num, Result) :-
    Num < 0,
    length(List, Len),           % Get the length of the list
    NewNum is Num + Len,       % Handle cases where Num is larger than the list length
    rotate(List, NewNum, Result).

% Split the list at position N
split_at(0, List, [], List).

split_at(N, [H|T], [H|Front], Back) :-
    N > 0,
    N1 is N - 1,
    split_at(N1, T, Front, Back).

%=========================================================================================================




% #8. Luhn - luhn(+Integer) ==============================================================================
% Uses a lot of helpers

% Main predicate for Luhn algorithm
luhn(Num) :-
    num_to_list(Num, List),
    % reverse(List, RevList),
    sum_odd_digits(List, 1, S1),
    x2_even_digits(List, 1, S2),
    S3 is S1 + S2,
    X is S3 mod 10,
    X =:= 0.

% Base case: if there are no more digits to turn to list, return empty list
num_to_list(0, []).

% Recursively add last digit of Num to new list, reverse later
num_to_list(Num, [H|RestList]) :-
    Num > 0,
    H is Num mod 10,
    NewNum is Num div 10,
    num_to_list(NewNum, RestList).

% Base case: the reverse of an empty list is itself (also a base case for any other list)
reverse([], []).

% Recursive case: reverse the tail of the list and append the head to the reversed tail
reverse([H|T], Reversed) :-
    reverse(T, ReversedTail),  % Recursively reverse the tail
    append(ReversedTail, [H], Reversed).  % Append the head to the reversed tail


sum_odd_digits([], _, 0).

sum_odd_digits([H|T], Num, NewSum) :-
    % if located at odd numbered digit
    Num mod 2 =:= 1,
    % locate to next index
    NewNum is Num + 1,
    % pass tail of list with new index and receive Sum from there
    sum_odd_digits(T, NewNum, Sum),
    % add first element with sum of recursive elements
    NewSum is Sum + H.

sum_odd_digits([_|T], Num, NewSum) :-
    % If at an even numbered digit
    Num mod 2 =:= 0,
    NewNum is Num + 1,
    sum_odd_digits(T, NewNum, Sum),
    % Add nothing
    NewSum is Sum + 0.

x2_even_digits([], _, 0).

x2_even_digits([H|T], Num, NewSum) :-
    % if located at even numbered digit
    Num mod 2 =:= 0,
    % locate to next index
    NewNum is Num + 1,
    % pass tail of list with new index and receive Sum from there
    x2_even_digits(T, NewNum, Sum),
    % add first element with sum of recursive elements
    X2Sum is H * 2,
    check_even(X2Sum, CheckedSum),
    NewSum is Sum + CheckedSum.

x2_even_digits([_|T], Num, NewSum) :-
    % If at an odd numbered digit
    Num mod 2 =:= 1,
    NewNum is Num + 1,
    x2_even_digits(T, NewNum, Sum),
    % Add nothing
    NewSum is Sum + 0.

% If Num is less than 10, return Num
check_even(Num, Num) :-
    Num < 10.

% If Num is greater than or equal to 10, return the last digit plus 1 since we only take 10-18
check_even(Num, Result) :-
    Num >= 10,
    Temp is Num mod 10,
    Result is Temp + 1.

%===========================================================================================================




% #9. Zebra Puzzle =========================================================================================

b(_, _, _, _, _).

black(Position) :-
	solve(Bs),
    nth0(Pos, Bs, b(black, _, _, _, _)),
    Position is Pos + 1.

denmark(Position) :-
	solve(Bs),
    nth0(Pos, Bs, b(_, denmark, _, _, _)),
    Position is Pos + 1.

solve(Bs) :-
    length(Bs, 5),

    % Leftover characteristics that were never given a rule to be defined
    member(b(orange, _, _, _, _), Bs),
    member(b(_, _, hard_rock, _, _), Bs),
    member(b(_, _, _, 200000, _), Bs),

    % Rule 1
    Bs =  [_, _, _, b(_, _, _, _, 2009), _],

    % Rule 2
    somewhere_right_of(b(_, _, _, 50000, _), b(black, _, _, _, _), Bs),  

    % Rule 3
    next_to(b(_, _, _, 150000, _), b(_, austria, _, _, _), Bs),        

    % Rule 4
    somewhere_between(b(_, _, _, 300000, _), b(_, _, _, _, 2008), b(_, _, _, 250000, _), Bs),

    % Rule 5
    somewhere_between(b(black, _, _, _, _), b(_, _, _, _, 2008), b(_, _, _, _, 2000), Bs),

    % Rule 6
    next_to(b(_, _, _, _, 2000), b(green, _, _, _, _), Bs),   

    % Rule 7
    left_of(b(_, austria, _, _, _), b(_, denmark, _, _, _), Bs),      

    % Rule 8
    somewhere_left_of(b(black, _, _, _, _), b(_, _, heavy_metal, _, _), Bs), 

    % Rule 9
    Bs =  [b(_, _, progressive, _, _), _, _, _, _],                       

    % Rule 10
    somewhere_between(b(_, _, _, 50000, _), b(yellow, _, _, _, _), b(_, _, _, 300000, _), Bs),

    % Rule 11
    left_of(b(_, slovakia, _, _, _), b(_, ireland, _, _, _), Bs),     

    % Rule 12
    somewhere_between(b(_, _, _, _, 2000), b(_, _, _, _, 2015), b(_, _, _, _, 2009), Bs),

    % Rule 13
    right_of(b(_, _, gothic, _, _), b(_, slovakia, _, _, _), Bs),     

    % Rule 14
    somewhere_between(b(_, _, _, _, 2009), b(yellow, _, _, _, _), b(_, _, _, _, 2005), Bs),

    % Rule 15
    somewhere_left_of(b(_, croatia, _, _, _), b(blue, _, _, _, _), Bs),             

    % Rule 16
    somewhere_left_of(b(blue, _, _, _, _), b(_, _, psychedelic, _, _), Bs).


left_of(A, B, Ls) :-
    append(_, [A,B|_], Ls).

right_of(A, B, Ls) :- 
    append(_, [B,A|_], Ls).

somewhere_left_of(A, B, List) :-
    append(Stuff, [B | _], List),
    member(A, Stuff).

somewhere_right_of(A, B, List) :-
    append(Stuff, [A | _], List),
    member(B, Stuff).

next_to(A,B,C):-
    left_of(A,B,C) ;
    right_of(A,B,C).

somewhere_between(A, B, C, List) :-
    somewhere_right_of(A, B, List),
    somewhere_left_of(A, C, List).

% ==========================================================================================================