.wav.read:{[p]
  lhti:{(first/)(enlist(2 4 8!"hij")c;enlist c:count x)1:x};
  bytes:read1 p;
  if[not"RIFF"~`char$bytes til 4;:`success`errmsg!(0b;"Not RIFF file.")];
  if[(count 8_bytes)<>lhti bytes 4+til 4;:`success`errmsg!(0b;"Listed chunk size does not match actual chunk size.")];
  if[not"WAVE"~`char$bytes 8+til 4;`success`errmsg!(0b;"Not WAVE file.")];
  if[1<>lhti bytes 20+til 2;:`success`errmsg!(0b;"Not PCM.")];
  d:`nc`fs`br`ba`bps`sc2s!('[lhti;bytes])each 22 24 28 32 34 40+til each 2 4 4 2 2 4;
  if[16<>d`bps;:`success`errmsg!(0b;"Only supports 16 bits per sample audio.")];
  data:bytes 44+til d`sc2s;
  channels:raze each s{(til x)+\:x*til(count y)div x}[d`nc;s:0N 2#data];
  n:(count data)div 2*d`nc;
  b:raze each flip each{(y#"h";y#2)1:x}[;n]each channels;
  d[`data`success]:(-1^b%32768;1b);
  d
  }

.wav.writeMono:{[d;fs;p]
  if[not 9h=type d;show"Only works for mono signals.";:(::)];
  f:{reverse 0x0 vs x};
  sc2:raze(`byte$"data";f"i"$count data;data:raze f each"h"$32768*1&-1|d);
  sc1:raze(`byte$"fmt "),f each(16i;1h;1h;"i"$fs;"i"$fs*2;2h;16h);
  o:raze(`byte$"RIFF";f "i"$4+sum count each(sc1;sc2);`byte$"WAVE";sc1;sc2);
  p 1:o;
  }
