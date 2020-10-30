function [imf,trend] = eemd(signal,N_ens)
%EEMD Summary of this function goes here
%   Detailed explanation goes here
max_std = std(signal);
if max_std<0.01
    max_std = 1;
end
time_steps = length(signal);

[imf_sum,res] = emd(signal);

num_imfs = size(imf_sum,2);
residuals = zeros(time_steps,N_ens);
residuals(:,1) = res;
if N_ens>=2
    for i = 1:N_ens-1
        i
        temp_signal = signal + randn(size(signal))*max_std/i;
        [temp_imf,temp_res] = emd(temp_signal);
        num_tmp_imfs = size(temp_imf,2);
        
        % Padding if signals have different number of imfs
        if num_tmp_imfs<num_imfs
            imf_sum = imf_sum + [temp_imf,zeros(time_steps,num_imfs-num_tmp_imfs)];
        elseif num_tmp_imfs>num_imfs
            imf_sum = temp_imf + [imf_sum,zeros(time_steps,num_tmp_imfs-num_imfs)];
            num_imfs = num_tmp_imfs;
        else
            imf_sum = imf_sum + temp_imf;
        end
        residuals(:,i) = temp_res;
    end
    imf = imf_sum/N_ens;

    %Post prosessing
    %imf = zeros(size(imf_sum));
    %imf(:,1) = imf_sum(:,1) - residuals(:,1);
%     for i = 2:size(imf_sum,2)
%         temp_imfs = emd(imf_sum(:,i)+imf_sum(:,i+1));
%         imf(:,i) = imf_sum(:,i); %+ residuals(:,i-1) - residuals(:,i);
%     end
end


% function [modes] = eemd(y, goal, ens, nos)
% goal = 1
% stdy = std(y);
% if stdy < 0.01
%     stdy = 1;
% end
% y = y ./ stdy;
% 
% sz = length(y);
% modes = zeros(goal+1, sz);
% 
% 
% 
% for k = 1:ens
%     disp(['Running ensemble #' num2str(k)]);
%     wn = randn(1, sz) .* nos;
%     y1 = y + wn;
%     y2 = y - wn;
%     modes = modes + emd(y1);
%     if nos > 0 && ens > 1
%         modes = modes + emd(y);  
%     end
% end
% 
% 
% 
% modes = modes .* stdy ./ (ens);
% if nos > 0 && ens > 1
%     modes = modes ./ 2;
% end
% 
% end