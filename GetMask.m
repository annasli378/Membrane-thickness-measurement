function mask = GetMask(m)
%GETMASK Summary of this function goes here
%   Detailed explanation goes here
% INPUT: 
% m - original mask, with holes, jagged shape - 
% difficult to delineate a clean skeleton
% OUTPUT: 
% mask - smoothed mask with flooded holes

    % 1. obtaining a membrane-only mask
    mask_m = m==1;
    figure, imshow(mask_m)

    % 2. check the properties of the mask and 
    % determine the size of the structural element
    ex = regionprops(mask_m, 'Extent');
    so = strel('disk',15);
    for i =1:size(ex)
        if ex(i).Extent < 0.1
            so = strel('disk',5);
        end
    end
            
    % 3. morphological operations
    BC = imclose(mask_m, strel('disk',15)); 
    BO = imopen(BC, so); 
    BO = imdilate(BO, strel('disk',15));
    %figure, imshow(BO)

    % 4. removal of small holes
    filled = imfill(BO, 'holes');
    holes = filled & ~BO;
    bigholes = bwareaopen(holes, 18000);
    smallholes = holes & ~bigholes;

    new = BO | smallholes;

    new = imerode(new, strel('disk',15));
    new = imdilate(new, strel('disk',5));

    %figure, imshow(new)
    mask = new;
end

