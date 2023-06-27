% CSPlib 075: Product Matrix Travelling Salesman Problem
% https://www.csplib.org/Problems/prob075/

%%%%% Parameters %%%%%
par int: n;
array[1..n] of int: C;
array[1..n] of int: P;

% Maximum possible cost of an edge
int: maxCost = max(C) * max(P);
% Lower bound for minimum possible cost of an edge
int: minCost = -1 * max(C) * max(P);


%%%%% Decision Variables %%%%%

% Vertex next[i] is i-th vertex on the hamiltonian path
array[1..n] of var 1..n: path;

% cost[i] is the cost of edge i on the hamiltonian path
array[1..n] of var minCost..maxCost: cost;


%%%%% Constraints %%%%%


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
solve minimize sum(cost);

output ["total cost=\(sum(cost))\n",
        "cost=\(cost)\n",
        "path=\(path)"];
