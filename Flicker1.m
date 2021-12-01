% Flicker Method 1

clear;
Nx = 2^16;  % number of samples to synthesize
B = [0.049922035 -0.095993537 0.050612699 -0.004408786];
A = [1 -2.494956002   2.017265875  -0.522189400];
nT60 = round(log(1000)/(1-max(abs(roots(A))))); % T60 est.
v = randn(1,Nx+nT60); % Gaussian white noise: N(0,1)
x = filter(B,A,v);    % Apply 1/F roll-off to PSD
x = x(nT60+1:end);    % Skip transient response


% Ref: https://www.mathworks.com/help/signal/ug/power-spectral-density-estimates-using-fft.html

Fs = Nx;
N = length(x);
xdft = fft(x);
xdft = xdft(1:N/2+1);
psdx = (1/(Fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1); 
freq = 0:Fs/length(x):Fs/2;

fig1 = figure;
plot(freq,10*log10(psdx))
grid on
hold on
plot(freq,10*log10(1./freq), 'g')
title('Periodogram Using FFT')
xlabel('Frequency (Hz)')
ylabel('Power/Frequency (dB)')

fig2 = figure;
periodogram(x,rectwin(length(x)),length(x),Fs)

fig3 = figure;
pwelch(x)
hold on
plot(freq/max(freq),10*log10(1./freq), 'g')