function matched_cpstruct = russianGranny(cpstruct,im0,im1)
    patch_size = 40;
    downsampled_size = 8;
    
    % convert image to columns of all patches, then select correct patches
    % based on ids -- might be... too intense for my computer.
    % let's go the slower and more reliable route!
    ctrs0 = cpstruct.inputPoints;
    ctrs1 = cpstruct.basePoints;
    
    patches0 = zeros(size(ctrs0(:,1)),patch_size,patch_size,3);
    patches1 = zeros(size(ctrs1(:,1)),patch_size,patch_size,3);
    
    for i_0 = 
end