classdef Point < handle
    %POINT Class to symplify syntax of X Y Z coordinates
    
    %% Properties
    
    properties % "normal" proprerties
        
        x (1,1) double
        y (1,1) double
        z (1,1) double
        
    end % properties
    
    properties (Dependent)
        
        xyz % column vector
        
    end % properties
    
    
    %% Methods
    
    methods
        
        % -----------------------------------------------------------------
        %                           Constructor
        % -----------------------------------------------------------------
        
        function self = Point(varargin)
            
            if nargin > 0
                
                msg = 'Point accepts 1 vector [x y z], or 3 elements for x,y and z';
                
                dim = length(varargin);
                
                switch dim
                    case 3
                        self.x = varargin{1};
                        self.y = varargin{2};
                        self.z = varargin{3};
                    case 1
                        assert(isnumeric(varargin{1}) && isvector(varargin{1}) && length(varargin{1})==3, msg)
                        self.xyz = varargin{1};
                    otherwise
                        error(msg)
                end
                
            end
            
        end % ctor
        
        
        % -----------------------------------------------------------------
        %                           set/get xyz
        % -----------------------------------------------------------------
        
        function set.xyz(self, xyz)
            self.x = xyz(1);
            self.y = xyz(2);
            self.z = xyz(3);
        end
        
        function xyz = get.xyz(self)
            xyz = [self.x ; self.y ; self.z];
        end
        
    end % methods
    
    
end % classdef
