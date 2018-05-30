    close all;
    
    %%Read input image
%     im1 = im2double(imread('./bricks.jpg'));
    sample = im2double(imread('./joker.jpg'));
    texture = im2double(imread('./casino.jpg'));
%     figure(1), hold off, imagesc(im1)
    
    %%Generate general stats
    alpha = 0.2;
    patchsize = [double(50), double(50)];
    outsize = [900, 900];
    overlap = 20;
    k=10;
   
    %Generating random_sampled_image
%     random_quilt = quilt_random(im1, outsize, patchsize);
%     figure(11), hold off, imshow(random_quilt)
%     
%     
%     %Generating ssd sample image
%     ssd_quilt = quilt_simple(im1, outsize, patchsize, overlap, k);
%     figure(12), hold off, imshow(ssd_quilt)
%     
%     %%Generating image using seam finding
%     seam_quilt = quilt_cut(im1, outsize, patchsize, overlap, k);
%     figure(13), hold off, imshow(seam_quilt);
%     figure(1), hold off, imshow(im1)
%     texture_image = texture_transfer(im2, texture, patchsize, overlap, k, alpha);
%     imshow(texture_image);
    
    alpha = 0.1;
    patchsize = [double(10), double(10)];
    overlap = 5;
    k = 10;
    numIterations = 3;
    updatedImage = texture_transfer(sample, texture, patchsize, overlap, k, alpha);
    imagesc(updatedImage), axis image, hold off
    x = 1
%     for i = 2:numIterations
%         patchsize = ceil(patchsize/3)
%         alpha = (0.8*(i-1)/(numIterations-1) + 0.1)
%         updatedImage = iterative_texture_transfer(sample, texture, updatedImage, patchsize, overlap, k, alpha);
%         imagesc(updatedImage), hold off, axis image
%     end
    
     
    
    
    
    