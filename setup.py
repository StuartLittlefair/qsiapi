from distutils.core import setup
from Cython.Build import cythonize
from distutils.extension import Extension
import numpy 
import os, sys

library_dirs = []
include_dirs = []
include_dirs.append(numpy.get_include())

ext_modules = [
    Extension("qsiapi",
        ["qsiapi.pyx"],
        include_dirs = include_dirs,
        library_dirs = library_dirs,
        libraries = ["qsiapi"]
    )
]
    
setup(
    name = "qsiapi",
    ext_modules = cythonize(ext_modules)
)