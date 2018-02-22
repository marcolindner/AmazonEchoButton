var btSerial = new (require('bluetooth-serial-port')).BluetoothSerialPort();

var address = '6C-56-97-DF-C9-AE';

function parseInput(message) {
  if (message[0] != 0xf0 || message[message.length-1] != 0xf1) {
    console.log("Incorrect start and end bytes")
    return
  }
  const counter = message[3]
  const dsn = message.slice(8, 24).toString('ascii')
  const state = message[29]

  return {
    counter,
    dsn,
    state
  }
}

function connected() {
}

function errorConnecting() {
  console.log('> cannot connect');
}

function notFound() {
  console.log('found nothing');
}

function incoming(buffer) {
  console.log('> receiving ('+buffer.length+' bytes):', buffer);
  console.log(parseInput(buffer))

  var isPressed = buffer[buffer.length-2] == 0xc0;
  console.log(' >> button is ' + (isPressed?'pressed':'released'));

}

btSerial.findSerialPortChannel(address, (channel) => {
  btSerial.connect(address, channel, () => {
    console.log('> connected to ' + address);
    btSerial.on('data', incoming)
  }, errorConnecting)
}, notFound)


process.on('SIGINT', () => {
  console.log("> closing bluetooth connection.");
  btSerial.close();
  process.exit();
});
