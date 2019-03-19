%%%-------------------------------------------------------------------
%%% @author stormtrooper
%%% @copyright (C) 2018, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. mar 2018 18:28
%%%-------------------------------------------------------------------
-module(onp).
-author("stormtrooper").

%% API
-export([onp/1]).

onp(W) -> operate(string:tokens(W," "),[]).

operate(["+"|T],S) -> operate(T,calc(fun(A,B) -> A+B end,S));
operate(["-"|T],S) -> operate(T,calc(fun(A,B) -> A-B end,S));
operate(["*"|T],S) -> operate(T,calc(fun(A,B) -> A*B end,S));
operate(["/"|T],S) -> operate(T,calc(fun(A,B) -> A/B end,S));
operate(["^"|T],S) -> operate(T,calc(fun(A,B) -> math:pow(A,B) end,S));
operate(["sqrt"|T],S) -> operate(T,calc(fun(A) -> math:sqrt(A) end,S));
operate(["sin"|T],S) -> operate(T,calc(fun(A) -> math:sin(A) end,S));
operate(["cos"|T],S) -> operate(T,calc(fun(A) -> math:cos(A) end,S));
operate(["tg"|T],S) -> operate(T,calc(fun(A) -> math:tan(A) end,S));
operate(["ctg"|T],S) -> operate(T,calc(fun(A) -> 1.0/math:tan(A) end,S));
operate([],S) -> hd(S);
operate([H|T],S) -> case string:to_float(H) of
                      {error,no_float} -> operate(T,[list_to_integer(H)|S]);
                      {X,[]} -> operate(T,[X|S])
                    end.

calc(F,[A,B|T]) -> case erlang:fun_info(F,arity) of
                      {arity,1} -> [F(A)|T];
                      {arity,2} -> [F(B,A)|T]
                   end.