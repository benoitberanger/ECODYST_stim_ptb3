classdef ObjectDispatcher < handle
    
    
    %% Properties
    
    properties
        
        inputVect
        interWidth
        vectLength_x
        vectTotal_x
        unitWidth_x
        x_offcet = 1
        
        nObjPerRow
        vectLength_y
        vectTotal_y
        unitWidth_y
        y_offcet = NaN
        
        count = 0
        
    end % properties
    
    
    %% Methods
    
    methods
        
        %------------------------------------------------------------------
        %- Constructor
        function self = ObjectDispatcher(inputVect, interWidth, nObjPerRow)
            
            if nargin == 0
                return
            end
            
            if nargin < 2 || isempty(interWidth)
                interWidth = 0.05; % from 0 to 1
            end
            
            if nargin < 3
                nObjPerRow = Inf;
            end
            
            self.inputVect  = inputVect;
            self.interWidth = interWidth;
            self.nObjPerRow = nObjPerRow;
            self.interWidth = interWidth;
            
            if ~isfinite(nObjPerRow)
                self.vectLength_x = length(self.inputVect              );
                self.vectTotal_x  = sum   (self.inputVect              );
                self.vectLength_y = 1;
                self.vectTotal_y  = 1;
            else
                self.vectLength_x = length(self.inputVect(1:nObjPerRow));
                self.vectTotal_x  = sum   (self.inputVect(1:nObjPerRow));
                self.vectLength_y = ceil(length(self.inputVect)/nObjPerRow);
                self.vectTotal_y  = self.vectLength_y;
                
            end
            self.y_offcet     = self.vectLength_y;
            self.unitWidth_x  = ( 1 - (self.interWidth*(self.vectLength_x + 1)) ) / self.vectTotal_x ;
            self.unitWidth_y  = ( 1 - (self.interWidth*(self.vectLength_y + 1)) ) / self.vectTotal_y ;
            
        end % function
        
        %------------------------------------------------------------------
        function next(self, value)
            
            if nargin < 2
                value = +1;
            end    
            self.count = self.count + value;
            self.x_offcet = self.count;
            
            if self.x_offcet > self.nObjPerRow
                self.count = 1;
                self.x_offcet = self.count;
                self.y_offcet = self.y_offcet - 1;
            end
            
        end
        
        %------------------------------------------------------------------
        function pos = xpos(self)
            pos = self.unitWidth_x*sum(self.inputVect(1:self.x_offcet-1)) + self.interWidth *(self.x_offcet);
        end
        
        %------------------------------------------------------------------
        function width = xwidth(self)
            width = self.inputVect(self.x_offcet)*self.unitWidth_x;
        end
        
        %------------------------------------------------------------------
        function pos = ypos(self)
            pos = self.unitWidth_y*sum(self.inputVect(1:self.y_offcet-1)) + self.interWidth *(self.y_offcet);
        end
        
        %------------------------------------------------------------------
        function width = ywidth(self)
            width = self.inputVect(self.y_offcet)*self.unitWidth_y;
        end
        
    end % methods
    
    
end % classdef
