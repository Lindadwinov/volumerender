function newvol=isotropicvol(orivol,orixres,oriyres,orizres)
% convert anisotropic volume to isotropic volume data using 3d interpolation


szD_a=size(orivol);          % get size of original image stack
vox_a = [orixres, oriyres, orizres];  % define size of voxel in original image stack
newres=mean([orixres oriyres orizres]);   
vox_b = [newres, newres, newres];% define size of voxel in target image stack
szD_b = ceil((size(orivol)-1).*vox_a./vox_b)+1; % set size of target image stack

% define coordinates of voxels in original image stack
[X,Y,Z]=meshgrid(...
    [0:szD_a(1)-1]*vox_a(1),...
    [0:szD_a(2)-1].*vox_a(2),...
    [0:szD_a(3)-1].*vox_a(3));

% define coordinates of voxels in interpolated image stack
[Xi,Yi,Zi]=meshgrid(...
    [0:szD_b(1)-1]*vox_b(1),...
    [0:szD_b(2)-1].*vox_b(2),...
    [0:szD_b(3)-1].*vox_b(3));

%%% interpolate Data_roi.imgvol
newvol=interp3(X,Y,Z,orivol,Xi,Yi,Zi,'linear');
newvol(isnan(newvol))=0;