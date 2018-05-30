function texture_image = iterative_texture_transfer(sample, texture, updatedImage, patchsize, overlap, k, alpha)
%TEXTURE_TRANSFER Summary of this function goes here
%   Detailed explanation goes here

[height_s, width_s, layers_s] = size(sample);

height_p = double(patchsize(1));
width_p = double(patchsize(2));

ssd_transfer = ssd_patch(sample(1:patchsize(1), 1:patchsize(1), :),texture);
topleft = choose_sample(patchsize, texture, ssd_transfer, k);

texture_image = double(zeros(height_s, width_s, layers_s));

texture_image(1:patchsize(1), 1:patchsize(1), :) = topleft;
num_horizontal_patches = floor((width_s-patchsize(1))/(patchsize(1)-overlap));
num_vertical_patches = floor((height_s-patchsize(1))/(patchsize(1)-overlap));

for m = 1:num_vertical_patches
    for n = 1:num_horizontal_patches
        if(m==1)
            if(n==num_horizontal_patches)
                continue
            end
            %%Choosing patch
            template_result = texture_image(1:patchsize(1), ((patchsize(1)-overlap)*n+1):(patchsize(1)-overlap)*n + patchsize(1), :);
            template_sample = sample(1:patchsize(1), ((patchsize(1)-overlap)*n+1):(patchsize(1)-overlap)*n + patchsize(1), :);
            template_last = updatedImage(1:patchsize(1), ((patchsize(1)-overlap)*n+1):(patchsize(1)-overlap)*n + patchsize(1), :);
            ssd_transfer = ssd_patch(template_sample, texture);
            ssd_overlap = ssd_patch(template_result, texture);
            ssd_last = ssd_patch(template_last, texture);
            ssd_final = (1-alpha)*ssd_transfer + alpha*ssd_overlap + alpha*ssd_last;
            patch = choose_sample(patchsize, texture, ssd_final, k);
            
            %%Applying patch using quilt_cut
            template_overlap_vertical = template_result(1:patchsize(1), 1:overlap, :);
            patch_overlap_vertical = patch(1:patchsize(1), 1:overlap, :);
            combination = (template_overlap_vertical - patch_overlap_vertical);
            ssd = combination.^2;
            sum_ssd = ssd(:,:,1) + ssd(:,:,2) + ssd(:,:,3);
            sum_ssd = permute(sum_ssd, [2 1]);
            mask = cut(sum_ssd);
            mask = mask.';
            for i = 1:patchsize(1)
                for j = 1:overlap
                    if(mask(i,j) == 0)
                        texture_image(i, (patchsize(1)-overlap)*n + j, :) = template_overlap_vertical(i, j, :);
                    else
                        texture_image(i, (patchsize(1)-overlap)*n + j, :) = patch_overlap_vertical(i,j, :);
                    end
                end
            end
            texture_image(1:patchsize(1), ((patchsize(1)+(n-1)*(patchsize(1)-overlap)+1)):((patchsize(1)+(n)*(patchsize(1)-overlap))), :) = patch(1:patchsize(1), overlap+1: patchsize(1),:);
%             figure(1), hold off, imagesc(texture_image)
            continue
        end
        if(n==1)
            template_result = texture_image(((patchsize(1)-overlap)*(m-1)+1):(patchsize(1)-overlap)*(m-1) + (patchsize(1)), 1:patchsize, :);
            template_sample = sample(((patchsize(1)-overlap)*(m-1)+1):(patchsize(1)-overlap)*(m-1) + (patchsize(1)), 1:patchsize, :);
            template_last = updatedImage(((patchsize(1)-overlap)*(m-1)+1):(patchsize(1)-overlap)*(m-1) + (patchsize(1)), 1:patchsize, :);
            ssd_transfer = ssd_patch(template_sample, texture);
            ssd_overlap = ssd_patch(template_result, texture);
            ssd_last = ssd_patch(template_last, texture);
            ssd_final = (1-alpha)*ssd_transfer + alpha*ssd_overlap + alpha*ssd_last;
            patch = choose_sample(patchsize, texture, ssd_final, k);
            
            template_overlap_horizontal = template_result(1:overlap, 1:patchsize(1), :);
            patch_overlap_horizontal = patch(1:overlap(1), 1:patchsize(1), :);
            combination = (template_overlap_horizontal - patch_overlap_horizontal);
            ssd = combination.^2;
            sum_ssd = ssd(:,:,1) + ssd(:,:,2) + ssd(:,:,3);
            mask = cut(sum_ssd);
            for i = 1:overlap
                for j = 1:patchsize(1)
                    if(mask(i,j) == 0)
                        texture_image((patchsize(1)-overlap)*(m-1) + i, j, :) = template_overlap_horizontal(i, j, :);
                    else
                        texture_image((patchsize(1)-overlap)*(m-1) + i, j, :) = patch_overlap_horizontal(i,j, :);
                    end
                end
            end   
            texture_image(((patchsize(1)+(m-2)*(patchsize(1)-overlap)+1)):((patchsize(1)+(m-1)*(patchsize(1)-overlap))),1:patchsize(1),:) = patch(overlap+1:patchsize(1), 1:patchsize(1), :);
