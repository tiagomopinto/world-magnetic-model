# World Magnetic Model 2025-2030

*C bindings for Odin Programming Language*

This package binds the C code (GeomagneticLibrary.c) of the [NOAA's World Magnetic Model 2020](https://www.ncei.noaa.gov/products/world-magnetic-model) using the updated `WMM.COF` file for the years 2025-2030.

The binding requires a static library (`.a` on Linux/MacOS or `.lib` on Windows) compiled into `bin` directory.

## Compilation

Run `make` or `make all` to compile everything from scratch.

Run `make wmm` to compile the `wmm.a` only into the `bin` directory. Update the Makefile to compile a `.lib` file if you are working on Windows.

## License

This project is licensed under the MIT Open Source License.

As stated in NOAA's website, the original C source code project is not licensed or under copyright and may be used freely by the public.
