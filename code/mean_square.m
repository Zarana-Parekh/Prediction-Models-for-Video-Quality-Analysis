function [mse] = mean_square(d1, d2)
    num = length(d1);
    mse = sum((d1 - d2).^2)/num;
end