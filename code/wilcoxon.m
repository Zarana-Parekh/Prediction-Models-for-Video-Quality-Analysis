function [T] =wilcoxon(sample)
    len = length(sample)/2;
    T=0;
    s1 = datasample(sample,len);
    s2 = datasample(sample,len);
    for i=1:len
        T = T +sum(s2>s1(i));
    end;
end