function points = ANMS(x,y,v,numpts)
    % Adaptive Non-Maximal Suppression
    
    pts = [x,y];
    
    % ok, we start by finding a list of radii for which each point will be
    % included in our final set of points.
    rads = zeros(size(v));
    c_robust = 0.9;
    cd_v = c_robust*v;
    D = pdist(pts,'euclidean');
    D = squareform(D);
    for i = [1:size(pts,1)]
        dists_i = D(i,:);
        strong_enoughs = ones(size(cd_v))*9999;
        strong_enoughs((cd_v - v(i)) > 0) = dists_i((cd_v - v(i)) > 0);
        [M,~] = min(strong_enoughs);
        rads(i) = M;
    end
    
    % then we find the radius that gives us numpts points
    for rad = sort(rads,'descend').'
        if(any(size(rads(rads>rad)) >= numpts))
            break;
        end
    end
    
    % now we need to make a collection of all points who are the strongest
    % in that particular radius
    points = pts(rads>rad,:);
end