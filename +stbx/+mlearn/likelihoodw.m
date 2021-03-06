function L = likelihoodw(D, f, C, LOGFLAG)

% X -- data, rows are iid sample points, cols are dimensions. 
% f -- probability distribution / density function handle(!). must be able
%   to work with data in X in vectorized form.
% C -- counts / frequencies of occurrences of each D(i)

if ~exist('LOGFLAG', 'var') 
    LOGFLAG = 'log';
end

if ~exist('W', 'var') || isempty(C)
    C = ones(size(D));
end

assert(all(round(C)==C), 'Counts must be given as integers.')

% calculate conditional probabilities
pX = f(D).^C;
% make sure that no probability is zero
pX(pX == 0) = min(pX(pX~=0))/1e6; 


if strcmpi(LOGFLAG, 'log')
    L = sum(log(pX));
else
    L = prod(pX);
end
    
    

