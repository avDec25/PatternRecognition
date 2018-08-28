function probability = computeProb( point, c1_pie_k, c1_mu_k, c1_sigma_k )

    K = size(c1_mu_k,2);
    probability = 0;
    for k = 1 : K
        probability = probability + c1_pie_k{k} * mvnpdf(point, c1_mu_k{k}, c1_sigma_k{k});
    end
    probability  = log(probability);
end