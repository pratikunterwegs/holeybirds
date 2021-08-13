/// a function for time and distance weighted mean filter
#include <vector>
#include <cassert>
#include <Rcpp.h>
using namespace Rcpp;

// [[Rcpp::export]]
Rcpp::NumericVector weighted_mean_filter(Rcpp::NumericVector x_vec,
                                  Rcpp::NumericVector t_vec,
                                  int k) {

  assert(k % 2 != 0 && "k must be an odd number");

  std::vector<double> smooth_x (x_vec.size(), 0.0);

  // handle edge cases returning values as is
  for(int i = 0; i < x_vec.size(); i++) {
    if((i < ((k + 1) / 2)) | (i > (x_vec.size() - ((k + 1) / 2)))) {
      smooth_x[i] = x_vec[i];
    } else {

      double sum_weights_xi = 0.0;
      double weighted_xi = 0.0;
      for(int j = i - ((k - 1) / 2); j < i + ((k - 1) / 2);  j++) {

        // the summed weight for distance from xi in space and time
        sum_weights_xi += j == i ? 1.0 : (
          (1.0 / std::fabs(t_vec[i] - t_vec[j])) +
          (1.0 / std::fabs(x_vec[i] - x_vec[j]))
        );

        // the values of the various xi
        weighted_xi += j == i ? x_vec[i] : (
          ((1.0 / std::fabs(t_vec[i] - t_vec[j])) +
            (1.0 / std::fabs(x_vec[i] - x_vec[j]))) * x_vec[j]
        );
      }
      // Rcout << "sum weighted xi = " << weighted_xi  << "\n";
      // Rcout << "sum weights xi = " << sum_weights_xi  << "\n";
      // get the smoothed value of xi
      smooth_x[i] = weighted_xi / sum_weights_xi;
    }
  }

  return(wrap(smooth_x));
}
