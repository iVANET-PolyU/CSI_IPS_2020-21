function [csi] = getcsilink(csi4d,ntx,nrx,numsamples)
%% Converts 4D data matrix into 2D data matrix
% Rows are samples. Columns are subcarriers.
% Prepared by Josyl Rocamora (HKPolyU 2020)
%
% Returns datamatrix containing samples x subcarriers
% Retain only few samples (if enabled)

csi = []; 
for c1 = 1:ntx 
    for c2 = 1:nrx
        csi = [csi, csi4d(:,:,c1,c2)]; 
    end
end
    
csi = csi(find(any(csi,2)==1),:); % Retain only nonzero csi row vectors

if nargin == 3, [numsamples,~,~,~] = size(csi4d); end   % Retain all remaining
csi = csi(1:numsamples,:);
    
end