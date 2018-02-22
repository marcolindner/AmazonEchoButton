var btSerial = new (require('bluetooth-serial-port')).BluetoothSerialPort();

var address = '6C-56-97-DF-C9-AE';

function parseInput(message) {
  if (message[0] != 0xf0 || message[message.length-1] != 0xf1) {
    console.log("Incorrect start and end bytes")
    return
  }
  const counter = message[3]
  const dsn = message.slice(8, 24).toString('ascii')
  const tag = message[24]
  const len = message[25]
  const value = message.slice(26, 26 + len)
  const remainder = message.slice(26+len)
  // const state = message[29]
  const sum = message.slice(5, -2).reduce((sum, b) => { return (sum + b) & 0xff }, 0)

  return {
    counter,
    dsn,
    tag,
    len,
    value,
    remainder,
    sum
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
  console.log('> receiving (', buffer.length, 'bytes):', buffer)
  console.log(parseInput(buffer))
}

btSerial.findSerialPortChannel(address, (channel) => {
  console.log('> connecting to', address, 'on', channel)
  btSerial.connect(address, channel, () => {
    btSerial.on('data', incoming)
  }, errorConnecting)
}, notFound)


process.on('SIGINT', () => {
  console.log("> closing bluetooth connection.");
  btSerial.close();
  process.exit();
});
