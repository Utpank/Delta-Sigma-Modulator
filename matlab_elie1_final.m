close all
clearvars
clc

%% DSM parameters

OSR =256;
H = synthesizeNTF(2,OSR,1);
M=1;
N = 64*OSR;

%% input sine wave
fB = ceil(N/(2*OSR)); 
fs= 220000;
Ts=1/fs;
ftest=floor(2/3*fB);
u = 0.5*sin(2*pi*ftest/N*[0:N-1]);  % half-scale sine-wave input

%% DSM simulation
v = simulateDSM(u,H);

%% time domain analysis

t = 0:Ts:(N-1)*Ts;
figure();
td= 0:200;
stairs(td, u(td+1));
hold on
stairs (td, v(td+1));
hold off
title("Time domain tracking")
xlabel("time")
ylabel("Amplitude u,v")
legend('u','v')

%% frequency domain analysis


f = linspace(0,0.5,N/2+1);
echo on
spec = fft(v.*ds_hann(N))/(N/4);
echo off;
figure(); clf;
plot( f, dbv(spec(1:N/2+1)), 'b')
xlabel('Normalized Frequency')
ylabel('dBFS')
title('Output Spectrum');

echo on
NBW = 1.5/N;
Sqq = 4 * evalTF(H,exp(2i*pi*f)).^2 / 3;
echo off
hold on;
plot( f, dbp(Sqq*NBW), 'm', 'Linewidth', 2 );
text(0.5, -90, sprintf('NBW = %4.1E x f_s ',NBW),'Hor','right');
legend('Simulation','Expected PSD');

%% SQNR analysis for NTF

[sqnr,amp]=simulateSNR(H,OSR,[],[],M+1);
fig3= figure(3);
plot(amp,sqnr,'-o','LineWidth',1);
title("NTF- SQNR analysis")
ylabel("Magnitube/dB")
xlabel("Input level/dBFS")

%% Simulation

model= 'sim2ndorderdsm';

simoptions=simset('Solver', ...
    'VariableStepDiscrete', ...
    'RelTol', 1e-3, ...
    'MaxStep', Ts);

[t_, u_, y] = sim(model, max(t),simoptions,[t',u']);

%% SINC3
Nsinc = 64; % downsampling ratio
h1 = zeros(1, Nsinc);
h1(1:Nsinc) = 1/Nsinc;
hsinc1 = ones(1, Nsinc)*1/Nsinc;
hsinc2 = conv(hsinc1, hsinc1);
hsinc3 = conv(hsinc1, hsinc2);
fig8=figure(8);
freqz(hsinc3);
title("Frequency response of SINC3")
fig9=figure(9);
impz(hsinc3);
title("Impulse response of SINC3")
%% Filter SDM output
Sinc3outOrg = conv(hsinc3, v);
Sinc3out = downsample(Sinc3outOrg, Nsinc);

%% Droop correction filter (DCF)
DCF = fdesign.decimator(Nsinc, 'ciccomp', 1, 3, 'n,fc,ap,ast', 12, 0.45, 0.05, 60);
Hdcf = design(DCF, 'equiripple', 'SystemObject', true);
DCFnum = Hdcf.Numerator;
[DCFfreq, w3] = freqz(DCFnum, 1);
[DCFimp, tw3] = impz(DCFnum, 1);
fig10=figure(10);
freqz(DCFnum, 1);
title("Frequency response of DCF")
fig11=figure(11);
impz(DCFnum, 1);
title("Impulse response of DCF")

%% Filter operation
DCFout = conv(Sinc3out, DCFimp);

%% Half-band filter 1 (HBF1)
FsHBF1 = fs/Nsinc;
HBF1taps = 26;
HBF1num = firhalfband(HBF1taps, 0.25);
[hbf1f, w1] = freqz(HBF1num, 1);
[hbf1t, tw1] = impz(HBF1num, 1);
HBF1outOrg = conv(DCFout, hbf1t);
HBF1out = downsample(HBF1outOrg, 2);
%% Half-band filter 2 (HBF2)
FsHBF2 = FsHBF1/2;
HBF2taps = 50;
HBF2num = firhalfband(HBF2taps, 0.25);
[hbf2f, w2] = freqz(HBF2num, 1);
[hbf2t, tw2] = impz(HBF2num, 1);
HBF2outOrg = conv(HBF1out, hbf2t);
HBF2out = downsample(HBF2outOrg, 2);
fig12=figure(12);
freqz(HBF2num, 1);
title("Frequency response of HBF2")
fig13=figure(13);
impz(HBF2num, 1);
title("Impulse response of HBF2")