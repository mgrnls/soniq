/ math functions for complex numbers

/ we write single complex numbers as pairs of floats or longs:
/ 3 5 -> 3 + 5i

/ We write complex vectors as follows:
/ (1 1 1 1; 0 0 0 0) -> 1 1 1 1 real part and no imaginary part.

.math.comp: {[real]
  / Takes a real number/vector and returns it's complex equivalent.
  (real; $[1 = c: count real; 0; c # 0])
  };

.math.mult: {
  / Multiples two complex numbers/vectors in a pointwise fashion.
  (((x 0) * y 0) - ((x 1) * y 1); ((x 1) * y 0) + ((x 0) * y 1))
  };

.math.conj: {
  / Return the conjugate of a complex number/vector.
  (x 0; neg x 1)
  };

.math.mag: {
  / Return the magnitude of a complex number/vector.
  sqrt sum x * x
  };

.math.phase: {
  / Return the phase of a complex number/vector.
  ?[(0 > x 0) and 0 = x 1; acos -1; 2 * atan (x 1) % (x 0) + sqrt sum x * x]
  };

.math.e: {
  / Return the complex exponential on a complex number/vector.
  (cos x; sin x)
  };

.math.pi: acos -1;

.math.w: {
  / Construct a square matrix size x of DFT coefficients
  .math.e each neg 2 * .math.pi * (a */: a: til x) % x
  };

.math.dft: {
  / Takes a complex vector and returns its DFT.
  flip (1 % sqrt n) * (sum') each .math.mult[; x] each .math.w n: count x 0
  };

.math.idft: {
  / Takes a copmlex vector and returns its IDFT.
  w: .math.w n: count x 0;
  flip (1 % sqrt n) * (sum') each .math.mult[; x] each .math.conj each w
  };

.math.zeropad: {
  / Zero pads a vector x to the next power of 2 >= the length of x.
  c: ceiling 2 xlog n: count x;
  x , #[; 0] (prd c # 2) - n
  };

.math.bitrev: {
  / Might not need this.
  2 sv reverse 2 vs til x
  };
