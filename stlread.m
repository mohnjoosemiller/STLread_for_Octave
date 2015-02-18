function [vertices, faces, color] = stlread(filename)
% This function reads an STL file in binary format into matrixes vertices
% and faces which can be used by patch to view the stl.
%
% MATLAB code by Doron Harlev
% Octave edits by John Moosemiller

% Process arguments {{{
if nargout > 3
    error('Too many output arguments');
end
use_color = ( nargout == 3 );% }}}

% Open the file, assumes STL Binary format. {{{
if ( fid = fopen(filename, 'r') ) == -1;
    error('File could not be opened, check name or path.')
end% }}}

% Read in header {{{
ftitle = fread(fid, 80, 'uchar=>schar'); % Read file title
num_facet = fread(fid, 1, 'int32'); % Read number of Facets

fprintf('\nTitle: %s\n', char(ftitle'));
fprintf('Num Facets: %d\n', num_facet);
% }}}

% Preallocate memory to save running time {{{
vertices = zeros( 3 * num_facet, 3 );
faces    = zeros(     num_facet, 3 );
if use_color
    color = uint8( zeros( 3, num_facet ) );
end
% }}}

% Read in packed data for each face {{{
coord_sz = 3*32/8; % [bytes] size of single vertex coordinate '3*float32'
color_sz = 1*16/8; % [bytes] size of color data: '1*uint16'
block_sz = 4 * coord_sz + color_sz; % [bytes] 3*float32 + 1 uint16

fid_coord_offset = ftell( fid );
% Read norm of the face {{{
% at fid_coord_offset + 0
start_offset = 0;
norm = fread( fid, [3, num_facet], '3*float32', block_sz - coord_sz );
start_offset = start_offset + coord_sz;% }}}
% Read first vertex of each face {{{
fseek( fid, fid_coord_offset + start_offset );
ver1 = fread( fid, [3, num_facet], '3*float32', block_sz - coord_sz );
start_offset = start_offset + coord_sz;% }}}
% Read second vertex of each face {{{
fseek( fid, fid_coord_offset + start_offset );
ver2 = fread( fid, [3, num_facet], '3*float32', block_sz - coord_sz );
start_offset = start_offset + coord_sz;% }}}
% Read third vertex of each face {{{
fseek( fid, fid_coord_offset + start_offset );
ver3 = fread( fid, [3, num_facet], '3*float32', block_sz - coord_sz );
start_offset = start_offset + coord_sz;% }}}
% Read the color of each face {{{
fseek( fid, fid_coord_offset + start_offset );
col  = fread( fid, num_facet, '1*uint16', block_sz - color_sz );% }}}
% }}}

% Reshape data into faces and vertices {{{
% columns are each face {{{
% face_vertices =
%       f1_v_1x  f2_v_1x ... fN_v_1x
%       f1_v_1y  f2_v_1y ... fN_v_1y
%       f1_v_1z  f2_v_1z ... fN_v_1z
%       f1_v_2x  f2_v_2x ... fN_v_2x
%       f1_v_2y  f2_v_2y ... fN_v_2y
%       f1_v_2z  f2_v_2z ... fN_v_2z
%       f1_v_3x  f2_v_3x ... fN_v_3x
%       f1_v_3y  f2_v_3y ... fN_v_3y
%       f1_v_3z  f2_v_3z ... fN_v_3z
face_vertices = vertcat( ver1, ver2, ver3 );% }}}
% interleave vertices% {{{
% so that we get
% vertices =
%        f1_v_1x f1_v_1y f1_v_1z
%        f1_v_2x f1_v_2y f1_v_2z
%        f1_v_3x f1_v_3y f1_v_3z
%        f2_v_3x f2_v_3y f2_v_3z
%        ...     ...     ...
%        fN_v_2x fN_v_2y fN_v_2z
%        fN_v_3x fN_v_3y fN_v_3z
vertices = reshape(face_vertices(:), 3, [])';% }}}
% face triangle vertices are in sequential rows of `vertices`% {{{
% faces =
%        1    2    3
%        4    5    6
%        .    .    .
%        3N-2 3N-1 3N
faces = reshape( 1:3*num_facet, 3, [])';% }}}
% extract color from bits% {{{
if use_color && any(col)
	valid = bitget(col,16) == 1;
	r = bitshift( bitand(2^16-1, col), -10 );
	g = bitshift( bitand(2^11-1, col), -5  );
	b = bitand(2^6-1, col);

	% only keep the valid color data, set other to zero (black)
	color = [r g b] .* valid;
end% }}}
% }}}

fclose(fid);

% For more information http://rpdrc.ic.polyu.edu.hk/old_files/stl_binary_format.htm
