function [buim] = blowup(img,factor)

    [a,b] = size(img);

    buim = zeros(a*factor,b*factor);

    for i = 1:a
        for j = 1:b
            buim(factor*i-1:factor*i,factor*j-1:factor*j) = img(i,j);
        end
    end

end