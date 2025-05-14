M = 4096; % Modulation order
k = log2(M); % Number of bits per symbol
n = 30000; % Number of symbols per frame
sps = 1; % Number of samples per symbol (oversampling factor)
rng default % Use default random number generator

dataIn = randi([0 1], n*k, 1); 
stem(dataIn(1:40), 'filled');
title('Random Bits');
xlabel('Bit Index');
ylabel('Binary Value');
dataSymbolsIn = bit2int(dataIn, k);

figure; % Create new figure window.
stem(dataSymbolsIn(1:10));
title('Random Symbols');
xlabel('Symbol Index');
ylabel('Integer Value');

dataMod = qammod(dataSymbolsIn, M, 'bin'); % Binary-encoded
dataModG = qammod(dataSymbolsIn, M); % Gray-encoded

EbNo = 10;
snr = convertSNR(EbNo, 'ebno', ...
    'samplespersymbol', sps, ...
    'bitspersymbol', k);

receivedSignal = awgn(dataMod, snr, 'measured');
receivedSignalG = awgn(dataModG, snr, 'measured');

sPlotFig = scatterplot(receivedSignal, 1, 0, 'g.');
hold on
scatterplot(dataMod, 1, 0, 'k*', sPlotFig)

dataSymbolsOut = qamdemod(receivedSignal, M, 'bin'); % Binary-encoded data symbols
dataSymbolsOutG = qamdemod(receivedSignalG, M); % Gray-coded data symbols

dataOut = int2bit(dataSymbolsOut, k);
dataOutG = int2bit(dataSymbolsOutG, k);

[numErrors, ber] = biterr(dataIn, dataOut);
ber = ber / (n * k);
fprintf('\nThe binary coding bit error rate is %5.2e.\n', ber);

[numErrorsG, berG] = biterr(dataIn, dataOutG);
berG = berG / (n * k * log2(M));
fprintf('\nThe Gray coding bit error rate is %5.2e.\n', berG);


scatterplot(symgray, 1, 0, 'b*');
for k = 1:M
    text(real(symgray(k)) - 0.0, imag(symgray(k)) + 0.3, ...
        dec2base(x(k), 2, log2(M)), 'Color', [0 1 0]);
    text(real(symgray(k)) - 0.5, imag(symgray(k)) + 0.3, ...
        num2str(x(k)), 'Color', [0 1 0]);

    text(real(symbin(k)) - 0.0, imag(symbin(k)) - 0.3, ...
        dec2base(x(k), 2, log2(M)), 'Color', [1 0 0]);
    text(real(symbin(k)) - 0.5, imag(symbin(k)) - 0.3, ...
        num2str(x(k)), 'Color', [1 0 0]);
end
title('4096-QAM Symbol Mapping');
axis([-4 4 -4 4]);