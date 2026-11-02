/// Health of a supervised signal, as the receiving gateway sees it.
///
/// Only E2E-protected signals have a status (see `E2eProtectedSignals`); every other
/// signal is always considered [valid].
enum SignalStatus {
  /// Fresh, intact, in sequence.
  valid('VALID'),

  /// Nothing received yet, or the sending ECU is asleep (E2E NODATA / INIT).
  notAvailable('N/A'),

  /// No frame within the timeout: the sender stopped (deadline monitoring).
  stale('STALE'),

  /// Frames arrive but fail the E2E check: corrupted (CRC), repeated or out of sequence.
  invalid('INVALID');

  const SignalStatus(this.label);

  final String label;
}
