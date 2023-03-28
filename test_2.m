

clc;
clear 
close all;

%%%% assisgnment 1


train = load('training.mat');
spy = load('spydata.mat');

err=[];


for L=1:1:32
    
    input=spy.received(1:L);
    output_b= train.training(1:L);

    ry = xcorr(input);
    ry = ry(ceil(end/2):end);
    ryx = xcorr(input, output_b);
    ryx = ryx(((end+1)/2):-1:1);
    Ry = toeplitz(ry);
    
    w = mldivide(Ry, ryx);
    
    key_ass = filter(w,[1], spy.received(L:32));
    
    
    key_final = sign(key_ass);
    
    %err(L) = immse( key_final,train.training(L:32));
    err(L) = (sqrt(mean((key_ass - train.training(L:32)).^2)));


end


% we are getting lowest mse at L=14 so use L=14 as filter order
L=14;
input=spy.received(1:L);
    output_b= train.training(1:L);

    ry = xcorr(input);
    ry = ry(ceil(end/2):end);
    ryx = xcorr(input, output_b);
    ryx = ryx(((end+1)/2):-1:1);
    Ry = toeplitz(ry);
    
    w = mldivide(Ry, ryx);
    
    key_ass = filter(w,[1], spy.received);
    
    
    key_final = sign(key_ass);
    
dpic4 = decoder(key_final, spy.cPic);


i=1:1:32;
figure(1)

stem(i, err)
title('mean square error for L')
xlabel('L')
ylabel('MSE')


figure(2)

image(dpic4)



% add errors


errornumber=3000;      %11842 is max bit error possible to decode but we cannot see clearly

b_out = key_final;


errorlocation=randperm(length(b_out), errornumber);
for i=1:length(b_out)
    for j=1:length(errorlocation)
        if(i==errorlocation(j))
            temp=b_out(i);
            if(b_out(i)>0)
                b_out(i)=-1;
            end
            if(b_out(i)<0)
                b_out(i)=1;
            end
        end
    end
end

% decode the picture
figure(3)
dpic=decoder(b_out,spy.cPic);
image(dpic);
axis square;