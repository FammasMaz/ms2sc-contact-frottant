%% Dataset

% Variables
L = 2;
H = 1; 

% Coordinates of the nodes (Position x, Position y)
% Each row is a separate Node
truss.nodes = [0 0;
       L 0;
       L H;
       0 H;
       ];

% Number of nodes
sizeNodes = size(truss.nodes);
truss.Dim = sizeNodes(2);
truss.nbNodes = sizeNodes(1);
% Connectivity matrix for elements (Node i, Node j, Material Prop Index)
% Each row is a separate element
truss.elems = [1 2 1;
               2 3 1;
               3 4 1;
               1 4 1
               2 4 1
               1 3 1];

% Number of elems
sizeElems = size(truss.elems);
truss.nbElems = sizeElems(1);

% Boundary Conditions (Node id, x condition, y condition) 
% 1 = fixed, 0 = free
% Each row is a separate element
truss.BC = [1 1 0;
            4 1 1];

% Truss Loadings(Node id, Force in x, Force in y)
truss.loads = [3 1e6 1e6];


% Truss Materials (Modulus, Surface area)
% (Each row is a separate material)
truss.mat = [2.1e11 1e-4];



