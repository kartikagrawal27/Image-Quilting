function seam_quilt = quilt_cut( sample, outsize, patchsize, overlap, k)
%QUIKT_CUT Summary of this function goes here
%   Detailed explanation goes here

[height_s, width_s, layers_s] = size(sample);

height_p = uint32(patchsize(1));
width_p = uint32(patchsize(2));

height_o = uint32(outsize(1));
width_o = uint32(outsize(2));

seam_quilt = (zeros(height_o, width_o, layers_s));
 randomy = randi([0 height_s-patchsize(1)-1],1,1)
 randomx = randi([0 width_s-patchsize(1)-1],1,1)
 
seam_quilt(1:patchsize(1), 1:(patchsize(1)), :) = sample(randomy+1:randomy+patchsize(1), randomx+1:randomx+patchsize(1), :);
num_horizontal_patches = floor((width_o-patchsize(1))/(patchsize(1)-overlap))
num_vertical_patches = floor((height_o-patchsize(1))/(patchsize(1)-overlap))

for m = 1:num_vertical_patches
    for n = 1:num_horizontal_patches
        
        if(m==1)
            if(n==num_horizontal_patches)
                continue
            end
            template = seam_quilt(1:patchsize(1), ((patchsize(1)-overlap)*n+1):(patchsize(1)-overlap)*n + patchsize(1), :);
            ssdPatch = ssd_patch(template, sample);
            patch = choose_sample(patchsize, sample, ssdPatch, k);
            template_overlap_vertical = template(1:patchsize(1), 1:overlap, :);
            patch_overlap_vertical = patch(1:patchsize(1), 1:overlap, :);
            imagesc(template_overlap_vertical), axis image
            combination = (template_overlap_vertical - patch_overlap_vertical);
            ssd = combination.^2;
            sum_ssd = ssd(:,:,1) + ssd(:,:,2) + ssd(:,:,3)
            sum_ssd = sum_ssd.'
            mask = cut(sum_ssd);
            sum_ssd = sum_ssd.'
            mask = mask.'
            
            for i = 1:patchsize()
                for j = 1:overlap-1
                    if(mask(i,j) ~= mask(i,j+1))
                        sum_ssd(i,j) = double(0.999)
                        break
                    end
                end
            end
            for i = 1:patchsize(1)
                for j = 1:overlap
                    if(mask(i,j) == 0)
                        seam_quilt(i, (patchsize(1)-overlap)*n + j, :) = template_overlap_vertical(i, j, :);
                    else
                        seam_quilt(i, (patchsize(1)-overlap)*n + j, :) = patch_overlap_vertical(i,j, :);
                    end
                end
            end
%             figure(1), hold off, imagesc(seam_quilt)
            seam_quilt(1:patchsize(1), ((patchsize(1)+(n-1)*(patchsize(1)-overlap)+1)):((patchsize(1)+(n)*(patchsize(1)-overlap))), :) = patch(1:patchsize(1), overlap+1: patchsize(1),:);
%             figure(1), hold off, imagesc(seam_quilt)
            continue
        end
   
        if(n==1)
            template = seam_quilt(((patchsize(1)-overlap)*(m-1)+1):(patchsize(1)-overlap)*(m-1) + (patchsize(1)), 1:patchsize, :);
            ssdPatch = ssd_patch(template, sample);      
            patch = choose_sample(patchsize, sample, ssdPatch, k);
            template_overlap_vertical = template(1:overlap, 1:patchsize(1), :);
            patch_overlap_vertical = patch(1:overlap, 1:patchsize(1), :);
            combination = (template_overlap_vertical - patch_overlap_vertical);
            ssd = combination.^2;
            sum_ssd = ssd(:,:,1) + ssd(:,:,2) + ssd(:,:,3)
            mask = cut(sum_ssd);
            for i = 1:overlap
                for j = 1:patchsize(1)
                    if(mask(i,j) == 0)
                        seam_quilt((patchsize(1)-overlap)*(m-1) + i, j, :) = template_overlap_vertical(i, j, :);
                    else
                        seam_quilt((patchsize(1)-overlap)*(m-1) + i, j, :) = patch_overlap_vertical(i,j, :);
                    end
                end
            end
%             figure(1), hold off, imagesc(seam_quilt)
            seam_quilt(((patchsize(1)+(m-2)*(patchsize(1)-overlap)+1)):((patchsize(1)+(m-1)*(patchsize(1)-overlap))),1:patchsize(1),:) = patch(overlap+1:patchsize(1), 1:patchsize(1), :);
%             figure(1), hold off, imagesc(seam_quilt)
            continue
        end
        
        template = seam_quilt((patchsize(1)-overlap)*(m-1)+1:(patchsize(1)-overlap)*(m-1) + patchsize(1), ((patchsize(1)-overlap)*(n-1)+1):(patchsize(1)-overlap)*(n-1) + patchsize(1),:);
        ssdPatch = ssd_patch(template, sample);
        patch = choose_sample(patchsize, sample, ssdPatch, k);
        
        %%Need to check this function
        template_overlap_vertical = template(1:patchsize(1), 1:overlap, :);
        patch_overlap_vertical = patch(1:patchsize(1), 1:overlap, :);
        combination = (template_overlap_vertical - patch_overlap_vertical);
        ssd = combination.^2;
        sum_ssd = ssd(:,:,1) + ssd(:,:,2) + ssd(:,:,3);
        sum_ssd = permute(sum_ssd, [2 1]);
        mask1 = cut(sum_ssd);
        mask1 = mask1.';
        
        template_overlap_horizontal = template(1:overlap, 1:patchsize(1), :);
        patch_overlap_horizontal = patch(1:overlap, 1:patchsize(1), :);
        combination = (template_overlap_horizontal - patch_overlap_horizontal);
        ssd = combination.^2;
        sum_ssd = ssd(:,:,1) + ssd(:,:,2) + ssd(:,:,3)
        mask2 = cut(sum_ssd)
        
        
        for i = 1+overlap:patchsize(1)
            for j = 1:overlap
                if(mask1(i,j) == 0)
                    seam_quilt((patchsize(1)-overlap)*(m-1) + i, (patchsize(1)-overlap)*(n-1) + j, :) = template_overlap_vertical(i, j, :);
                else
                    seam_quilt((patchsize(1)-overlap)*(m-1) + i, (patchsize(1)-overlap)*(n-1) + j, :) = patch_overlap_vertical(i, j, :);
                end
            end
        end
        
        for i = 1:overlap
            for j = 1+overlap:patchsize(1)
                if(mask2(i,j) == 0)
                    seam_quilt((patchsize(1)-overlap)*(m-1) + i, (patchsize(1)-overlap)*(n-1) + j, :) = template_overlap_horizontal(i, j, :);
                else
                    seam_quilt((patchsize(1)-overlap)*(m-1) + i, (patchsize(1)-overlap)*(n-1) + j, :) = patch_overlap_horizontal(i, j, :);
                end
            end
        end
        
        seam_quilt(patchsize(1) + (m-2)*(patchsize(1)-overlap) + 1: patchsize(1) + (m-1)*(patchsize(1)-overlap), patchsize(1) + (n-2)*(patchsize(1)-overlap) + 1: patchsize(1) + (n-1)*(patchsize(1)-overlap), :) = patch(overlap+1:patchsize(1), overlap+1:patchsize(1), :); 
        
    end
end

end

