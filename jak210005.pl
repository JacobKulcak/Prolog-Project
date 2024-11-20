% #1. List Product
%------------------------------------------------------------------------------
% Base case: the product of an empty list is 0.
list_prod([], 0).

% Base case for a single-element list
list_prod([X], X).

% Recursive case: the product of a non-empty list.
list_prod([H|T], Product) :-
    list_prod(T, TailProduct),
    Product is H * TailProduct.
%------------------------------------------------------------------------------



% #2. Is Prime
%------------------------------------------------------------------------------
% Base case: numbers less than or equal to 1 are not prime.
is_prime(N) :-
    N =< 1,
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
%-------------------------------------------------------------------------------



% #3. Second Minimum
% -----------------------------------------------------------------------------
is_number(X) :-
    number(X), !.
    
is_number(X) :-
    format('"ERROR: " ~w " is not a number.~n"', [X]),
    fail.


%--------------------------------------------------------------------------------
    
