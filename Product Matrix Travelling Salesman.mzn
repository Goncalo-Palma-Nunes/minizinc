% CSPlib 075: Product Matrix Travelling Salesman Problem
% https://www.csplib.org/Problems/prob075/

%%%%% Parameters %%%%%
par int: n;
array[1..n] of int: C;
array[1..n] of int: P;

% Maximum possible cost of an edge
int: maxCost = max(C) * max(P);
% Lower bound for minimum possible cost of an edge (assuming only positive edges)
int: minCost = min(C) * min(P);


%%%%% Decision Variables %%%%%

% Vertex next[i] is i-th vertex on the hamiltonian path
array[1..n] of var 1..n: path;

% cost[i] is the cost of edge i on the hamiltonian path
array[1..n] of var minCost..maxCost: cost;


%%%%% Constraints %%%%%

% Since we want a cycle, it doesn't matter where we start. 
% For every possible solution there are another n-1 solutions
% (just "rotate" the cycle). Fixing the starting vertex eliminates these states
constraint
  path[1] == 1; % Start at vertex 1

% path[] must represent a hamiltonian cycle of the graph
constraint
  forall(i in 1..n, j in i+1..n)(path[i] != path[j]);
  
% The cost from vertex i to j must be C[i] * P[j]
constraint
   forall(i in 1..n-1)(cost[i] == (C[path[i]] * P[path[i+1]]));

% The cost of the the n-th vertex to the starting vertex
constraint
  cost[n] == (C[path[n]] * P[path[1]]);

% Minimize cost of hamiltonian circuit
solve ::int_search(path, dom_w_deg, indomain_random)
      minimize sum(cost);

output ["total cost=\(sum(cost))\n",
        "cost=\(cost)\n",
        "path=\(path)"];
