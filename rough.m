clc
clear all
load training.mat
load spydata.mat

L=15;
MSE =[];
for L=1:1:15
% for L=0:15;
b_pilot=training(L+1:32);
r=received;


% calculate R and w
R=zeros(32-L,L+1);
for i=1:32-L
    for j=1:L+1
        R(i,j)=r(L+1+i-j);
    end
end
%w=inv(R'*R)*R'*b_pilot;
w=R'*R\R'*b_pilot;
% evaluate MSE
b_pilottest=R*w;
mse=0;
delta=zeros(32-L,1);
for i=1:(32-L)
    
    mse=mse+(b_pilot(i)-b_pilottest(i))^2;
    delta(i)=(b_pilot(i)-b_pilottest(i))^2;
end
MSE(L)=mse;
MSE(L)=MSE(L)/(32-L);
end 

l=1:1:15;
figure(1)
plot(l,MSE)