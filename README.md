LessCompiler
===========================

Less compiler plugin for Codiad-IDE.

This plugin compiles the current Less file on each save.
See http://lesscss.org/ for the Less compiler.

Compilation and Linting is completely done in the browser, so there are no further dependencies.


Changelog
=========

v0.5.3 - 2016/04/17
- fixed an initialization issue

v0.5.2 - 2015/11/09
- updated less compiler to 2.5.3
- removed obsolete options like sourceMap generation

v0.5.1 - 2014/09/28
- updated less compiler to 1.7.5
- fixed bug #2 getFileNameWithoutExtension: using lastIndexOf instead of indexOf

v0.5 - 2014/04/16
- improved file save handling

v0.4 - 2014/04/16
- updated less compiler to 1.7.0
- fixed bug when less imports can't be resolved due to a wrong workspace path

v0.3 - 2014/02/16
- integrated sourcemap option from mozilla that is also used by lessc.


License
=======

The MIT License (MIT)

Copyright (c) 2014 dev-rke

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), 
to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, 
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.