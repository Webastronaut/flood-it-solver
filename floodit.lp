% available colors
color(1..N) :- colors(N).

% direction in which cells can be connected
dir(-1). dir(1).

#program initial.
flood(cell(1,1,C)) :- cell(1,1,C).

#program always.
%% determine frontier and flood set
% columns
frontier(cell(X,Y1,C)) :- _cell(X,Y1,C), flood(cell(X,Y0,C0)), C!=C0, Y0!=Y1, not 'flood(cell(X,Y1,_)), _dir(D), Y1=Y0-D.
flood(cell(X,Y1,C)) :- _cell(X,Y1,C), flood(cell(X,Y0,C)), Y0!=Y1, not 'flood(cell(X,Y1,C)), _dir(D), Y1=Y0-D.
% rows
frontier(cell(X1,Y,C)) :- _cell(X1,Y,C), flood(cell(X0,Y,C0)), C!=C0, X0!=X1, not 'flood(cell(X1,Y,_)), _dir(D), X1=X0-D.
flood(cell(X1,Y,C)) :- _cell(X1,Y,C), flood(cell(X0,Y,C)), X0!=X1, not 'flood(cell(X1,Y,C)), _dir(D), X1=X0-D.

#program dynamic.
%% choose a color in each step, when not chosen before, a frontier exists with a matching color and the flood set
%% is not already of the same color
1 { choose(C) : _color(C), not 'choose(C), not 'flood(cell(_,_,C)), 'frontier(cell(_,_,C)) } 1.

%% inertia
frontier(cell(X,Y,C)) :- 'frontier(cell(X,Y,C)), choose(C0), C0!=C.

%% consequence of choosing a color
% add cell at frontier to flood if color matches
flood(cell(X,Y,C)) :- choose(C), 'frontier(cell(X,Y,C)).
% recolor flood set if current color and chosen one are different
flood(cell(X,Y,C)) :- 'flood(cell(X,Y,C0)), choose(C), C!=C0.

#program final.
:- _cell(X,Y,_), not flood(cell(X,Y,_)).

#show choose/1.