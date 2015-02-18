function [vertices, faces] = stlread(filename)
% This function reads an STL file in binary format into matrixes X, Y and
% Z, and C.  C is optional and contains color rgb data in 5 bits.  
%
% USAGE: [x, y, z, c] = stlread(filename);
%
% To plot use patch(x,y,z,c), or patch(x,y,z)
%
% MATLAB code by Doron Harlev
% Octave edits by John Moosemiller
if nargout>4
    error('Too many output arguments')
end
use_color=(nargout==4);

fid=fopen(filename, 'r'); %Open the file, assumes STL Binary format.
if fid == -1 
    error('File could not be opened, check name or path.')
end

ftitle=fread(fid,80,'uchar=>schar'); % Read file title
num_facet=fread(fid,1,'int32'); % Read number of Facets

fprintf('\nTitle: %s\n', char(ftitle'));
fprintf('Num Facets: %d\n', num_facet);

% Preallocate memory to save running time
vertices = zeros(3*num_facet,3);
faces = zeros(num_facet,3);

if use_color
    c=uint8(zeros(3,num_facet));
end

for i=1:num_facet,
    norm=fread(fid,3,'float32'); % normal coordinates, ignored for now
    ver1=fread(fid,3,'float32'); % vertex 1
    ver2=fread(fid,3,'float32'); % vertex 2
    ver3=fread(fid,3,'float32'); % vertex 3
    col=fread(fid,1,'uint16'); % color bytes
    if (bitget(col,16)==1 & use_color)
        r=bitshift(bitand(2^16-1, col),-10);
        g=bitshift(bitand(2^11-1, col),-5);
        b=bitand(2^6-1, col);
        c(:,i)=[r; g; b];
    end
    vertices((3*i-2) , :) = [ver1(1),ver1(2),ver1(3)];
    vertices(3*i-1 , :) = [ver2(1),ver2(2),ver2(3)];
    vertices(3*i , :) = [ver3(1),ver3(2),ver3(3)];
    
    faces(i, :) = [3*i-2,3*i-1,3*i];
    
   % x(:,i)=[ver1(1); ver2(1); ver3(1)]; % convert to matlab "patch" compatible format
   % y(:,i)=[ver1(2); ver2(2); ver3(2)];
   % z(:,i)=[ver1(3); ver2(3); ver3(3)];
end
if use_color
    varargout(1)={c};
end
fclose(fid);

% For more information http://rpdrc.ic.polyu.edu.hk/old_files/stl_binary_format.htm
