function ssdPatch = ssd_patch(template, sample)
%SSD_PATCH Summary of this function goes here
%   Detailed explanation goes here

[height_sample, width_sample, layers] = size(sample);
% figure(4), hold off, imagesc(template)
[height_template, width_template, layers] = size(template);
mask = zeros(height_template, width_template, 3);
for i = 1:height_template
    for j = 1:width_template
        if template(i,j,:)>0
            mask(i,j,:) = 1;
        end
    end
end
% figure(5), hold off,1 imagesc(mask);

[height_sample, width_sample, layers_sample] = size(sample);

for channel = 1:3
    sample_channel = sample(:,:, channel);
    template_channel = template(:,:, channel);
    mask_channel = mask(:, :, channel);
    if channel == 1
        ssdPatchRed = imfilter(sample_channel.^2, mask_channel) - 2*imfilter(sample_channel, mask_channel.*template_channel) + sum(sum((mask_channel.*template_channel).^2));
    end
    if channel == 2
        ssdPatchGreen = imfilter(sample_channel.^2, mask_channel) - 2*imfilter(sample_channel, mask_channel.*template_channel) + sum(sum((mask_channel.*template_channel).^2));
    end
    if channel == 3
        ssdPatchBlue = imfilter(sample_channel.^2, mask_channel) - 2*imfilter(sample_channel, mask_channel.*template_channel) + sum(sum((mask_channel.*template_channel).^2));
    end
end

ssdPatch = ssdPatchRed + ssdPatchGreen + ssdPatchBlue;
end

