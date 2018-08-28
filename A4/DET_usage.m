function DET_usage(fpr,fnr)

% DET evaluation Graphics
% Version 1.2 28-JUL-2000
% George Doddington
%
% DET plots (Detection Error Trade-off)
%	DET_usage	- Example program of below functions
%	Compute_DET	- Computes miss/false_alarm probabilities
%	Plot_DET	- Plots a DET
%	Set_DCF		- Initializes the detection cost fundtion
%	Min_DCF		- Finds minimum detection cost function
%	Set_DET_limits	- initializes the min/max plotting limits
%	ppndf		- Warps cumulative probability to normal deviate
%
% The Detection Error Trade-off (DET) Plotting Package
%
% The DET plotting package provide functions to support plotting the results
% of detection expoeriments in an intuitively meaningful way. Detection error
% probabilities (miss and false alarm probabilities) are plotted on a nonlinear
% scale. This scale transforms the error probability by mapping it to is
% corresponding Gaussian deviate. Thus DET curves are straight lines when
% the underlying distributions are Gaussian. This makes DET plots more
% intuitive and visually meaningful.
%
% The DET plotting package comprises 7 matlab functions:
%
%  There are two primary user-callable functions:
%    Compute_DET -- computes the DET from detection system output results.
%    Plot_DET    -- plots the DET produced by Compute_DET.
%
%  There are two auxiliary functions which find a DET's minimum cost point:
%    Set_DCF -- initializes the detection cost unction parameters.
%    Min_DCF -- finds the detection error trade-off which gives minimum cost.
%
%  There are three supporting functions (which the user needn't call):
%    Set_DET_limits -- changes the DET plotting limits.
%    ppndf          -- transforms probabilities to corresponding Gaussian deviates.
%
% Further documentation is available for the various DET functions by using
% the matlab help command.
%
% Execute this script to see 5 examples using the DET pakage.


% Sometimes it is desirable to have a thicker line plotted. To adjust
% the line thickness, just add an argument to the Plot_DCF. Default
% is 0.5. A value between 2 and 5 will give a thick line.
% Here is an example:

   %-----------------------
   % Create simulated detection output scores

   Ntrials_True = 1000;
   True_scores = randn(Ntrials_True,1);

   Ntrials_False = 1000;
      mean_False = -3;
      stdv_False = 1;
   False_scores = stdv_False * randn(Ntrials_False,1) + mean_False;

   %-----------------------
   % Compute Pmiss and Pfa from experimental detection output scores

   [P_miss,P_fa] = Compute_DET(fpr,fnr);

   %-----------------------
   % Plot the detection error trade-off

   thickness = 2;
   figure;
   Plot_DET (P_miss,P_fa,'r',thickness);
   title('A DET plot with a thick line');
   hold on;

   C_miss = 1;
   C_fa = 1;
   P_target = 0.5;

   Set_DCF(C_miss,C_fa,P_target);
   [DCF_opt Popt_miss Popt_fa] = Min_DCF(P_miss,P_fa);
   Plot_DET (Popt_miss,Popt_fa,'ko',thickness);

% The underlying function (called "thick") which makes the line thick can also be 
% used with the standard matlab plot function. 

% Example usage: thick(2,plot([1:5],[1,0,1,0,1],'b'))

echo off;
clear C_fa P_fa ans C_miss P_miss mean_False DCF_opt P_target stdv_False ...
      False_scores Popt_fa thickness Ntrials_False Popt_miss Ntrials_True True_scores         
clear global DET_limits;

