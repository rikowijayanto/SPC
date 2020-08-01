clear; 
clc;
close all;

data = [31
32
36
40
27
41
22
18
27
22
24
29
20
29
33
29
27
28
35
32
30
19
18
25
31
21
27
28
29
34
29
29
36
30
23
31
42
26
34
53
114
86
67
85
56
50
48
53
59
37
35
31
48
39
36
35
22
30
9
28
29
21
23
20
17
15
28
19
];

bub = -1; %minimum uji
step = 0.01; %langkah uji
bua = 2; %maksimum uji


rata1 = mean(data); %mencari rata-rata
std1 = std(data); %mencari standar deviasi
up = rata1 + (3*std1);
low = rata1 - (3*std1);

% %Plot time series
plot(data);
hold on;
plot(1:length(data),rata1*ones([1 length(data)]),'linewidth',2);
hold on;
plot(1:length(data),up*ones([1 length(data)]),'linewidth',2);
hold on;
plot(1:length(data),low*ones([1 length(data)]),'linewidth',2);
grid on

xlabel('data ke-')
ylabel('data inflasi')
title('Plot time series data inflasi')

%Plot moving range
count = 1;
for i=1:(length(data)-1)
    move(count)= abs(data(i)-data(i+1));
    count = count+1;
end

rata2 = mean(move); %mencari rata-rata
std2 = std(move); %mencari standar deviasi
up1 = rata2 + (3*std2);
low1 = rata2 - (3*std2);

figure
plot(move);
hold on;
plot(1:length(move),rata2*ones([1 length(move)]),'linewidth',2);
hold on;
plot(1:length(move),up1*ones([1 length(move)]),'linewidth',2);
hold on;
plot(1:length(move),low1*ones([1 length(move)]),'linewidth',2);
grid on

xlabel('data ke-')
ylabel('data moving range')
title('Plot X-Chart (Moving Range) Transformation')


%mencari geomean
geo = geomean(data);

%transformasi modified
figure
kos =1;
for i=bub:step:bua
    
    if(i==0)
        
        for j=1:length(data)
            C(j)=geo*log(data(j))/log(exp(1));
           
        end
        plot(C)
        hold on;
        xlabel('Data ke')
        ylabel('Data Hasil Transformasi GEOM')
        title('Transformasi dengan Modified Box-Cox')
        
    else
        
        for j=1:length(data)
            C(j)=((data(j)^i)-1)/(i*(geo^(i-1)));
           
        end
        plot(C)
        hold on
        xlabel('Data ke')
        ylabel('Data Hasil Transformasi GEOM')
        title('Transformasi dengan Modified Box-Cox')
    end
    
    
    count1 = 1;
    for i=1:(length(C)-1)
        move1(count1)= abs(C(i)-C(i+1));
        count1 = count1+1;
    end
    
    
    ratamove = mean(move1);
    sigma(kos) = ratamove/1.128;
    kos = kos+1;
    
end

x = [bub:step:bua];
min=sigma(1);
node = x(1);
for i=2:length(sigma)
    if(sigma(i) <= sigma(i-1))
        min=sigma(i);
        node = x(i);
    end
end


ratasig = mean(sigma);
figure
plot(x,sigma,'linewidth',1.5)
hold on
plot(node,min,'.', 'MarkerSize',20)
hold on
plot(bub:step:bua,min*ones([1 length(sigma)]),'linewidth',1.5);
hold on;


Z = ['Estimasi Optimal Lambda:', num2str(node)];
title(Z)
xlabel('Lambda')
ylabel('StDev/isigma')
grid on;



% %HASIL TRANSFORMASI
if (node == 0)
    data1 = log(data)/(log(exp(1)));
else
    data1 = data.^node;
end

figure
plot(1:length(data1),data1)
xlabel('data ke-')
ylabel('data hasil transformasi')
title('Plot Box-Cox Transformation')

%=================================================================
%UJI HASIL TRANSFORMASI


%HASIL TRANSFORMASI
%mencari geomean
geo = geomean(data1);


%transformasi modified

kos =1;
for i=bub:step:bua
    if(i==0)
        
        for j=1:length(data1)
            C(j)=geo*log(data1(j))/log(exp(1));
           
        end
        
    else
        
        for j=1:length(data1)
            C(j)=((data1(j)^i)-1)/(i*(geo^(i-1)));
           
        end
    end
    
    
    count1 = 1;
    for i=1:(length(C)-1)
        move1(count1)= abs(C(i)-C(i+1));
        count1 = count1+1;
    end
    
    
    ratamove = mean(move1);
    sigma(kos) = ratamove/1.128;
    kos = kos+1;
    
end

x = [bub:step:bua];
min=sigma(1);
node = x(1);
for i=2:length(sigma)
    if(sigma(i) <= sigma(i-1))
        min=sigma(i);
        node = x(i);
    end
end


ratasig = mean(sigma);
figure
plot(x,sigma,'linewidth',1.5)
hold on
plot(node,min,'.', 'MarkerSize',20)
hold on
plot(bub:step:bua,min*ones([1 length(sigma)]),'linewidth',1.5);
hold on;

Z = ['Estimasi Optimal Lambda:', num2str(node)];
title(Z)
xlabel('Lambda')
ylabel('StDev/isigma')
grid on;

