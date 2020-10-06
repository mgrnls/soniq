.wav.writeMono:{[d;fs;p]
  if[not 9h=type d;show"Only works for mono signals.";:(::)];
  f:{reverse 0x0 vs x};
  sc2:raze(`byte$"data";f"i"$count data;data:raze f each"h"$32768*1&-1|d);
  sc1:raze(`byte$"fmt "),f each(16i;1h;1h;"i"$fs;"i"$fs*2;2h;16h);
  o:raze(`byte$"RIFF";f "i"$4+sum count each(sc1;sc2);`byte$"WAVE";sc1;sc2);
  p 1:o;
  };

.wav.getLength: {sum x * prd each (til count x) #' 256};

.wav.read: {[path]
  bytes: read1 path;
  if[not ("RIFF" ~ `char $ bytes til 4) and "WAVE" ~ `char $ bytes 8 + til 4;
    : `success`errmsg ! (0b; "Not a WAV file.")];
  if[(count 8 _ bytes) <> .wav.getLength bytes 4 + til 4;
    : `success`errmsg ! (0b; "Bad chunk size.")];
  if[1 <> .wav.getLength bytes 20 + til 2;
    :`success`errmsg ! (0b; "Not PCM.")];
  fmt: bytes 20 22 24 28 32 34 40 + til each 2 2 4 4 2 2 4;
  d: `pcm`nc`fs`br`ba`bps`size ! .wav.getLength each fmt;
  if[16 <> d `bps;
    : `success`errmsg ! (0b; "Only supports 16 bits per sample audio.")];
  data: bytes 44 + til d `size;
  samples: 0N 2 # data;
  channels: samples {(til x) +\: x * til (count y) div x}[d `nc; samples];
  n: (count data) div d `ba;
  b: raze each flip each {(y # "h"; y # 2) 1: x}[; n] each raze each channels;
  `fs`data`success ! (d `fs; -1 ^ b % 32768; 1b)
  };
