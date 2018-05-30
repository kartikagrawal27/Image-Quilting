function random_quilt = quilt_random(sample, outsize, patchsize)

[height_s, width_s, layers_s] = size(sample);

height_p = double(patchsize(1));
width_p = double(patchsize(2));

height_o = double(outsize(1));
width_o = double(outsize(2));

random_quilt = double(zeros(height_o, width_o, 3));

total_patches = floor((height_o * width_o)/(height_p*width_p));

width_samples = randi([0 height_s-height_p], [1 total_patches]); 
height_samples = randi([0 width_s-width_p], [1 total_patches]);

num_h_patches = floor(height_o/height_p);
num_w_patches = floor(width_o/width_p);

for i = 1:num_h_patches
    for j = 1:num_w_patches
        patch_start_y = width_samples((i-1)*num_h_patches+j);
        patch_start_x = height_samples((i-1)*num_w_patches+j);
        complete_patch = sample(patch_start_y+(1:height_p),patch_start_x+(1:width_p),:);
        random_quilt((i-1)*height_p+(1:height_p), (j-1)*width_p+(1:width_p), :) = complete_patch;
    end
end

end

