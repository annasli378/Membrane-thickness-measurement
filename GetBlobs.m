function [struct_mask_art, blobs] = GetBlobs(maska_membrana)
%GETBLOBS Summary of this function goes here
%   Detailed explanation goes here
% input - binary mask
% output - stuct with all attributes needed, number of elements on the
% image

[labeledImage, numBlobs] = bwlabel(maska_membrana);

mask_atr = struct('mask', 0, 'skel', 0, 'edges',0);

for i = 1:numBlobs
    % PixelIdxList regionprops
    skiel = bwskel(labeledImage==i);
    edges = bwmorph(labeledImage==i,'remove');

    mask_atr(i).mask = labeledImage==i;
    mask_atr(i).skel = skiel;
    mask_atr(i).edges = edges;
end

struct_mask_art = mask_atr;
blobs = numBlobs;

end

