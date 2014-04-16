Codiad-LessCompiler
===========================

Less compiler plugin for Codiad-IDE

This plugin compiles the current Less file on each save.
See http://lesscss.org/ for the Less compiler.

Compilation and Linting is completely done in the browser, so there are no further dependencies.

Installation
============

	Download the zip file and extract it to your plugins folder


Changelog
=========

v0.5 - 2014/04/16
- improved file save handling

v0.4 - 2014/04/16
- updated less compiler to 1.7.0
- fixed bug when less imports can't be resolved due to a wrong workspace path

v0.3 - 2014/02/16
- integrated sourcemap option from mozilla that is also used by lessc.
