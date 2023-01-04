
%% Initialize Dataset
 
run('data.m');
%% Initialize Matrices
DoF = truss.Dim*truss.nbNodes;
K = zeros(DoF);
length = zeros(truss.nbElems,1);
u = zeros(DoF,1);
F = zeros(DoF,1);

%% Local Calculations
for i=1:truss.nbElems
    
    ids = truss.elems(i, (1:end-1)); % Node IDs
    matPropind = truss.elems(i, end); % Material Prop
    x = truss.nodes(ids(1), :); % Node 1
    y = truss.nodes(ids(2), :); % Node 2
    xi = x(1); xj = y(1);
    yi = x(2); yj = y(2);
    % Length of the node
    length(i) = sqrt((xi - xj)^2 + (yi - yj)^2);
    
    E = truss.mat(1, 1); % Youngs Modulus
    S = truss.mat(1, 2); % Surface Area
    
    ke =E*S*[1 -1;-1 1]/length(i); % Local K

    c = (xj - xi)/length(i); % Cosine of angle
    s = (yj - yi)/length(i); % Sin of angle

    R = [c s 0 0;
        0 0 c s]; % Rotation Matrix

    Ke = R'*ke*R; % Global K for the element; Ke
    
    n = 2*ids(1) - 1;
    p = 2*ids(2) - 1;

    K(n:n+1, n:n+1) = K(n:n+1, n:n+1) + Ke(1:2, 1:2);
    K(n:n+1, p:p+1) = K(n:n+1, p:p+1) + Ke(1:2, 3:4);
    K(p:p+1, n:n+1) = K(p:p+1, n:n+1) + Ke(3:4, 1:2);
    K(p:p+1, p:p+1) = K(p:p+1, p:p+1) + Ke(3:4, 3:4);
end


%% Loads

for n = 1:size(truss.loads, 1)
    F(2*truss.loads(n,1)-1) = truss.loads(n, 2); % X-Coordinate
    F(2*truss.loads(n,1)) = truss.loads(n, 3); % Y-Coordinate
end

%% Method 1
%---------------------

% Thined F and M
bcrem = zeros(DoF, 1);
for n = 1:size(truss.BC, 1)

  bcnode = truss.BC(n,1);
  bcrem(2*truss.BC(n,1)-1:2*truss.BC(n,1)) = truss.BC(n,2:3);

end

rmK = K(~bcrem, ~bcrem); % Removing the corresponding rows and columns of bcrem
newF = F(~bcrem); % Removing the corresponding rows of bcrem

% New U as Matrix Solution to [K]{u} = {F}
U = rmK\newF;

% Rentering the previosuly removed nodal data
j = 1;

for i = 1:size(u, 1)
  if bcrem(i) == 1
    u(i) = 0; % 0 strain because of fixed support
  else
    u(i) = U(j); % value from U as no fixed support
    j = j+1;
  end
end
for i=1:DoF/2
    uxy(i,1) = u(2*i-1);
    uxy(i,2) = u(2*i);
end
