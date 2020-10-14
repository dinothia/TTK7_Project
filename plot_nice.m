function [] = plot_nice(t, signal, x_lim, y_lim, label_x, label_y)
    plot(t, signal);
    
    xlabel(label_x);
    ylabel(label_y);
    
    xlim(x_lim);
    ylim(y_lim);
end

