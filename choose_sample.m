function patch = choose_sample(patchsize, sample, ssd, k)

[height_sample, width_sample, layers] = size(sample);
hp = patchsize(1);
wp = patchsize(2);

% sample from the 1% lowest ssd
ssd = ssd(floor(hp/2)+1 : height_sample - floor(hp/2),floor(wp/2)+1: width_sample - floor(wp/2), :);
temp = ssd;
[Max, I] = max(ssd(:));
for i = 1:k
    if(i==k)
        [minc,I] = min(temp(:));
        break
    end
    [M, I] = min(temp(:));
    [I_row, I_col] = ind2sub(size(temp),I);
    temp(I_row, I_col) = Max;
    
end

[Y, X] = find(ssd<=minc);

i = randi(length(Y));
xs = X(i) + floor(wp/2);
ys = Y(i) + floor(hp/2);

yrange = floor(-(hp-1)/2):floor((hp-1)/2);
xrange = floor(-(wp-1)/2):floor((wp-1)/2);

patch = sample(ys+yrange, xs+xrange, :);