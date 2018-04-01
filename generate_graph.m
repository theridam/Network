%% Generate the graph of the network 

function [ G,E,V,indeg,outdeg ] = generate_graph( nodelist1,nodelist2,L )

    G      = digraph(nodelist1,nodelist2,L);
    E      = numedges(G);
    V      = numnodes(G);
    indeg  = indegree(G);
    outdeg = outdegree(G);
    
end