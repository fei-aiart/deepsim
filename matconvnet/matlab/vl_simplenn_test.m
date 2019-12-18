clear
close
clc

% create a net structure
net.layers{1} = struct(...
    'name', 'conv1', ...
    'type', 'conv', ...
    'weights', {{ randn(10, 10, 3, 2,'single'), randn(2,1,'single')}}, ...
    'opts', {{}}, ...
    'pad', 0, ...
    'stride', 1 );
net.layers{2} = struct(...
    'name', 'relu1', ...
    'leak', 0.001,...
    'type', 'relu');

% test
data = randn(300, 500, 3, 5, 'single');
res = vl_simplenn(net, data);
[info, str] = vl_simplenn_display(net);
res_d = vl_simplenn(res, data, dzdy);