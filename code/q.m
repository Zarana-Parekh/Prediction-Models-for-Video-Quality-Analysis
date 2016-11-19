data = load('data_CS306.mat');
d1 = data.data_100;
d2 = data.data_144;

MOS1 = mean(d1,2);
MOS2 = mean(d2,2);

th = 3;
N=24;

PDU1 = (sum(d1<th,2)*100)/N;
PDU2 = (sum(d2<th,2)*100)/N;

r1 = corr(MOS1,PDU1);
r2 = corr(MOS2,PDU2);
%th=2 : r1 = -0.8508, r2 = -.8881
%th=3 : r1 = -0.9803, r2 = -.9796
% 
% figure();
% 
% subplot(1,2,1);
% scatter(MOS1,PDU1,5,'r');
% xlabel('MOS');
% ylabel('PDU');
% title('Scatter plot for 100 full HD Videos');
% 
% subplot(1,2,2);
% scatter(MOS2,PDU2,5,'b');
% xlabel('MOS');
% ylabel('PDU');
% title('Scatter plot for 144 HDR Videos');

%Linear Model
X  = [MOS1 ones(size(MOS1))];
c = regress(PDU1,X);

%Logistic Model
logistic = @(x)sseval(x,MOS1,PDU1);
x0= [2;1;3;50];%zeros(4,1);
alphas = fminsearch(logistic,x0);
sseval(alphas,MOS1,PDU1)/length(MOS1);

%hist(MOS1,10);
%Gaussian Model
gauss1 = fit(MOS1,PDU1,'gauss1');

%finding the predicted values
PDU1_linear = c(1)*MOS1 + c(2);
PDU1_logistic = alphas(1,1)*(0.5-1./(1+exp(alphas(2,1)*(MOS1-alphas(3,1))))) + alphas(4,1);
PDU1_g1 = gauss1(MOS1);
PDU1_g2 = predict(MOS1,MOS1,PDU1);

r = 1:0.1:5;

% figure;
% plot(MOS1,PDU1,'r.'); hold on;
% plot(r,PDU1_linear,'b.');
figure;
plot(MOS1,PDU1,'r.'); hold on;
temp = alphas(1,1)*(0.5-1./(1+exp(alphas(2,1)*(r-alphas(3,1))))) + alphas(4,1);
plot(r,temp,'b','linewidth',2.5);
% figure;
% plot(MOS1,PDU1,'r.'); hold on;
% scatter(r,PDU1_g1,'b.');
% figure;
% plot(MOS1,PDU1,'r.'); hold on;
% scatter(r,PDU1_g2,'b.');

figure;
%ftest
[h,flag] = f_test(PDU1,PDU1_linear,PDU1_logistic)
[h,flag] = f_test(PDU1,PDU1_g1,PDU1_logistic)
[h,flag] = f_test(PDU1,PDU1_linear,PDU1_g1)

%hist(MOS1,100);
%hist(PDU1,100);

%bootstrapping
err_linear = (PDU1 - PDU1_linear).^2;
err_logistic = (PDU1 - PDU1_logistic).^2;

%err_linear = ones(10,1);
%err_logistic = zeros(10,1);

%errors = [err_linear;err_logistic];
errors = [err_logistic;err_linear];

stats = bootstrp(1000,@(x)(wilcoxon(x)),errors);
 hist(stats,50);
 alpha =0.95;
 stats = sort(stats);
 cs = cumsum(stats);
 cs>max(cs)*(1-alpha);
 index = find(cs>max(cs)*(1-alpha),1,'first');
 stats(index);
 T_orig = 0;
 for i=1:length(err_logistic)
        T_orig = T_orig +sum(err_logistic(i)<err_linear);
 end;
 T_orig;
 %[p,h,stats] = ranksum(err_linear,err_logistic,'alpha',0.1)

 
PDU2_linear = c(1)*MOS2 + c(2);
PDU2_logistic = alphas(1,1)*(0.5-1./(1+exp(alphas(2,1)*(MOS2-alphas(3,1))))) + alphas(4,1);
PDU2_g1 = gauss1(MOS2);
PDU2_g2 = predict(MOS2,MOS1,PDU1);

linear_mse = mean_square(PDU2, PDU2_linear)
logistic_mse = mean_square(PDU2, PDU2_logistic)
g1_mse = mean_square(PDU2, PDU2_g1)
g2_mse = mean_square(PDU2, PDU2_g2)