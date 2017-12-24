var HID = require('node-hid');

const pid = 0x0415
const vid = 0x1949

var devices = HID.devices();
var device;

devices.forEach((device) => {
  if (device.product == "EchoBtn5RK") {
    console.log(device);
    device = new HID.HID(device.path);
  }
})

if(device) {
  device.on("data", function(data) {
    console.log(data);
  });

  device.on("error", function(err) {
    console.error(err);
  });
}


/*
{ vendorId: 6473,
productId: 1045,
path: 'IOService:/IOResources/IOBluetoothHCIController/AppleBroadcomBluetoothHostController/IOBluetoothDevice/IOBluetoothL2CAPChannel/IOBluetoothHIDDriver',
serialNumber: '50-dc-e7-73-49-43',
manufacturer: 'Unknown',
product: 'EchoBtn5RK',
release: 1,
interface: -1,
usagePage: 1,
usage: 6 }
*/


