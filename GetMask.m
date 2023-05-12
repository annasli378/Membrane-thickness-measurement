function mask = GetMask(m)
%GETMASK Summary of this function goes here
%   Detailed explanation goes here


    mask_m = m==1;
    %figure, imshow(mask_m)

    ex = regionprops(mask_m, 'Extent');
    so = strel('disk',15);
    for i =1:size(ex)
        if ex(i).Extent < 0.1
            so = strel('disk',5);
        end
    end
            
    BC = imclose(mask_m, strel('disk',15)); 
    BO = imopen(BC, so); 
    BO = imdilate(BO, strel('disk',15));
    %figure, imshow(BO)

    filled = imfill(BO, 'holes');
    holes = filled & ~BO;
    bigholes = bwareaopen(holes, 10000);
    smallholes = holes & ~bigholes;

    new = BO | smallholes;

    new = imerode(new, strel('disk',15));
    new = imdilate(new, strel('disk',5));

    figure, imshow(new)

    mask = new;

end

