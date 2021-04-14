function [G_all] = getEdgePotAll(graph,G)
%GETONEDGEPOT Return just the phi-11 edge potentials for all node pairs.
%
%   Returns
%       G_on: NxN matrix, 
num_node = size(graph,1);
trilgraph = tril(graph); % SH 5/5/2018
num_edge = sum(sum(logical(trilgraph)));
edge_list = zeros(num_edge,2);
[edge_list(:,2),edge_list(:,1)] = find(trilgraph);
G_all = zeros(num_node,num_node);
for i = 1:num_edge
    node_1 = edge_list(i,1);
    node_2 = edge_list(i,2);
    G_all(node_1,node_2) = G(4,i)+G(1,i)-G(2,i)-G(3,i);
end

end

%Darik changed to lower matrix, code was erroneous by SH