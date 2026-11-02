// GENERATED CODE - DO NOT MODIFY BY HAND
// Source: premium.profile.json
// ignore_for_file: type=lint

part of 'factory_profiles.dart';

/// Premium (Highline)
const premiumProfile = VehicleProfile(
  id: 'premium',
  trimName: 'Premium (Highline)',
  driverSide: DriverSide.left,
  supportedPaths: {
    'Vehicle.Speed',
    'Vehicle.Cabin.Door.Row1.DriverSide.IsLocked',
    'Vehicle.Cabin.Door.Row1.DriverSide.IsOpen',
    'Vehicle.Cabin.Sunroof.Position',
    'Vehicle.Cabin.Sunroof.IsFaulted',
  },
  overrides: {
    'Vehicle.Cabin.Sunroof.Position': VssMetaOverride(min: 0),
  },
);
