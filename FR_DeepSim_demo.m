% Example for using FR_DeepSim

clear all
close all
clc

% ConNet Model
net = load('data\imagenet-vgg-verydeep-16.mat') ;
layerN = length(net.layers);
load featmapN
setup;

% Settings
ResizeFlag = 1;
poolMethod = 'Avg';
poolNames = {'SD', 'MAD', 'FD', 'percentile', 'Avg'};

% reference image
imgRef = imread('imageRef.bmp');

% distorted (test) image
imgDis = imread('imageDis.bmp');

% Quality Estimation: each layer corresponds to a score 
tic
quality = FR_DeepSim(imgRef, imgDis, net, poolMethod, ResizeFlag);
toc

% average pooling
quality_avg = pooling(quality, 'Avg');

% average pooling
quality_pcnt = pooling(quality, 'percentile', 0.1);

figure(1), 
subplot(121), imshow(imgRef)
subplot(122), imshow(imgDis), title(num2str([quality_avg, quality_pcnt], 3))
