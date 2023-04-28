clear all, close all,
% https://www.mathworks.com/matlabcentral/answers/1932385-how-to-measure-the-average-thickness-at-the-center-region-of-binary-image

%%
MASK  = load("CALE_OBRAZKI\Masks_filled\1_Mask.mat");
maska_membrana = MASK.BW2;
figure, imshow(maska_membrana)

%%
props = regionprops(maska_membrana, 'Area');
sortedAreas = sort([props.Area], 'descend');
[labeledImage, numBlobs] = bwlabel(maska_membrana);
%%
figure, imshow(labeledImage)

%%
mask_atr = struct('mask', 0, 'skel', 0, 'edges',0);

for i = 1:numBlobs
    % PixelIdxList regionprops
    skiel = bwskel(labeledImage==i);
    edges = bwmorph(labeledImage==i,'remove');

    mask_atr(i).mask = labeledImage==i;
    mask_atr(i).skel = skiel;
    mask_atr(i).edges = edges;
end

%%

for i = 1:numBlobs
    skel_pix = regionprops(mask_atr(i).skel, "PixelList");
    skel_pix = skel_pix.PixelList;
    skel_len = length(skel_pix);

    skel_edges = mask_atr(i).skel + mask_atr(i).edges;
    edges_pix = regionprops(mask_atr(i).edges, "PixelList");
    edges_pix = edges_pix.PixelList;
    
    mask = mask_atr(i).mask;
    skelImage = mask_atr(i).skel;

    edtImage = bwdist(~mask);
    
    figure,
    subplot(3,1,1)
    imshow(edtImage, [])    
    impixelinfo; % Let user mouse around and see values in the status line at the lower right.

     %Multiply them to get an image where the only pixels in the image
% are along the skeleton and their value is the radius.
% Multiply radius image by 2 to get diameter image.
    diameterImage = 2 * edtImage .* single(skelImage);
    subplot(3,1,2); imshow(diameterImage, [])
    impixelinfo; 

    % Get the widths.  These will be where the image is not zero.
    widths = diameterImage(diameterImage > 0);


    % Show histogram of widths.
    subplot(3,1,3), histogram(widths);
    grid on;
    xlabel('Width in Pixels');
    ylabel('Count');
    


end



