# News

## Version Updates

### 0.4.4
* Require julia 0.3.4 to remove version restriction on the *Colors* package.
* Call new *Distributions* package methods to get `InverseGamma` shape and scale parameters in the tutorial example.

### 0.4.3
* Fixed `ERROR: too many parameters for type Truncated`.

### 0.4.2
* Added support for optional arguments in `Chains` plot method.
* Implemented direct grid sampling for discrete univariate stochastic nodes with finite support.

### 0.4.1
* Updated and documented `predict` function as an official part of the package.
* Reorganized `Chains` methods documentation.

### 0.4.0

* Added support for user add-on packages and functions to allow for their inclusion in `Model` specifications.
* Added experimental `predict` (posterior prediction) function.
* Required the *Cairo* package.
* Removed deprecated `MCMC*` types and `slicewg` and `SliceWG` functions.
* Fixed `ERROR: GenericMvNormal not defined`.
* Distributions `DiagNormal` and `IsoNormal` removed and replaced by `MvNormal`.
* Distributions `DiagNormalCanon` and `IsoNormalCanon` removed and replaced by `MvNormalCanon`.
* Distributions `DiagTDist` and `IsoTDist` removed and replaced by `MvTDist`.

### 0.3.8

* Updated to fix warning and work with the latest versions of the *PDMat* and *Distributions* packages.

### 0.3.7

* Extend `Chains` draw method to allow automatic outputting of multiple plot grids to different files.
* Add `Chains` plot method to accommodate vectors of plot types.
* Fix variance calculation in `gewekediag()`.

### 0.3.6

* Fix for convert errors triggered by the *Color* package beginning with its version 0.3.9.

### 0.3.5

* Documentation updates only - primarily the addition of results to examples.
* No changes made to the source code.

### 0.3.4

* Added distributions documentation.
* Added jaws repeated measures analysis of variance example.

### 0.3.3

* Fixed the `rand` method definition error (`type DataType has no field body`) that began occurring with late release candidates and final release of julia 0.3.

### 0.3.2

* Fixed tuning parameter overwrites occurring with `pmap()` in single-processor mode.

### 0.3.1

* Added `chains` field to `Chains` type for tracking purposes.
* Fixed `mcmc` to accommodate restarting of chains subsetted by parameters and/or chains.
* Fixed plot legends to properly reference the chains being displayed.
* Added support for sampling of positive-definite matrices specified with Wishart or InverseWishart distributions.
* Added a block-diagonal normal (`BDiagNormal`) distribution.

### 0.3.0

* Implemented restarting of MCMC chains.
* Deprecated `slicewg` and `SliceWG`.  Replaced with `:univar` option to `slice` and `Slice`.

### 0.2.1

* Updated documentation.
* Simplified parallel code.

### 0.2.0

* Automatically load *Distributions* package.
* Implemented parallel execution of parallel chains on multi-processor systems.

### 0.1.0

* Removed `MCMC` prefix from type names, and deprecated `MCMC*` types.

### 0.0.2

* Renamed package from *MCMCsim* to *Mamba*.

### 0.0.1

* Initial public release.