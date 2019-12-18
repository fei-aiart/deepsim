function qualityArray = FR_DeepSim(imRef, imDis, net, poolMethod, ResizeFlag)
% DeepSim Index, Version 1.0
% estimate the quality of imgDis using DeepSim method, 
% 
% INPUTS:
%                imgRef: the data of the reference image M*N*3 RGB
%                imgDis: the data of the distorted image M*N*3 RGB
%                
% Fei Gao, gaofeihifly@gmail.com, Hangzhou Dianzi University, 2015.06
% Copyright(c)  All Rights Reserved.

if nargin < 2
    qualityArray = -Inf;
    warning('the number of input images are less than two\n')
    return;
end


%%

layerN = length(net.layers);
featmapN = ones(layerN, 1);
for i = 1:layerN
    switch net.layers{i}.type
        case 'conv'
            featmapN(i) = length(net.layers{i}.biases);
        otherwise
            featmapN(i) = featmapN(i-1);
    end
end

poolNames = {'SD', 'MAD', 'FD', 'percentile', 'AVG'};

if strcmp(poolMethod, 'All') == 1
    poolN = 13;
elseif iscell(poolMethod)
    poolN = length(poolMethod);
else
    poolN = 1;
end
qualityArray = zeros(layerN, poolN);

% run the CNN
imDis = single(imDis);
imRef = single(imRef);

switch ResizeFlag
    case 1
        imRef = imresize(imRef, net.normalization.imageSize(1:2)) ;
        imRef = imRef - net.normalization.averageImage ;
        imDis = imresize(imDis, net.normalization.imageSize(1:2)) ;
        imDis = imDis - net.normalization.averageImage;
    case -1
        [M, N, ~] = size(imRef);
        imNorm = zeros(size(imRef));
        imNorm(:,:,1) = imresize(net.normalization.averageImage(:,:,1), [M, N], 'nearest');
        imNorm(:,:,2) = imresize(net.normalization.averageImage(:,:,2), [M, N], 'nearest');
        imNorm(:,:,3) = imresize(net.normalization.averageImage(:,:,3), [M, N], 'nearest');
        imRef = imRef - imNorm;
        imDis = imDis - imNorm;
end

resRef = vl_simplenn(net, imRef);
resDis = vl_simplenn(net, imDis);


%% SSIM + pooling 

% if ResizeFlag == 1
%     layern = 31; % begining layer change the quality calculation method 
% else
%     layern = layerN;
% end

for ilayer = 1:layerN
    
    [H, W, ~] = size(resRef(ilayer+1).x);
    
    if H*W > 1 % not the FC or Softmax layers, dual-pooling
        
        % pool over each quality map
        Qfeatmap = zeros(featmapN(ilayer), poolN);
        for ifeatmap = 1:featmapN(ilayer)
            xRef = squeeze(resRef(ilayer+1).x(:,:,ifeatmap));
            xDis = squeeze(resDis(ilayer+1).x(:,:,ifeatmap));
            [~, Qmap] = MSSIM(xRef, xDis); % Qmap is of size H*W
            Qfeatmap(ifeatmap, :) = pooling(Qmap(:)', poolMethod);
        end
        
        % pool over each layer
        for ipool = 1:poolN
            if ipool <= 3
                qualityArray(ilayer, ipool) = ... 
                    pooling(Qfeatmap(:, ipool)', poolNames{ipool});
            else
                qualityArray(ilayer, ipool) = ... 
                    pooling(Qfeatmap(:, ipool)', 'percentile', (ipool-3)/10);
            end
        end
        
    else % the FC or Softmax layers
        
        xRef = squeeze(resRef(ilayer+1).x);
        xDis = squeeze(resDis(ilayer+1).x);
        [~, Qmap] = MSSIM(xRef, xDis);
        qualityArray(ilayer, :) = pooling(Qmap', poolMethod);

    end
    
end

qualityArray = qualityArray';

end

