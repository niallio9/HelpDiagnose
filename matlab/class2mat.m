function [ diagnosis_matrix ] = class2mat( diagnosis )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% *INPUT*
%           diagnosis: CELL VECTOR or STRING VECTOR - each cell contains a
%           diagnosis of 'flexion', 'extension', or 'mixed'. These are the
%           classifications.
%
% *OUTPUT*
%           diagnosis_mat: MATRIX - a 3 x N matrix where the rows
%           correspond to the classifications above, in order.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   NJR

diagnosis_matrix = zeros(3, length(diagnosis));
for i = 1: length(diagnosis)
    if strcmp(diagnosis{i}, 'flexion')
        diagnosis_matrix(1, i) = 1;
    elseif strcmp(diagnosis{i}, 'extension')
        diagnosis_matrix(2, i) = 1;
    elseif strcmp(diagnosis{i}, 'mixed')
        diagnosis_matrix(3, i) = 1;
    else
        error('\nindex %i of the input does not correspond to a known diagnosis: flexion, extension, or mixed.\n', i)
    end
end

end

