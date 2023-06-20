clear all, close all
%% Read mask
num_pom_eks = [27,18,17,9,14,18,4,15,8,8,14,20,14,20,11,17,19,27,17,26];

obr_num= 1;
pth = strcat("CALE_OBRAZKI\Masks\", string(obr_num), "_Mask.mat");
MASK  = load(pth);
mask = MASK.ABCD;

%% Smoothe mask:
maska_membrana = GetMask(mask);
figure, imshow(maska_membrana)

%% Get regions:
[mask_attributes_struct, num_blobs] = GetBlobs(maska_membrana);

%% Get widths:
step = 20;
start = 30;

% incisal:
%widths = GetWidthsInc(start,step, mask_attributes_struct, num_blobs );
% bwdist:
widths = GetWidthsBwd(start,step, mask_attributes_struct, num_blobs);
%%  pix -> nm:
nm_pix = 0.15;
pow = 3000;
for i = 1: length(widths)
    widths_nm(i) = widths(i) /  nm_pix ;
end
%% Harmonic average:
N = num_pom_eks(obr_num);
r = randperm(length(widths_nm),N);

h_mean = harmmean(widths_nm)
h_mean_r20 = harmmean(widths_nm(r))

