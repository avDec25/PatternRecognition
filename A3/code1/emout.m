function [pie_k, mu_k, sigma_k] = emout( C1, K, num_iterations, prec )

    [classify,c] = kmeans(C1,K);
% 
%     plot(C1(:,1),C1(:,2),'ko', 'MarkerFaceColor', 'r');
%     figure;

    all_points_in_cluster = [];
    for k = 1 : K
      points = [];
      for i = 1 : size(classify)
         if classify(i) == k
          points = [points; C1(i,:)];
         end
      end
      all_points_in_cluster{k} = points;
    end

    N = size(C1,1);

    cov_of_cluster = [];
    for k = 1 : K
       temp = cov(all_points_in_cluster{k});
        %cov_of_cluster{k} = diag(diag(temp));
        cov_of_cluster{k} = (temp);
    end

    pie = [];
    for k = 1 : K
      pie{k} = size(all_points_in_cluster{k},1) / N;
    end
    
    mu = [];
    for k = 1 : K
      mu{k} = c(k,:);
    end

    n_k     = [];
    mu_k    = [];
    sigma_k = [];
    pie_k   = [];
    
    for iter = 1 : num_iterations

      %% Expectation Step ------------------------------------------------------
      if iter == 1
            
        point_pdf = [];
        for i = 1 : N
          for k = 1 : K
            point_pdf(i,k) = pie{k} * mvnpdf(C1(i,:),mu{k},cov_of_cluster{k});
          end
        end

        for i = 1 : N
          sum_point_pdf = sum(point_pdf(i,:));
          for k = 1 : K
            gamma_nk(i,k) = point_pdf(i,k) / sum_point_pdf;
          end
        end

        likeli = sum_point_pdf;

      else

        likelihood_prev = sum_point_pdf;

        point_pdf = [];
        for i = 1 : N
          for k = 1 : K
            point_pdf(i,k) = pie_k{k} * mvnpdf(C1(i,:),mu_k{k},sigma_k{k});
          end
        end

        for i = 1 : N
          sum_point_pdf = sum(point_pdf(i,:));
          for k = 1 : K
            gamma_nk(i,k) = point_pdf(i,k) / sum_point_pdf;
          end
        end

        likeli = [likeli sum_point_pdf];

        if round(abs(likelihood_prev - sum_point_pdf),prec) <= 10^(-prec)
          fprintf('\nAt Iteration %d\nLikelihood became equal to Previous Likelihood\nCurrent likelihood value = %f with precision of 10^(%d)\n\n', iter, sum_point_pdf, -prec);          
          break; 
        end
      end

      for k = 1 : K
        n_k(k) = sum(gamma_nk(:,k));
      end

      
      %% Maximization Step -----------------------------------------------------
      for k = 1 : K
        sm = 0;
        for i = 1 : N
          sm = sm + gamma_nk(i,k) * C1(i,:);
        end
        mu_k{k} = sm / n_k(k);
      end

      for k = 1 : K
        sm = zeros(2,2);
        for i = 1 : N
          sm = sm + gamma_nk(i,k) * ((C1(i,:) - mu_k{k})' * (C1(i,:) - mu_k{k}));
        end
        %sigma_k{k} = diag(diag(sm)) / n_k(k);
        sigma_k{k} = sm / n_k(k);
        pie_k{k} = n_k(k) / N;    
      end

      fprintf('\nRunning Iteration %d\nLikelihood = %f\n', iter, sum_point_pdf);
      
    end % end of EM Algorithm

%     plot(1:iter, likeli);
%     figure;

end