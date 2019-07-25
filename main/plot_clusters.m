function [] = plot_clusters(cluster)

    clusters = cluster.clusters;
    cluster_min = cluster.cluster_min;
    cluster_sizes = cluster.cluster_sizes;
    
    color = ['r','b','m','k'];
    counter = 1;
    for i = 1 : length(cluster_sizes)
       for j = 1 : cluster_sizes(i)
          scatter(clusters{j,i}(1,:),clusters{j,i}(2,:),75,color(counter));
          scatter(cluster_min{j,i}(1),cluster_min{j,i}(2),75,color(counter),'filled');
          if counter == 4
              counter = 1;
          else
              counter = counter+1;
          end
       end
    end

end

