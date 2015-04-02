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
