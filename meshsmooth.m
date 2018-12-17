function v_sm=meshsmooth(f,v)

path(path, '.\toolbox_graph');
path(path, '.\toolbox_graph\toolbox');

% mesh smoothing
options.symmetrize = 0;
options.normalize = 1; % it must be normalized for filtering
options.verb = 0; 
L = compute_mesh_laplacian(v,f,'distance',options);
options.dt = 0.3;
options.Tmax = 3.0; % adjust this value for smoothness
v_sm = perform_mesh_heat_diffusion(v',f,L,options);
v_sm = v_sm';