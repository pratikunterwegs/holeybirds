// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <Rcpp.h>

using namespace Rcpp;

#ifdef RCPP_USE_GLOBAL_ROSTREAM
Rcpp::Rostream<true>&  Rcpp::Rcout = Rcpp::Rcpp_cout_get();
Rcpp::Rostream<false>& Rcpp::Rcerr = Rcpp::Rcpp_cerr_get();
#endif

// weighted_mean_filter
Rcpp::NumericVector weighted_mean_filter(Rcpp::NumericVector x_vec, Rcpp::NumericVector t_vec, int k);
RcppExport SEXP _holeybirds_weighted_mean_filter(SEXP x_vecSEXP, SEXP t_vecSEXP, SEXP kSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< Rcpp::NumericVector >::type x_vec(x_vecSEXP);
    Rcpp::traits::input_parameter< Rcpp::NumericVector >::type t_vec(t_vecSEXP);
    Rcpp::traits::input_parameter< int >::type k(kSEXP);
    rcpp_result_gen = Rcpp::wrap(weighted_mean_filter(x_vec, t_vec, k));
    return rcpp_result_gen;
END_RCPP
}

static const R_CallMethodDef CallEntries[] = {
    {"_holeybirds_weighted_mean_filter", (DL_FUNC) &_holeybirds_weighted_mean_filter, 3},
    {NULL, NULL, 0}
};

RcppExport void R_init_holeybirds(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
