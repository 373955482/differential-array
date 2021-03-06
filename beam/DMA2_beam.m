close all;
theta = [0,90,135]'*pi/180;%0:2*pi/360:2*pi;  %注视方向
theta = linspace(0,2*pi,360);

f = 1:1:8000;

d = 0.010;
c = 340;
tao0 = d/c;
omega = 2*pi*f;

% Cardioid
alpha_21 = -1;
alpha_22 = 0;

% Hypercardioid
alpha_21 = -0.89;
alpha_22 = -0.28;

% % Supercardioid
% alpha_21 = -0.81;
% alpha_22 = 0.31;

% Quadrupole
alpha_21 = -1/sqrt(2);
alpha_22 = 1/sqrt(2);


N_FFT = 256;
fs = 16000;
half_bin = N_FFT/2+1;
omega = [1:half_bin]*fs/N_FFT;

H = zeros(3,length(omega));
theta_target = 0*pi/180;             % target
alpha_1_1 = cos(180*pi/180);          % 零点方向
B = zeros(length(theta),length(omega));
for i = 1:length(omega)
    omega_k = 2*pi*omega(i);
    B(:,i) = 1j/(omega_k*tao0*(alpha_1_1-1))*(1-exp(-1*1j*omega_k*tao0*(cos(theta)-alpha_1_1)));
%     B(:,i) = (1-exp(-1*1j*omega_k*tao0*(cos(theta)-cos(alpha))));
%     H(:,i) = 1j/(omega_k*tao0*(alpha_1_1-cos(theta_target)))*[1;
%                                            -exp(1j*omega_k*tao0*alpha_1_1)]; % eq.(3.7), approximation
    H(:,i) = 1/(-1*tao0^2*omega_k^2*(alpha_21-1)*(alpha_22-1))*[1;
                                           -exp(1j*omega_k*tao0*alpha_21)-exp(1j*omega_k*tao0*alpha_22);
                                           exp(1j*omega_k*tao0*(alpha_21+alpha_22))]; % eq. (3.16)
                                       
    H(:,i) = 1/(-1*tao0^2*omega_k^2*(alpha_21-1))*[-exp(-1j*omega_k*tao0);
                                           1+exp(-1j*omega_k*2*tao0);
                                           -exp(1j*omega_k*tao0)]; % eq. (3.16)

    B(:,i) = 1/((alpha_21-1)*(alpha_22-1))*(cos(theta)-alpha_21).*(cos(theta)-alpha_22); % eq. (3.23), approximation
end
% figure,plot(pow2db(abs(B(1,:))),'b'),ylim([-20,5]),
% set(gca,'XScale','log'),grid on
% hold on
% plot(pow2db(abs(B(90,:))),'r'),ylim([-20,5]),
% hold on,
% plot(pow2db(abs(B(135,:))),'g'),ylim([-20,5]),
% legend('theta = 0','theta = 90','theta = 135');

figure,polarplot(linspace(0,2*pi,360),abs(B(:,16)));
figure, mesh(10*log10(abs(B(:,:)))),title('beampattren');

beamOut = zeros(length(theta),length(omega)); % beamformer output
for ang = 1:length(theta)
    for k = 1:length(omega)
        omega_k = 2*pi*omega(k); % normalized digital angular frequency
%         omega_k = omega(freIndex);          % analog angular frequency
        a = [1,exp(-1j*omega_k*tao0*cos(theta(ang))),exp(-1j*omega_k*2*tao0*cos(theta(ang)))];  % signal model,steering vector
        if(sqrt(H(:,k)'*H(:,k))>1)
            H(:,k) = H(:,k)/sqrt(H(:,k)'*H(:,k));
        end
        beamOut(ang,k) = a*(H(:,k)); % y = w'*a;
    end   
end

figure,polarplot(linspace(0,2*pi,360),abs(beamOut(:,16)));%rlim([0 1])

figure,mesh(10*log10(abs(beamOut(:,:))))%,ylim([-60,60]);

% [beamOut] = beampolar(H,d,tao0);

