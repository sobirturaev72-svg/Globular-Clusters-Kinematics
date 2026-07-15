function [beta, betaErr] = compute_beta_profile(sigmaR, errSigmaR, sigmaT, errSigmaT)
%COMPUTE_BETA_PROFILE Projected beta and first-order propagated error.
beta = 1 - (sigmaT.^2 ./ sigmaR.^2);
dBeta_dSigmaT = -2 .* sigmaT ./ sigmaR.^2;
dBeta_dSigmaR =  2 .* sigmaT.^2 ./ sigmaR.^3;
betaErr = sqrt((dBeta_dSigmaT .* errSigmaT).^2 + ...
    (dBeta_dSigmaR .* errSigmaR).^2);
end
