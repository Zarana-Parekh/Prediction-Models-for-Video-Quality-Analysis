
function[y] = predict(data,a,b )
    [mu,sigma] = normfit(a);
    alpha = @(x)sseg(x,mu,sigma,a,b);
    x0= 1;%zeros(4,1);
    alphas = fminsearch(alpha,x0)
    y = 100*(1-alphas(1,1)*normcdf(data,mu,sigma))
%     plot(a,b,'b.');
%     hold on;
%     plot(a,100*(1-alphas(1,1)*normcdf(a,mu,sigma)),'r.');
%     
end


function [sse]= sseg(x,mu,sigma,tdata,ydata)

 err=0;
for i=1:length(tdata)
    err = err + (ydata(i,1)-100*(1-x(1,1)*normcdf(tdata(i),mu,sigma))).^2;
end;
    sse = err;
    
end