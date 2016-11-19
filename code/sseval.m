function [sse]= sseval(x,tdata,ydata)

 err=0;
for i=1:length(tdata)
    err = err + (ydata(i,1) -x(4,1) - x(1,1)*(0.5-1./(1+exp(x(2,1)*(tdata(i,1)-x(3,1)))))).^2;
end;
    sse = err;
    
end