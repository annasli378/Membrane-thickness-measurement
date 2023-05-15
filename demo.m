clear all, close all
%% Read mask
MASK  = load("CALE_OBRAZKI\Masks\20_Mask.mat");
mask = MASK.ABCD;


%% Better mask:
maska_membrana = GetMask(mask);
figure, imshow(maska_membrana)

%% Get regions:
[mask_attributes_struct, num_blobs] = GetBlobs(maska_membrana);

%% Get widths:
step = 20;
start = 10;

widths = GetWidths3(start,step, mask_attributes_struct, num_blobs, false );

%%  pix -> nm
nm_pix = 0.15;
pow = 3000;
for i = 1: length(widths)
    widths_nm(i) = widths(i) /  nm_pix ;
end
%% Harmonic average of N random values:
N = 20;
r = randperm(length(widths_nm),N);

h_mean = harmmean(widths_nm)
h_mean_r20 = harmmean(widths_nm(r))
