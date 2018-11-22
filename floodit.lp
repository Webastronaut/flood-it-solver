% available colors
color(1..N) :- colors(N).

% direction in which cells can be connected
dir(-1..1).

#program initial.
c(X,Y,C) :- cell(X,Y,C), X+Y!=2, not flood(X,Y).
flood(1,1) :- cell(1,1,C).
choose(C) :- cell(1,1,C).

flood(X0+DX,Y0+DY) :- 
    _dir(DX), _dir(DY),
    |DX|+|DY|=1,
    choose(C),
    cell(X0+DX,Y0+DY,C), 
    flood(X0,Y0).

#program dynamic.
% check if cells already belong to flood set
flood(X0+DX,Y0+DY) :- 
    _dir(DX), _dir(DY),
    |DX|+|DY|=1,
    choose(C),
    'c(X0+DX,Y0+DY,C), 
    not 'flood(X0+DX,Y0+DY),
    flood(X0,Y0).

c(X,Y,C) :- 'c(X,Y,C), not flood(X,Y).

%% choose a color in each step, when not chosen before, a frontier exists with a matching color and the flood set
%% is not already of the same color
1 { choose(C) : _color(C), not 'choose(C), 'c(_,_,C) } 1.

% choose color wisely
floodincr :- flood(X,Y), not 'flood(X,Y).
:- not floodincr.

% inertia
flood(X,Y) :- 'flood(X,Y).

#program final.
:- c(X,Y,_), not flood(X,Y).

#show choose/1.
#show flood/2.
#show c/3.