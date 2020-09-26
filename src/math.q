/ math functions for complex numbers

/ we write single complex numbers as pairs of floats or longs:
/ 3 5 -> 3 + 5i

/ We write complex vectors as follows:
/ (1 1 1 1; 0 0 0 0) -> 1 1 1 1 real part and no imaginary part.

.math.comp:{(x;$[1=c:count x;0;c#0])};

.math.mult:{(((x 0)*y 0)-((x 1)*y 1);((x 1)*y 0)+((x 0)*y 1))};

.math.conj:{(x 0;neg x 1)};

.math.mag:{sqrt sum x*x};

.math.phase:{?[(0>x 0)and 0=x 1;acos -1;2*atan(x 1)%(x 0)+sqrt sum x*x]}

.math.e:{(cos x;sin x)};

.math.pi:acos -1;

.math.w:{.math.e each neg 2*.math.pi*(a*/:a:til x)%x};

.math.dft:{flip(1%sqrt n)*(sum')each .math.mult[;x]each .math.w n:count flip x};

.math.idft:{flip(1%sqrt n)*(sum')each .math.mult[;x]each .math.conj each .math.w n:count flip x};
