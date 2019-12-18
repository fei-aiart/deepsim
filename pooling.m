function q = pooling(Qarray, method, pcnt)
%
% by Fei Gao, Hangzhou Dianzi University, gaofeihifly@gmail.com (2016)
% Reference:
%   INPUT: Qarray: N*D, N is the number of samples, D is the number of
%   scores to each sample
%
%% ========================================================================


if nargin < 2
    method = 'Avg';  % pcnt for percentile pooling
end

if nargin < 3
    pcnt = 0.1;  % pcnt for percentile pooling
end

[SampleN, scoreN] = size(Qarray);

switch method
    case 'SD'
        q = std(Qarray, [], 2);
    case 'MAD'
        Qarray_ = bsxfun(@minus, Qarray, mean(Qarray, 2));
        q = mean(abs(Qarray_), 2); % MAD
    case 'FD'
        alpha = 0.5;
        qSD = std(Qarray, [], 2);
        Qarray_ = bsxfun(@minus, Qarray, mean(Qarray, 2));
        qMAD = mean(abs(Qarray_), 2); % MAD
        q = alpha*qSD + (1-alpha)*qMAD;
    case 'Avg'
        q = mean(Qarray, 2);
    case 'percentile'
        Qarray = sort(Qarray, 2);
        scoren = max(ceil(scoreN * pcnt),1);
        q = mean(Qarray(:, 1:scoren), 2);
    case 'All' % test all the pooling methods
        q = zeros(SampleN, 13);
        q(1) = std(Qarray, [], 2); % SD
        meanQarray = mean(Qarray);
        q(2) = mean(abs(Qarray-meanQarray)); % MAD
        alpha = 0.5;
        q(3) = alpha*q(1) + (1-alpha)*q(2);  % FD
        pcnts = 0.1:0.1:1;  % 10 settings
        Qarray = sort(Qarray, 2);
        for ipcnt = 1:10
            scoren = max(ceil(scoreN * pcnts(ipcnt)), 1);
            q(ipcnt+3) = mean(Qarray(:, 1:scoren), 2);
        end
    otherwise
        error('this pooling method is not defined')
end
