//
// Copyright 2019-2021 by Garmin Ltd. or its subsidiaries.
// Subject to Garmin SDK License Agreement and Wearables
// Application Developer Agreement.
//

import Toybox.BluetoothLowEnergy;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.UserProfile;

class EnvironmentProfileModel {
    private var _service as Service?;
    private var _profileManager as ProfileManager;
    private var _pendingNotifies as Array<Characteristic>;
    
    private var _value as Numeric?;
    private var _prediction as Numeric?;

    private var _writeQueue as Array<WriteRequest>;
    private var _writeInProgress as Boolean = false;

    public var setupComplete as Boolean = false;

    public var waitingForPrediction as Boolean = true;

    //! Constructor
    //! @param delegate The BLE delegate for the model
    //! @param profileManager The profile manager for this model
    //! @param device The current device
    public function initialize(delegate as ThingyDelegate, profileManager as ProfileManager, device as Device) {
        delegate.notifyDescriptorWrite(self);
        delegate.notifyCharacteristicChanged(self);
        delegate.notifyCharacteristicWrite(self);

        _profileManager = profileManager;
        _service = device.getService(profileManager.NANO_SERVICE_UUID);  // Updated service UUID

        _pendingNotifies = [];
        _writeQueue = [];

        var service = _service;
        if (service != null) {
            var characteristic = service.getCharacteristic(profileManager.CUSTOM_CHARACTERISTIC_UUID); // Updated characteristic UUID
            if (null != characteristic) {
                _pendingNotifies = _pendingNotifies.add(characteristic);
            }

            characteristic = service.getCharacteristic(profileManager.PREDICTION_CHAR_UUID);
            if (null != characteristic) {
                _pendingNotifies = _pendingNotifies.add(characteristic);
            }
        }
        sendProfileData();
        activateNextNotification();
        setupComplete = true;
    }

    public function sendProfileData(){
        var profile = UserProfile.getProfile();
        
        var age = 2025 - profile.birthYear;
        var gender = profile.gender;
        var height = profile.height;
        var weight = profile.weight;

        var hr_zones = UserProfile.getHeartRateZones(UserProfile.HR_ZONE_SPORT_GENERIC);

        var hr_z2_max = hr_zones[2];

        processCharWrite(age, _profileManager.AGE_CHAR_UUID);
        processCharWrite(gender, _profileManager.GENDER_CHAR_UUID);
        processCharWrite(height, _profileManager.HEIGHT_CHAR_UUID);
        processCharWrite(weight, _profileManager.WEIGHT_CHAR_UUID);
        processCharWrite(hr_z2_max, _profileManager.HEARTRATE_CHAR_UUID);

    }

    public function sendDurationData(duration as Numeric){
        processCharWrite(duration, _profileManager.DURATION_CHAR_UUID);
        waitingForPrediction = true;
    }

    public function onCharacteristicChanged(char as Characteristic, value as ByteArray) as Void {
        System.println("Characteristic Changed UUID: " + char.getUuid());
        System.println("Raw Value: " + value);
        switch (char.getUuid()) {
            case _profileManager.CUSTOM_CHARACTERISTIC_UUID:  // Handle your custom characteristic
                processCustomData(value);
                break;
            case _profileManager.PREDICTION_CHAR_UUID:  // Handle your custom characteristic
                processPrediction(value);
                break;
        }
    }


    //! Handle the completion of a write operation on a descriptor
    //! @param descriptor The descriptor that was written
    //! @param status The BluetoothLowEnergy status indicating the result of the operation
    public function onDescriptorWrite(descriptor as Descriptor, status as Status) as Void {
        // if (BluetoothLowEnergy.cccdUuid().equals(descriptor.getUuid())) {
        //     processCccdWrite();
        // }

        if (status == BluetoothLowEnergy.STATUS_SUCCESS) {
            System.println("Descriptor write OK: " + descriptor.getUuid());
        } else {
            System.println("Descriptor write failed: " + status);
        }

        dequeueWrite();
        processNextWrite();
    }

    //! Handle the completion of a write operation on a descriptor
    //! @param descriptor The descriptor that was written
    //! @param status The BluetoothLowEnergy status indicating the result of the operation
    public function onCharacteristicWrite(char as Characteristic, status as Status) as Void {
        if (status == BluetoothLowEnergy.STATUS_SUCCESS) {
            System.println("Char write OK: " + char.getUuid());
        } else {
            System.println("Char write failed: " + status);
        }

        dequeueWrite();
        processNextWrite();
    }

