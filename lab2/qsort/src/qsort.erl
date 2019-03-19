%%%-------------------------------------------------------------------
%%% @author stormtrooper
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 29. mar 2018 11:41
%%%-------------------------------------------------------------------
-module(qsort).
-author("stormtrooper").

%% API
-export([qs/1]).
-export([randomElems/3]).
-export([compareSpeeds/3]).
-export([map/2]).
-export([filter/2]).
-export([suma/1]).
-export([losuj/0]).

lessThan(L,X) -> [A || A <- L, A<X].

grtEqThan(L,X) -> [A || A <- L, A>=X].

qs([P|T]) -> qs(lessThan(T,P))++[P]++qs(grtEqThan(T,P));
qs([]) -> [].

randomElems(N,Min,Max) -> [rand:uniform(Max-Min+1)+Min-1 || _ <- lists:seq(1,N)].

compareSpeeds(L,F1,F2) -> {T1,_}=timer:tc(F1,[L]),
                          {T2,_}=timer:tc(F2,[L]),
                          [T1,T2].

map(F,L) -> [F(X) || X <- L].

filter(F,L) -> [X || X <- L, F(X)==true].

suma(N) -> lists:foldl(fun (X,Y) -> X+Y end,0,[X-48 || X <- integer_to_list(N)]).

losuj() -> lists:filter(fun (X) -> suma(X) rem 3==0 end,randomElems(1000000,0,100)).