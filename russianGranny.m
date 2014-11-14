function matched_cpstruct = russianGranny(cpstruct,im0,im1)
    patch_size = 40;
    downsampled_size = 8;
    
    % im2col, then select correct patches
    % based on ids -- might be... too intense for my computer.
    % let's go the slower and more reliable route!  ain't even that slow.
    ctrs0 = cpstruct.inputPoints;
    ctrs1 = cpstruct.basePoints;
    
    patches0 = zeros(size(ctrs0,1),patch_size,patch_size,3);
    patches1 = zeros(size(ctrs1,1),patch_size,patch_size,3);
    
    for i_0 = [1:size(ctrs0,1)]
        ctr = ctrs0(i_0,:);
        patches0(i_0,:,:,:) = im0(ctr(2)-patch_size/2+1:ctr(2)+patch_size/2, ...
                                  ctr(1)-patch_size/2+1:ctr(1)+patch_size/2, :);
    end
    
    for i_1 = [1:size(ctrs1,1)]
        ctr = ctrs1(i_1,:);
        patches1(i_1,:,:,:) = im1(ctr(2)-patch_size/2+1:ctr(2)+patch_size/2, ...
                                  ctr(1)-patch_size/2+1:ctr(1)+patch_size/2, :);
    end
    
    % now, from big patches we need to generate smaller patches
    patches0 = patches0(:,[1:patch_size/downsampled_size:patch_size],[1:patch_size/downsampled_size:patch_size],:);
    patches1 = patches1(:,[1:patch_size/downsampled_size:patch_size],[1:patch_size/downsampled_size:patch_size],:);
    
    % now that we haz patches, we need to normalize 'em
    % subtract mean, divide by std_dev
    % not feeling clever enough to do with vectors, will do with for ;)
    for i_0 = [1:size(ctrs0,1)]
        col = reshape(patches0(i_0,:,:,:),downsampled_size*downsampled_size,3);
        means = mean(col);
        stds = std(col);
        patches0(i_0,:,:,1) = (patches0(i_0,:,:,1)-means(1))/stds(1);
        patches0(i_0,:,:,2) = (patches0(i_0,:,:,2)-means(2))/stds(2);
        patches0(i_0,:,:,3) = (patches0(i_0,:,:,3)-means(3))/stds(3);
    end
    for i_1 = [1:size(ctrs1,1)]
        col = reshape(patches1(i_1,:,:,:),downsampled_size*downsampled_size,3);
        means = mean(col);
        stds = std(col);
        patches1(i_1,:,:,1) = (patches1(i_1,:,:,1)-means(1))/stds(1);
        patches1(i_1,:,:,2) = (patches1(i_1,:,:,2)-means(2))/stds(2);
        patches1(i_1,:,:,3) = (patches1(i_1,:,:,3)-means(3))/stds(3);
    end
    
    % TODO: valkyrie: for some reason the things that come out of the part
    % above are totally ridiculous-looking?  wtf??
    
    % now that we have descriptors, we want to take 'em and see how they
    % match up.
    pairs = [];
    ratio_thresh = .4;
    for i = [1:size(patches0,1)]
        p_i = patches0(i,:,:,:);
        best_jd = 0;
        best_score = 999;
        second_best_score = 999;
        for j = [1:size(patches1,1)]
            p_j = patches1(j,:,:,:);
            dist = sum([dist2(squeeze(p_i(:,:,1)), squeeze(p_j(:,:,1))), ...
                        dist2(squeeze(p_i(:,:,2)), squeeze(p_j(:,:,2))), ...
                        dist2(squeeze(p_i(:,:,3)), squeeze(p_j(:,:,3)))]);
            if dist < second_best_score
                if dist < best_score
                    second_best_score = best_score;
                    best_score = dist;
                    best_jd = j;
                else
                    second_best_score = dist;
                end
            end
        end
        if best_score / second_best_score < ratio_thresh
            pairs = [pairs,i,best_jd];
        end
    end
    
    pairs = reshape(pairs,2,size(pairs,2)/2);
    pairs = pairs.';
    
    matched_cpstruct = struct;
    matched_cpstruct.inputPoints = ctrs0(pairs(:,1),:);
    matched_cpstruct.basePoints = ctrs1(pairs(:,2),:);
end