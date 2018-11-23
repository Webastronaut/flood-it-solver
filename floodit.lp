% available colors
color(1..N) :- colors(N).

% direction in which cells can be connected
dir(-1..1).

#program initial.
% only consider cells which aren't already part of the flood
c(X,Y,C) :- cell(X,Y,C), X+Y!=2, not flood(X,Y).
% first cell is already part of the flood
flood(1,1) :- cell(1,1,C).
choose(C) :- cell(1,1,C).

% add adjacent cells to flood set if current color matches with choose(C)
flood(X0+DX,Y0+DY) :- 
    _dir(DX), _dir(DY),
    |DX|+|DY|=1,
    choose(C),
    cell(X0+DX,Y0+DY,C), 
    flood(X0,Y0).

#program always.
% check if cells already belong to flood set
flood(X0+DX,Y0+DY) :- 
    _dir(DX), _dir(DY),
    |DX|+|DY|=1,
    choose(C),
    'c(X0+DX,Y0+DY,C), 
    not 'flood(X0+DX,Y0+DY),
    flood(X0,Y0).

frontier(c(X0+DX,Y0+DY),C) :- 
    _dir(DX), _dir(DY),
    |DX|+|DY|=1,
    c(X0+DX,Y0+DY,C), 
    flood(X0,Y0).

% frontier of frontier
frontier(c(X0+DX,Y0+DY),C) :- 
    _dir(DX), _dir(DY),
    |DX|+|DY|=1,
    c(X0+DX,Y0+DY,C), 
    frontier(c(X0,Y0),C).

#program dynamic.
% available colors
clr(C) :- 'frontier(_,C).

%% choose a color in each step based on available colors in adjacent cells
{ choose(C) : clr(C) } = 1.

% flood set must grow in each step
floodincr :- flood(X,Y), not 'flood(X,Y).
:- not floodincr.

% inertia
flood(X,Y) :- 'flood(X,Y).
c(X,Y,C) :- 'c(X,Y,C), not flood(X,Y).

#program final.
:- c(X,Y,_), not flood(X,Y).

#show choose/1.
%#show frontier/2.
%#show color/2.
%#show flood/2.
%#show c/3.