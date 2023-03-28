clear all
pic = imread('kth.jpg');
[b,cpic]=encoder(pic);
L=4;
b_pilot=b(L+1:32);
h=[1,0.7,0.7];%channel setting
noise=awgn(b,5);%awgn noise

% channel
rr=conv(b,h);
r=rr(1:length(rr)-2);
% r=rr(1:length(rr)-2);

% calculate R and w
R=zeros(32-L,L+1);
for i=1:32-L
    for j=1:L+1
        R(i,j)=r(L+1+i-j);
    end
end
%w=inv(R'*R)*R'*b_pilot;
w=R'*R\R'*b_pilot;

% get the estimation of bits
for i=L+1:length(b)
    b_esti(i)=0;
    for j=1:L+1
        b_esti(i)=b_esti(i)+w(j)*r(i-j+1);
    end
end
b_esti=b_esti';
for i=1:L
    b_esti(i)=b(i);
end

% evaluate MSE
b_pilottest=R*w;
MSE=0;
for i=1:(32-L)
    MSE=MSE+(b_pilot(i)-b_pilottest(i))^2;
end
MSE=MSE/(32-L);
L2=0;
for i=33:64
    L2=L2+(b_esti(i)-b(i))^2;
end

% recover the origin bits
for i=1:length(b_esti)
    if(b_esti(i)>=0)
        b_out(i)=1;
    end
    if(b_esti(i)<0)
        b_out(i)=-1;
    end
end
b_out=b_out';

% decode the picture
dpic=decoder(b_out,cpic);
image(dpic);
axis square;