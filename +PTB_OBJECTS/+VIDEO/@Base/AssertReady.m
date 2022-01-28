function AssertReady( self )

props = properties(self);

for p = 1: length(props)
    
    assert( ~isempty(self.(props{p})) , '%s is empty' , props{p} )
    
end

end % function
