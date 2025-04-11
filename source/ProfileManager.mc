//
// Copyright 2019-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.BluetoothLowEnergy;

class ProfileManager {
    public const NANO_SERVICE_UUID = BluetoothLowEnergy.longToUuid(0x1234567812345678L, 0x123456789ABCDEF0L);
    public const CUSTOM_CHARACTERISTIC_UUID = BluetoothLowEnergy.longToUuid(0xABCDEF0112345678L, 0x123456789ABCDEF0L);
    public const AGE_CHAR_UUID           = BluetoothLowEnergy.longToUuid(0xABCDEF0212345678L, 0x123456789ABCDEF0L);
    public const HEIGHT_CHAR_UUID        = BluetoothLowEnergy.longToUuid(0xABCDEF0312345678L, 0x123456789ABCDEF0L);
    public const WEIGHT_CHAR_UUID        = BluetoothLowEnergy.longToUuid(0xABCDEF0412345678L, 0x123456789ABCDEF0L);
    public const DURATION_CHAR_UUID      = BluetoothLowEnergy.longToUuid(0xABCDEF0512345678L, 0x123456789ABCDEF0L);
    public const HEARTRATE_CHAR_UUID     = BluetoothLowEnergy.longToUuid(0xABCDEF0612345678L, 0x123456789ABCDEF0L);
    public const PREDICTION_CHAR_UUID    = BluetoothLowEnergy.longToUuid(0xABCDEF0712345678L, 0x123456789ABCDEF0L);
    public const GENDER_CHAR_UUID        = BluetoothLowEnergy.longToUuid(0xABCDEF0812345678L, 0x123456789ABCDEF0L);


    private const _nanoProfileDef = {
        :uuid => NANO_SERVICE_UUID,
        :characteristics => [
            {
                :uuid => CUSTOM_CHARACTERISTIC_UUID,
                :descriptors => [BluetoothLowEnergy.cccdUuid()] // Enables notifications (and/or indications)
            },
            {
                :uuid => AGE_CHAR_UUID,
                :descriptors => [BluetoothLowEnergy.cccdUuid()]
            },
            {
                :uuid => HEIGHT_CHAR_UUID,
                :descriptors => [BluetoothLowEnergy.cccdUuid()]
            },
            {
                :uuid => WEIGHT_CHAR_UUID,
                :descriptors => [BluetoothLowEnergy.cccdUuid()]
            },
            {
                :uuid => DURATION_CHAR_UUID,
                :descriptors => [BluetoothLowEnergy.cccdUuid()]
            },
            {
                :uuid => HEARTRATE_CHAR_UUID,
                :descriptors => [BluetoothLowEnergy.cccdUuid()]
            },
            {
                :uuid => PREDICTION_CHAR_UUID,
                :descriptors => [BluetoothLowEnergy.cccdUuid()]
            },
            {
                :uuid => GENDER_CHAR_UUID,
                :descriptors => [BluetoothLowEnergy.cccdUuid()]
            }
        ]
    };

    public function registerProfiles() as Void {
    BluetoothLowEnergy.registerProfile(_nanoProfileDef);
    }

}
