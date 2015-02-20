function [vertices, faces, color] = stlread(filename)
% This function reads an STL file in binary format into matrixes vertices
% and faces which can be used by patch to view the stl.
%
% MATLAB code by Doron Harlev
% Octave edits by John Moosemiller && @zmughal

read_norm = 0; % whether we want to read the face normals

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
coord_sz = 3*32/8; % [bytes] size of vertex coordinates (x,y,z) '3*float32'
color_sz = 1*16/8; % [bytes] size of color data: '1*uint16'
block_sz = 4*coord_sz + color_sz; % [bytes] 4 coords (norm, v1, v2, v3) + 1 color data

% get the start of where the face data is in the file
fid_face_data_start = ftell( fid );

% Read norm of the face [1*coord_sz] {{{
start_offset = 0; % at fid_face_data_start + 0
if read_norm
	norm = fread( fid, [3, num_facet], '3*float32', block_sz - coord_sz );
end
start_offset = start_offset + 1*coord_sz;% }}}
% Read all 3 vertices of each face [3*coord_sz] {{{
% Each column is the 3 vertices with 3 coords each for each face
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
fseek( fid, fid_face_data_start + start_offset );
face_vertices = fread( fid, [3*3, num_facet], '9*float32', block_sz - 3*coord_sz );
start_offset = start_offset + 3*coord_sz;% }}}
% Read the color of each face [1*color_sz] {{{
if use_color
	fseek( fid, fid_face_data_start + start_offset );
	col  = fread( fid, num_facet, '1*uint16', block_sz - 1*color_sz );% }}}
end
% }}}

% Reshape data into faces and vertices {{{
% interleave vertices {{{
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

% For more information on the stl binary format - http://rpdrc.ic.polyu.edu.hk/old_files/stl_binary_format.htm