    public function getValue() as Numeric? {
        System.println("value1="+_value);
        return _value;
    }

    public function getPrediction() as Numeric? {
        System.println("value1="+_prediction);
        return _prediction;
    }

    public function nullPrediction() as Void {
        _prediction = null;
    }

    private function queueWrite(target, value as ByteArray, opts as Dictionary or Null) as Void {
        var entry = new WriteRequest(target, value, opts);
        _writeQueue = _writeQueue.add(entry);

        if (!_writeInProgress) {
            processNextWrite();
        }
    }

    private function processNextWrite() as Void {
        if (_writeQueue.size() == 0) {
            _writeInProgress = false;
            return;
        }

        _writeInProgress = true;

        var entry = _writeQueue[0];

        try {
            if (entry.target instanceof Descriptor) {
                entry.target.requestWrite(entry.value);
                // _writeQueue = _writeQueue.remove(0);
                System.println(_writeQueue);
            } else if (entry.target instanceof Characteristic) {
                entry.target.requestWrite(entry.value, entry.opts);
                // _writeQueue = _writeQueue.remove(0);
                System.println(_writeQueue);
            }
        } catch (e) {
            System.println("Write error: " + e.toString());
            dequeueWrite();
            processNextWrite();
        }
    }


    public function setChar(duration as Numeric, uuid as BluetoothLowEnergy.Uuid) as Void{
        var char = _service.getCharacteristic(uuid);
        if (char != null) {
            var byteArray = new [2]b;
            byteArray.encodeNumber(duration, NUMBER_FORMAT_UINT16, null);
            queueWrite(char, byteArray, {:writeType => BluetoothLowEnergy.WRITE_TYPE_WITH_RESPONSE});
        } else {
            System.println("Duration char is null");
        }
    }

    //! Write the next notification to the descriptor
    private function activateNextNotification() as Void {
        if (_pendingNotifies.size() == 0) {
            return;
        }

        var char = _pendingNotifies[0];
        System.print(char.getUuid() + "\n");
        var cccd = char.getDescriptor(BluetoothLowEnergy.cccdUuid());
        if (cccd != null) {
            queueWrite(cccd, [0x01, 0x00]b, null);
        }

        char = _pendingNotifies[1];
        System.print(char.getUuid() + "\n");
        cccd = char.getDescriptor(BluetoothLowEnergy.cccdUuid());
        if (cccd != null) {
            queueWrite(cccd, [0x01, 0x00]b, null);
        }
    }

    //! Process a CCCD write operation
    private function processCccdWrite() as Void {
        if (_pendingNotifies.size() > 0) {
            _pendingNotifies.remove(0);
        }

        if (_pendingNotifies.size() > 0) {
            activateNextNotification();
        }

    }

    private function processCharWrite(value as Numeric, uuid as BluetoothLowEnergy.Uuid) as Void {
        setChar(value, uuid);
    }

    private function processCustomData(value as ByteArray) as Void {
        if (value.size() != 2) { // Expecting 1 byte
            System.println("Unexpected data size: " + value.size());
            return;
        }
        _value = value.decodeNumber(Lang.NUMBER_FORMAT_UINT16, {});
        System.println("Decoded value: " + _value);
        WatchUi.requestUpdate();  // Refresh UI
    }

    private function processPrediction(value as ByteArray) as Void {
        if (value.size() != 2) { // Expecting 1 byte
            System.println("Unexpected data size: " + value.size());
            return;
        }
        _prediction = value.decodeNumber(Lang.NUMBER_FORMAT_UINT16, {});
        System.println("Decoded prediction: " + _prediction);
        waitingForPrediction = false;
        WatchUi.requestUpdate();  // Refresh UI
    }

    private function dequeueWrite() as Void {
        var newQueue = [];

        if( _writeQueue.size() > 1 ){
            for (var i = 1; i < _writeQueue.size(); i++) {
                newQueue  = newQueue.add(_writeQueue[i]);
            }
            _writeQueue = newQueue;
        }
        else{
           _writeQueue = []; 
        }
    }

}


class WriteRequest {
    var target;
    var value;
    var opts;

    function initialize(target, value, opts) {
        self.target = target;
        self.value = value;
        self.opts = opts;
    }
}