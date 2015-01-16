README
======

A python wrapper for the QSI C++ API to control QSI CCD Cameras.

INSTALLATION
------------

As well as numpy, you will also need cython installed to create the wrapper.
It goes without saying that you will need a version of the QSI C++ API. This
wrapper is designed to work with versions 7.2.0 and later.

Not all functions are implemented currently, but adding more is straightforward.

Installation proceeds via the usual::

 python setup.py install
 
if you are root, or::

 python setup.py install --prefix=<install dir>
 
if you are not.

If you want to test the module use

 python setup.py build_ext --inplace

USAGE
-----

 import qsiapi

KNOWN_ISSUES
-------------

None yet.


 
 