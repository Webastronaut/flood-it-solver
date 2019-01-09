#script (python)
from math import sqrt as sq
from math import floor

def sqrt(n):
    if n.number<=0:
        return 0
    else:
        return int(floor(sq(n.number)))
#end.

% available colors
color(1..N) :- colors(N).

% direction in which cells can be connected
dir(-1..1).

% Calculation based on (as of 2018-12-18): https://kunigami.blog/2012/09/16/flood-it-an-exact-approach/
num_cells(N) :- N = #count{ X : cell(X,1,_) }.
num_colors(N) :- N = #count{ C : color(C) }.
sqrt_min(@sqrt(N)) :- num_colors(C), N=2*C.
min_steps(S) :- num_cells(N), num_colors(C), sqrt_min(M), S = ((M*N)/2) - (C/2).

% only consider cells which aren't already part of the flood
c(X,Y,C) :- cell(X,Y,C), X+Y!=2, not flood(X,Y).
% first cell is already part of the flood
flood(1,1) :- cell(1,1,_).
choose(C) :- cell(1,1,C).
step(0).

% add adjacent cells to flood set if current color matches with choose(C)
flood(X0+DX,Y0+DY) :- 
    flood(X0,Y0),
    dirs(DX,DY),
    choose(C),
    cell(X0+DX,Y0+DY,C). 

% pairs of directions of interest for determination of frontier and flood
dirs(DX,DY) :- dir(DX), dir(DY), |DX|+|DY|=1.

#program always.
% check if cells already belong to flood set
flood(X0+DX,Y0+DY) :-
	not 'flood(X0+DX,Y0+DY), % reduces runtime for some reason
    flood(X0,Y0),
    _dirs(DX,DY),
    choose(C),
    'c(X0+DX,Y0+DY,C). 

% determine direct frontier
frontier(c(X0+DX,Y0+DY),C) :- 
    _dirs(DX,DY),
    c(X0+DX,Y0+DY,C), 
    flood(X0,Y0).

% frontier of frontier
frontier(c(X0+DX,Y0+DY),C) :- 
	frontier(c(X0,Y0),C),
    _dirs(DX,DY),
    c(X0+DX,Y0+DY,C).

#program dynamic.
% count steps
step(N+1) :- 'step(N).

% get size of each subset
frontier_subset_size(C,N) :- _color(C), N = #count{ X : 'frontier(X,C) }.
% get color of biggest subset
max_subset_color(C) :- frontier_subset_size(C,N), N = #max{ M : frontier_subset_size(_,M) }.
% choose a color
1 { choose(C) : max_subset_color(C) } 1.

% inertia
flood(X,Y) :- 'flood(X,Y).
c(X,Y,C) :- 'c(X,Y,C), not flood(X,Y).

min_steps_reached :- _min_steps(S0), step(S1), S0=S1.

#program final.
:- not &tel{ <? min_steps_reached }.
:- c(X,Y,_), not flood(X,Y).

#show choose/1.
#show c/3.