%% time constant in day-1;

w = 10;
a = 1/1.2;
c = 1/2.3;
e = 1.2;
b = 1/5;
d = 1/1.1;
f = 1/0.1;
g = 1;
h = 1/10;    
i = 1/730;
k = 1/90;
j = 1/12;

dt = min ([w,a,c,e,b,d,f,g,h,i,k,j].^(-1))/100;

na = 1; %only D is absorbing;
nt = 5;
nstep = 10000;


     % D   P  W  S  F   K 
M = [1/dt 0 0 g i h ; ...                       %D
       0 1/dt-w 0 0 0 0 ; ...                   %P
       0 w 1/dt-(a+e+c) b f d ; ...             %W
       0 0 a 1/dt-(j+b+g) 0 0 ; ...             %S
       0 0 e 0 1/dt-(i+f) k ; ...               %F
       0 0 c j 0 1/dt-(k+h+d)]*dt ; ...         %K
sum(M);
%%       
R = M(1:na,na+1:na+nt);
Q = M(na+1:na+nt, na+1:na+nt);

%build the fundamental matrix
I = eye(size(Q));
F = inv(I-Q);

%the time matrix
T = F*dt; %in days

% Absorption matrix
A = R*F;
disp('sum of column of A');
disp(sum(A));

% A =
%           P          W          S         F         K  
% D     1.0000     1.0000      1.0000     1.0000    1.0000



%time
%   P           W           S         F         K
%    0.1000       0         0         0         0       P
%    1.4338    1.4338    0.3074    1.4336    1.2933     W
%    0.9311    0.9311    0.9789    0.9309    0.8398     S
%    0.1728    0.1728    0.0371    0.2728    0.1569     F
%    0.6871    0.6871    0.2110    0.6870    1.6000     K

N = zeros(na+nt,nstep);

N(2,1) = 1; % first column is for initial population, 
%initally the nitrates are localized in the FIELD (row 3)
%N(:,1)=
%
%   0
%   0
%   1
%   0
%   0
%   0
for j=2:nstep
N(:,j)= M*N(:,j-1);
end 

time = (1 : nstep)*dt; %in days
%plot(time,N')
plot(time,N(1,:),'b') %state DIED over the time (blue line)
hold on;
plot(time,N(2,:),'r') %state PLANT over the time ( red line)
plot(time,N(3,:),'k') %state WATER over the time ( black line)
plot(time,N(4,:),'m') %state  SEAWEED over the time ( magneta line)
plot(time,N(5,:),'g') %state  FISH over the time ( green line)
plot(time,N(6,:),'c') %state  KRILL over the time ( cian line)









