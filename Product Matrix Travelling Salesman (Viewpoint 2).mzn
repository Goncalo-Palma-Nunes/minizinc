% CSPlib 075: Product Matrix Travelling Salesman Problem
% https://www.csplib.org/Problems/prob075/

include "arg_max.mzn";

%%%%% Parameters %%%%%
par int: n;
array[1..n] of int: C;
array[1..n] of int: P;

% Maximum possible cost of an edge
int: maxCost = max(C) * max(P);
% Lower bound for minimum possible cost of an edge (assuming only positive edges)
int: minCost = min(C) * min(P);


%%%%% Decision Variables %%%%%

% pos[i] is the place that vertex i appears on the cycle
array[1..n] of var 1..n: pos;

% cost[i] is the cost of edge i on the hamiltonian path
array[1..n] of var minCost..maxCost: cost;


%%%%% Constraints %%%%%

% Since we want a cycle, it doesn't matter where we start. 
% For every possible solution there are another n-1 solutions
% (just "rotate" the cycle). Fixing the starting vertex eliminates these states
constraint
  pos[1] == 1; % Start at vertex 1

% pos[] must represent a hamiltonian cycle of the graph
constraint
  forall(i in 1..n, j in i+1..n)(pos[i] != pos[j]);
  
% The cost from vertex i to j must be C[i] * P[j]
constraint
  % For any two vertices i,j
  forall(i in 1..n, j in 1..n)
        % if j follows i then
        (if pos[j] == (pos[i] + 1) then
            % the edge from i to j costs C[i] * P[j]
            cost[pos[i]] == (C[i] * P[j])
         endif); 
                 
% Cost of returning to the starting vertex       
constraint
  cost[n] == (C[arg_max(pos)] * P[1]);
% last edge = C[last vertex] * P[first vertex]

% Minimize cost of hamiltonian circuit
solve ::int_search(pos, dom_w_deg, indomain_median)
      minimize sum(cost);

output ["total cost=\(sum(cost))\n",
        "cost=\(cost)\n",
        "pos=\(pos)\n",
        "last vertex = arg_max(pos)=\(arg_max(pos))"];