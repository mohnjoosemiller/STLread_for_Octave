stlread() for Octave
====================

## Description

`stlread()` is a function for octave that takes in a binary (NOT ASCII) .stl'a and outputs the vertices and a list of each face's vertices.

`stlread()` outputs 2 matrices that can be immediately ploted using `patch()`

## Usage

Retrieving the vertices and faces is easy

```matlab
%assuming you have a file "sample.stl"
[vertices, faces, c] = stlread('sample.stl');
```

In order to plot these you might follow with

```matlab
patch( 'Faces', faces, 'Vertices', verticies );
```

## Limitations

Thanks to edits by @zmughal code runs ~100x 
faster now. most STLs <40 MB should be quick.

## Future

stlview() function should arrive soon. Will 
have options for display characteristics. 




