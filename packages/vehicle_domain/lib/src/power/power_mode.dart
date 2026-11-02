import '../broker/signal_reader.dart';
import '../vss/vss.dart';
import '../vss/vss_signal.dart';
import '../vss/vss_values.dart';

/// Vehicle power mode, as a vehicle mode manager (VMM) sees it.
///
/// It is *derived* from COVESA signals, so the broker stays the single source of truth:
/// `LowVoltageSystemState` (12 V supply), `TractionBattery.IsPowerConnected` (HV contactors),
/// `Charging.IsCharging` and `OTA.IsInstalling`.
enum PowerMode {
  /// 12 V in LOCK: buses asleep, only wake-up sources (key, door handle) listen.
  sleep('SLEEP'),

  /// Car off but awake: control units powered, about to go to sleep.
  off('OFF'),

  /// Accessory: infotainment and comfort, no driving functions.
  accessory('ACC'),

  /// Ignition on, high voltage still disconnected.
  on('ON'),

  /// High voltage connected: ready to drive.
  ready('READY'),

  /// Charging: high voltage connected to the charger, driving inhibited.
  charging('CHARGING'),

  /// Software update: the car is unusable until the installation ends.
  softwareUpdate('SW UPDATE');

  const PowerMode(this.label);

  final String label;

  /// Signals the mode is derived from. Rules and providers watch them.
  static Set<VssSignal<Object>> get inputs => {
    Vss.Vehicle.LowVoltageSystemState,
    Vss.Vehicle.Powertrain.TractionBattery.IsPowerConnected,
    Vss.Vehicle.Powertrain.TractionBattery.Charging.IsCharging,
    Vss.Vehicle.Software.OTA.IsInstalling,
  };

  /// Current mode, or `null` when the vehicle reports no 12 V state (older trims, unit tests):
  /// then nothing is gated by power mode, and the safety rules still apply.
  static PowerMode? from(SignalReader signals) {
    final lowVoltage = signals.read(Vss.Vehicle.LowVoltageSystemState);
    if (lowVoltage == null) return null;
    if (signals.read(Vss.Vehicle.Software.OTA.IsInstalling) ?? false) return softwareUpdate;
    // Charging before READY: the HV contactors are also closed while charging.
    if (signals.read(Vss.Vehicle.Powertrain.TractionBattery.Charging.IsCharging) ?? false) return charging;

    final isHighVoltageConnected = signals.read(Vss.Vehicle.Powertrain.TractionBattery.IsPowerConnected) ?? false;
    return switch (lowVoltage) {
      LowVoltageSystemState.on || LowVoltageSystemState.start when isHighVoltageConnected => ready,
      LowVoltageSystemState.on || LowVoltageSystemState.start => on,
      LowVoltageSystemState.acc => accessory,
      LowVoltageSystemState.off => off,
      _ => sleep,
    };
  }
}
