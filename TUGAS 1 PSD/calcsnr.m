function snr = calcsnr(speech, qspeech)
  qerr = speech-qspeech;
  snr = 10*log10(sum(speech.*speech)/sum(qerr.*qerr))

