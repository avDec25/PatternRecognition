function demo_plot_det
% Make a DET plot.
% This function is called by 'demo_main'

% generate synthetic scores
m = importdata('score.txt');
[x y] = size(m);
index = 1;
for i=1:x
    if m(i,2) == 1
        tar1(1,i) = m(i,3);
        non1(1,index) = m(i,4);
        index = index + 1;
        non1(1,index) = m(i,5);
        index = index + 1;
    elseif m(i,2) == 2
        tar1(1,i) = m(i,4);
        non1(1,index) = m(i,3);
        index = index + 1;
        non1(1,index) = m(i,5);
        index = index + 1;
    else
        tar1(1,i) = m(i,5);
        non1(1,index) = m(i,3);
        index = index + 1;
        non1(1,index) = m(i,4);
        index = index + 1;
    end
end

        


plot_title = 'DET plot example';
prior = 0.3;

plot_type = Det_Plot.make_plot_window_from_string('old');
plot_obj = Det_Plot(plot_type,plot_title);

plot_obj.set_system(tar1,non1,'sys1');
plot_obj.plot_steppy_det({'b','LineWidth',2},' ');
plot_obj.plot_DR30_fa('c--','30 false alarms');
plot_obj.plot_DR30_miss('k--','30 misses');
plot_obj.plot_mindcf_point(prior,{'b*','MarkerSize',8},'mindcf');


plot_obj.display_legend();

fprintf('Look at the figure entitled ''DET plot example'' to see an example of a DET plot.\n');