classdef MassPropagator < Propagator
    properties
        massRateModels
    end
    
    methods
        function obj = MassPropagator()
            obj@Propagator(IntegratedStates.mass);
        end
        
    end
    
    methods (Hidden)
        function mp = getMandatoryProperties(obj)
            mp = getMandatoryProperties@Propagator(obj);
            mp = horzcat(mp,{'massRateModels'});
        end

    end
    
end
