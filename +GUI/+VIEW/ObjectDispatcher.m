classdef ObjectDispatcher < handle
    
    
    %% Properties
    
    properties
        
        inputVect
        interWidth
        vectLength
        vectTotal
        unitWidth
        
        count = 0
        
    end % properties
    
    
    %% Methods
    
    methods
        
        %------------------------------------------------------------------
        %- Constructor
        function self = ObjectDispatcher(inputVect, interWidth)
            
            if nargin == 0
                return
            end
            
            if nargin < 2
                interWidth = 0.05; % from 0 to 1
            end
            
            self.inputVect  = inputVect;
            self.interWidth = interWidth;
            
            self.interWidth = interWidth;
            self.vectLength = length(self.inputVect);
            self.vectTotal  = sum(self.inputVect);
            self.unitWidth  = ( 1 - (self.interWidth*(self.vectLength + 1)) ) / self.vectTotal ;
            
        end % function
        
        %------------------------------------------------------------------
        function next(self, value)
            if nargin < 2
                value = +1;
            end    
            self.count = self.count + value;
        end
        
        %------------------------------------------------------------------
        function pos = xpos(self)
            pos = self.unitWidth*sum(self.inputVect(1:self.count-1)) + self.interWidth *(self.count);
        end
        
        %------------------------------------------------------------------
        function width = xwidth(self)
            width = self.inputVect(self.count)*self.unitWidth;
        end
        
        
    end % methods
    
    
end % classdef
