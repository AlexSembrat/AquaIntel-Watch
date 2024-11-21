//
// Copyright 2019-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.BluetoothLowEnergy;

class ProfileManager {
    public const NANO_SERVICE_UUID = BluetoothLowEnergy.longToUuid(0x1234567812345678L, 0x123456789ABCDEF0L);
    public const CUSTOM_CHARACTERISTIC_UUID = BluetoothLowEnergy.longToUuid(0xABCDEF0112345678L, 0x123456789ABCDEF0L);

    private const _nanoProfileDef = {
    :uuid => NANO_SERVICE_UUID,
    :characteristics => [{
        :uuid => CUSTOM_CHARACTERISTIC_UUID,
        :descriptors => [BluetoothLowEnergy.cccdUuid()] // Enable notifications if needed
    }]
    };

    public function registerProfiles() as Void {
    BluetoothLowEnergy.registerProfile(_nanoProfileDef);
    }

}
