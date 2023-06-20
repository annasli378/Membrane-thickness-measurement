function widths = GetWidthsBwd(start,step, mask_atr, numBlobs)
%GETWIDTHS2 Summary of this function goes here
%   Detailed explanation goes here
% INPUT: 
% mask_atr - struct with all attributes
% show_plots - 
% OUTPUT: 
% widths - obtained widths at the measurement points

widths_good = [];
cnt=1;
% 1. for each occurrence of the membrane in the image
for i = 1:numBlobs
    skel_pix = regionprops(mask_atr(i).skel, "PixelList");
    skel_pix = skel_pix.PixelList;
    skel_len = length(skel_pix);
    stop = skel_len-start; 
    
    mask = mask_atr(i).mask;
    skelImage = mask_atr(i).skel;
    % 2. bwdist function
    edtImage = bwdist(~mask);
    % 3. Calculate diameter - width 
    diameterImage = 2 * edtImage .* single(skelImage);
    widths = diameterImage(diameterImage > 0);
    % 4. retrieve values by moving according to the set step 
    for w = start:step:stop
        widths_good(cnt) = widths(w);
        cnt=cnt+1;
    end

    % 5. plot diameters on skeleton image
    figure,
    imshow(diameterImage, [])

end

    widths = widths_good;

end