%             figure(1), hold, imshow(texture_image)
            continue
        end
        
        template_result = texture_image((patchsize(1)-overlap)*(m-1)+1:(patchsize(1)-overlap)*(m-1) + patchsize(1), ((patchsize(1)-overlap)*(n-1)+1):(patchsize(1)-overlap)*(n-1) + patchsize(1),:);
        template_sample = sample((patchsize(1)-overlap)*(m-1)+1:(patchsize(1)-overlap)*(m-1) + patchsize(1), ((patchsize(1)-overlap)*(n-1)+1):(patchsize(1)-overlap)*(n-1) + patchsize(1),:);
        template_last = updatedImage((patchsize(1)-overlap)*(m-1)+1:(patchsize(1)-overlap)*(m-1) + patchsize(1), ((patchsize(1)-overlap)*(n-1)+1):(patchsize(1)-overlap)*(n-1) + patchsize(1),:);
        ssd_transfer = ssd_patch(template_sample, texture);
        ssd_overlap = ssd_patch(template_result, texture);
        ssd_last = ssd_patch(template_last, texture);
        ssd_final = (1-alpha)*ssd_transfer + alpha*ssd_overlap + alpha*ssd_last;
        patch = choose_sample(patchsize, texture, ssd_final, k);
        
        template_overlap_vertical = template_result(1:patchsize(1), 1:overlap, :);
        patch_overlap_vertical = patch(1:patchsize(1), 1:overlap, :);
        combination = (template_overlap_vertical - patch_overlap_vertical);
        ssd = combination.^2;
        sum_ssd = ssd(:,:,1) + ssd(:,:,2) + ssd(:,:,3);
        sum_ssd = permute(sum_ssd, [2 1]);
        mask1 = cut(sum_ssd);
        mask1 = mask1.';
        
        template_overlap_horizontal = template_result(1:overlap, 1:patchsize(1), :);
        patch_overlap_horizontal = patch(1:overlap, 1:patchsize(1), :);
        combination = (template_overlap_horizontal - patch_overlap_horizontal);
        ssd = combination.^2;
        sum_ssd = ssd(:,:,1) + ssd(:,:,2) + ssd(:,:,3);
        mask2 = cut(sum_ssd);
        
        for i = 1+overlap:patchsize(1)
            for j = 1:overlap
                if(mask1(i,j) == 0)
                    texture_image((patchsize(1)-overlap)*(m-1) + i, (patchsize(1)-overlap)*(n-1) + j, :) = template_overlap_vertical(i, j, :);
                else
                    texture_image((patchsize(1)-overlap)*(m-1) + i, (patchsize(1)-overlap)*(n-1) + j, :) = patch_overlap_vertical(i, j, :);
                end
            end
        end
        
        for i = 1:overlap
            for j = 1+overlap:patchsize(1)
                if(mask2(i,j) == 0)
                    texture_image((patchsize(1)-overlap)*(m-1) + i, (patchsize(1)-overlap)*(n-1) + j, :) = template_overlap_horizontal(i, j, :);
                else
                    texture_image((patchsize(1)-overlap)*(m-1) + i, (patchsize(1)-overlap)*(n-1) + j, :) = patch_overlap_horizontal(i, j, :);
                end
            end
        end
        texture_image(patchsize(1) + (m-2)*(patchsize(1)-overlap) + 1: patchsize(1) + (m-1)*(patchsize(1)-overlap), patchsize(1) + (n-2)*(patchsize(1)-overlap) + 1: patchsize(1) + (n-1)*(patchsize(1)-overlap), :) = patch(overlap+1:patchsize(1), overlap+1:patchsize(1), :);
    end
end






end
