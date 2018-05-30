function ssd_quilt = quilt_simple(sample, outsize, patchsize, overlap, k)
%QUILT_SIMPLE Summary of this function goes here
%   Detailed explanation goes here

[height_s, width_s, layers_s] = size(sample);

height_p = uint32(patchsize(1));
width_p = uint32(patchsize(2));

height_o = uint32(outsize(1));
width_o = uint32(outsize(2));

ssd_quilt = (zeros(height_o, width_o, layers_s));
 randomy = randi([0 150],1,1);
 randomx = randi([0 150],1,1);
 
ssd_quilt(1:patchsize(1), 1:patchsize(1), :) = sample(randomy+1:randomy+patchsize(1), randomx+1:randomx+patchsize(1), :);
num_horizontal_patches = floor((width_o-patchsize(1))/(patchsize(1)-overlap));
num_vertical_patches = floor((height_o-patchsize(1))/(patchsize(1)-overlap));

for m = 1:num_vertical_patches
    for n = 1:num_horizontal_patches
        if(m==1)
            template = ssd_quilt(1:patchsize(1), ((patchsize(1)-overlap)*n+1):(patchsize(1)-overlap)*n + patchsize(1), :);
            ssdPatch = ssd_patch(template, sample);
            patch = choose_sample(patchsize, sample, ssdPatch, k);
            ssd_quilt(1:patchsize(1), ((patchsize(1)-overlap)*n+1):(patchsize(1)-overlap)*n + patchsize(1), :) = patch(:, :, :);
            figure(1), hold off, imagesc(ssd_quilt)
            if(n==num_horizontal_patches-1)
                break
            end
            continue
        end
        if(n==1)
            template = ssd_quilt(((patchsize(1)-overlap)*(m-1)+1):(patchsize(1)-overlap)*(m-1) + (patchsize(1)), 1:patchsize, :);
            ssdPatch = ssd_patch(template, sample);
            patch = choose_sample(patchsize, sample, ssdPatch, k);
            ssd_quilt(((patchsize(1)-overlap)*(m-1)+1):(patchsize(1)-overlap)*(m-1) + (patchsize(1)), 1:patchsize, :) = patch(1:patchsize, 1:patchsize, :);
            figure(1), hold off, imagesc(ssd_quilt)
            continue
        end
        template = ssd_quilt(((patchsize(1)-overlap)*(m-1)+1):(patchsize(1)-overlap)*(m-1) + (patchsize(1)), ((patchsize(1)-overlap)*(n-1)+1):(patchsize(1)-overlap)*(n-1) + patchsize(1), :);
        ssdPatch = ssd_patch(template, sample);
        patch = choose_sample(patchsize, sample, ssdPatch, k);
        ssd_quilt(((patchsize(1)-overlap)*(m-1)+1):(patchsize(1)-overlap)*(m-1) + (patchsize(1)), ((patchsize(1)-overlap)*(n-1)+1):(patchsize(1)-overlap)*(n-1) + patchsize(1), :) = patch(1:patchsize, 1:patchsize, :);
        figure(1), hold off, imagesc(ssd_quilt)
    end
end

figure(1), hold off, imagesc(ssd_quilt)


