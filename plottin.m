run('data.m');
nElems = truss.nbElems;
nNodes = truss.nbNodes;

adjac  = zeros(truss.nbNodes); % adjacenecy matrix

for i = 1:truss.nbElems
    ids = truss.elems(i, (1:end-1)); % Node IDs
    matPropind = truss.elems(i, end); % Material Prop
    x = ids(1); % Node 1
    y = ids(2); % Node 2
    adjac(x,y) = 1; adjac(y,x) = 1;
end

dXY = truss.nodes + uxy; % Coordinates of the deformed matrix


% Plotting both the matrices
gplot(adjac, truss.nodes, "r--");
hold on;
gplot(adjac, dXY, "b");
