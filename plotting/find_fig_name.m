function fig_num = find_fig_name(name)
%FIND_FIG_NUM Opens the figure with the given name. Otherwise creates new
%figure with given name

    fig =  findobj('type','figure','Name',name);
    if isempty(fig)
        fig = figure('Name',name);
    elseif length(fig) > 1
        
        %Multiple figures with the same name, open the first one
        disp([num2str(length(fig)),' figures existed with the name:  ',name,'.  Opened figure ',num2str(fig(1).Number)])
        fig = fig(1);
        
    end
    fig_num = fig.Number;
end

