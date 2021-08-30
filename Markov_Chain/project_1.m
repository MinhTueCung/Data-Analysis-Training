clear all;
close all;
% time const
r = 1/2 % s^(-1)
b = 1/3
l = 1/4.5
o = 1/4
c = 1/4.8
q = 1/(23 * 60) 
e = 1/(45 * 60)
m = 1/(12 * 60)

dt = min([r,b,l,o,c,e,m].^(-1))/100

na = 2; % nb of absorbing states
nt = 7; % nb of transition states
nstep = 10000;

%    E      M|   I        B        O      L          U      R      D  
M = [1/dt   0    e        0        0      0          0      0      0;       %E
     0      1/dt 0        m        0      0          0      0      0;       %M
     0      0    1/dt-o-e 0        0      o          0      0      0;       %I  
     0      0    0        1/dt-m-c 0      b          0      0      0;       %B
     0      0    0        0        1/dt-q o          0      0      0;       %O  
     0      0    0        0        0      1/dt-o-o-b l      0      0;       %L 
     0      0    0        0        0      0          1/dt-l l      0;       %U
     0      0    o        c        q      0          0      1/dt-l r;       %R
     0      0    0        0        0      0          0      0      1/dt-r]*dt; %D 
sum(M)  % check ! sum(M) should be 1 for each column

% Extract the matrix R, Q from the M matrix:
R = M(1:na,(na+1):(na+nt));       
Q = M(na+1:na+nt, na+1:na+nt);
%Build the fundamental matrix:
I = eye(size(Q));
F = inv(I-Q); 
% The time matrix
T = F*dt; %in sec
% Absorption matrix:
A = R*F;
disp('sum of columns of A'); % it should be 1
disp(sum(A));


% Time evolution of the markov process:

N = zeros(na+nt,nstep);
N(9,1) = 1;

for j=2:nstep
    N(:,j)= M*N(:,j-1);
end 

time = (1 : nstep)*dt; % in sec

plot(time, N(1,:), 'y', 'linewidth', 1.5); % Eliminate
hold on;
plot(time, N(2,:), 'm', 'linewidth', 1.5); % NDMA irgendwas!!
plot(time, N(3,:), 'c', 'linewidth', 1.5);
plot(time, N(4,:), 'r', 'linewidth', 1.5); 
plot(time, N(5,:), 'g', 'linewidth', 1.5); % Bone
plot(time, N(6,:), 'b', 'linewidth', 1.5);
plot(time, N(7,:), 'c--', 'linewidth', 1.5);
plot(time, N(8,:), 'k', 'linewidth', 1.5);
plot(time, N(9,:), 'y--', 'linewidth', 1.5);
grid on;

legend('E','M','I','B','O','L','U','R','D');
title('Pb in the body: first 200 secs');

hold off;