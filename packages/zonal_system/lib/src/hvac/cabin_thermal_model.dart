/// Very simple lumped thermal model of the cabin, enough to make the climate
/// HMI feel alive ("Inside 31° → 22°").
///
/// With the blower on, the cabin converges to the requested temperature faster
/// with a higher fan speed; with the blower off it slowly drifts to the outside temperature.
abstract final class CabinThermalModel {
  /// Converged when closer than this to the equilibrium temperature.
  static const tolerance = 0.05;

  static double equilibrium({required bool isBlowing, required double target, required double outside}) =>
      isBlowing ? target : outside;

  /// Cabin temperature after [seconds].
  static double step({
    required double cabin,
    required double target,
    required double outside,
    required int fanPercent,
    double seconds = 1,
  }) {
    final isBlowing = fanPercent > 0;
    final rate = isBlowing ? 0.02 + 0.10 * fanPercent / 100 : 0.005;
    final goal = equilibrium(isBlowing: isBlowing, target: target, outside: outside);
    final next = cabin + (goal - cabin) * (rate * seconds).clamp(0, 1);
    return (next - goal).abs() < tolerance ? goal : next;
  }

  /// Fan speed chosen in AUTO: stronger the further the cabin is from the target, in 10% steps.
  static int autoFanPercent({required double cabin, required double target}) =>
      (((cabin - target).abs() * 12 / 10).round() * 10).clamp(20, 100);
}
