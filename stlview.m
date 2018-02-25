%Copyright 2018 John Moosemiller

%Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

%The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

%THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.



function [ ] = stlview(varargin)
% {{{
% This function uses patch() and the stlread()
% function to view .STL data.
% 
% example usage:
% stlview( 'binarySTL.stl', 
%
% current iteration simply patches, more settings coming
% }}}

[vertices, faces] = stlread( varargin(1) );
patch( 'Faces', faces, 'Vertices', vertices );
%Uncomment following if statement to enable viewing from a specific cartesian point
%if size(varargin) == 4
%    view([varargin(2) varargin(3) varargin(4));
%end


end
