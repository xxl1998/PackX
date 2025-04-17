#include <iostream>
#include <vector>
#include "ceres/ceres.h"
#include "glog/logging.h"

struct PolyResidual {
  PolyResidual(double x, double y) : x_(x), y_(y) {}

  template <typename T>
  bool operator()(const T* const abc_d, T* residual) const {
    T a = abc_d[0];
    T b = abc_d[1];
    T c = abc_d[2];
    T d = abc_d[3];
    residual[0] = y_ - (a * x_ * x_ * x_ + b * x_ * x_ + c * x_ + d);
    return true;
  }

 private:
  const double x_;
  const double y_;
};

int main(int argc, char** argv) {
  google::InitGoogleLogging(argv[0]);

  // y=x^3-x^2+2x-3
  std::vector<double> xs = {-1, 0, 1, 2};
  std::vector<double> ys = {-7, -3, -1, 5};

  // y = ax^3 + bx^2 + cx + d
  double abc_d[4] = {0.0, 0.0, 0.0, 0.0};

  ceres::Problem problem;

  for (int i = 0; i < xs.size(); ++i) {
    ceres::CostFunction* cost_function =
        new ceres::AutoDiffCostFunction<PolyResidual, 1, 4>(
            new PolyResidual(xs[i], ys[i]));
    problem.AddResidualBlock(cost_function, nullptr, abc_d);
  }

  ceres::Solver::Options options;
  options.minimizer_progress_to_stdout = true;

  ceres::Solver::Summary summary;
  ceres::Solve(options, &problem, &summary);

  std::cout << summary.BriefReport() << "\n";

  std::cout << "Fitted coefficients:\n";
  std::cout << "a = " << abc_d[0] << "\n";
  std::cout << "b = " << abc_d[1] << "\n";
  std::cout << "c = " << abc_d[2] << "\n";
  std::cout << "d = " << abc_d[3] << "\n";

  const double gt[4] = {1.0, -1.0, 2.0, -3.0}; // ground truth
  bool success = true;
  double threshold = 1e-6;
  for (int i = 0; i < 4; ++i) {
    double diff = std::abs(abc_d[i] - gt[i]);
    if (diff > threshold) {
      success = false;
      std::cout << "Parameter [" << i << "] mismatch: diff = " << diff << "\n";
    }
  }

  if (success)
    std::cout << "✅ Fit succeeded! All parameters within threshold " << threshold << ".\n";
  else
    std::cout << "❌ Fit failed. Some parameters exceed threshold " << threshold << ".\n";

  return 0;
}
