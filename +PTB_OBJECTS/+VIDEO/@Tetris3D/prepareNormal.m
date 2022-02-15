function prepareNormal( self )

% Vector v maps indices to 3D positions of the corners of a face:
self.cube_vertex = [ 0 0 0 ; 1 0 0 ; 1 1 0 ; 0 1 0 ; 0 0 1 ; 1 0 1 ; 1 1 1 ; 0 1 1 ]'-0.5;

self.cube_face = [
    4 3 2 1
    5 6 7 8
    1 2 6 5
    3 4 8 7
    2 3 7 6
    4 1 5 8
    ];

self.cube_normal = zeros(3,6);
for i = 1 : 6
    self.cube_normal(:,i) = cross(...
        self.cube_vertex(:,self.cube_face(i,2))-self.cube_vertex(:,self.cube_face(i,1)),...
        self.cube_vertex(:,self.cube_face(i,3))-self.cube_vertex(:,self.cube_face(i,2))...
        );
end

end % function
