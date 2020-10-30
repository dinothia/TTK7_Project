function fig = open_figure(name,varargin)
    %Parsing of optional parameters
    p = inputParser;
    isValid = @(x)(isnumeric(x)||islogical(x));
    addOptional(p,'newFig',false,isValid);
    addOptional(p,'clearFig',true);
    p.KeepUnmatched = true;
    parse(p,varargin{:})
    
   
    if isempty(name)
        fig = figure;
    elseif p.Results.newFig
       fig = figure('Name',name);
    else
       fig = figure(find_fig_name(name));
    end
    if p.Results.clearFig
       clf;
    end
end