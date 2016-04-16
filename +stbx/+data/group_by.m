function varargout = group_by( X, G )
% GROUP_BY splits the data in X by categories in C. 
% 
% B = GROUP_BY(X, G) -- returns data in X binned/grouped by unique rows in 
%   G. The data is put into cell array B which contains sub-arrays of X.
% X can be any n-d array. G can be a column vector or a matrix. X will be
% split along the dimension that matches the first dimentsion of G (number
% of rows in G). If more than one of X's dimensions matches the number of
% rows in G, GROUP_BY works along the forst one.
% 
% [B,C] = also returns the caterories corresponding with each bin in C.
%   The type / class of C is the same as G. 
%
% [B,C,R] = also returns the corresponding indices of data in X.
%
% <TODO>
% -- this is the way it should be done in the future, for now it'll work with
%    matrices only.
% -- also maybe we can add a 'stable' optional parameter to forward into
%    unique.
% </TODO>
%
%

% for now we assume that:
% -- X and G have the same number of rows.
% -- X is at most 2D.

% find unique rows in G
if iscellstr(G)
    [C,~,IC] = uniquerows_cellstr(G); 
else
    [C,~,IC] = unique(G,'rows','stable');
end

B = accumarray(IC, X, [], @(x) {x});        

varargout = cell(1,nargout);

if nargout >= 0
    varargout{1} = B;
end

if nargout >= 2
    varargout{2} = C;
end

if nargout >= 3
    varargout{3} = accumarray(IC, (1:size(X,1)).', [], @(x) {x});
end

if nargout >= 4
    error('Too many outputs.');
end

end

function [C, IA, IC] = uniquerows_cellstr(A)
% Quick a dirty implementation of unique(...,'rows') for cellstr case.
% Apparently builtin unique does not support the 'rows' parameter for
% cellstr inputs. Assumes A is cellstr. Outputs are the same as with
% builtin unique. 
% See also: 
%   unique
[~,~,IC] = arrayfun(@(u) unique(A(:,u)), 1:size(A,2), 'UniformOutput', false); 
[~, IA, IC] = unique([IC{:}], 'rows','stable');
C = A(IA,:);
end

% % % function [C, IA, IC] = uniquerows_cellstr_old(A)
% % % % ~~~~ Obsolete slow version ~~~~
% % % % Quick a dirty implementation of unique(...,'rows') for cellstr case.
% % % % Apparently builtin unique does not support the 'rows' parameter for
% % % % cellstr inputs. Assumes A is cellstr. Outputs are the same as with
% % % % builtin unique. 
% % % % See also: 
% % % %   unique
% % % A_ = arrayfun(@(u) strcat(A{u,:}), 1:size(A,1), 'UniformOutput', false);
% % % [~, IA, IC] = unique(A_,'stable');
% % % C = A(IA,:);
% % % end
% % % 