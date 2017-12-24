From box, DSN (Device Serial Number?) G090RD10744205N8

Pair with MacOS

 * /dev/tty.EchoBtn5N8-SPPSERVER

Pair with Linux

```
[bluetooth]# pair 6C:56:97:DF:C9:AE
Attempting to pair with 6C:56:97:DF:C9:AE
[CHG] Device 6C:56:97:DF:C9:AE Connected: yes
[CHG] Device 6C:56:97:DF:C9:AE Modalias: bluetooth:v1949p0415d0001
[CHG] Device 6C:56:97:DF:C9:AE UUIDs: 00001101-0000-1000-8000-00805f9b34fb //SPP
[CHG] Device 6C:56:97:DF:C9:AE UUIDs: 00001124-0000-1000-8000-00805f9b34fb //HID
[CHG] Device 6C:56:97:DF:C9:AE UUIDs: 00001200-0000-1000-8000-00805f9b34fb
[CHG] Device 6C:56:97:DF:C9:AE UUIDs: 00001201-0000-1000-8000-00805f9b34fb
[CHG] Device 6C:56:97:DF:C9:AE UUIDs: 6088d2b3-983a-4eed-9f94-5ad1256816b7
[CHG] Device 6C:56:97:DF:C9:AE ServicesResolved: yes
[CHG] Device 6C:56:97:DF:C9:AE Paired: yes
Pairing successful
[CHG] Device 6C:56:97:DF:C9:AE ServicesResolved: no
[CHG] Device 6C:56:97:DF:C9:AE Connected: no
```

```
[bluetooth]# info 6C:56:97:DF:C9:AE
Device 6C:56:97:DF:C9:AE
	Name: EchoBtn5N8
	Alias: EchoBtn5N8
	Class: 0x08050a
	Icon: input-gaming
	Paired: yes
	Trusted: no
	Blocked: no
	Connected: no
	LegacyPairing: no
	UUID: Serial Port               (00001101-0000-1000-8000-00805f9b34fb)
	UUID: Human Interface Device... (00001124-0000-1000-8000-00805f9b34fb)
	UUID: PnP Information           (00001200-0000-1000-8000-00805f9b34fb)
	UUID: Generic Networking        (00001201-0000-1000-8000-00805f9b34fb)
	UUID: Vendor specific           (6088d2b3-983a-4eed-9f94-5ad1256816b7)
	Modalias: bluetooth:v1949p0415d0001
	ManufacturerData Key: 0x1949
	ManufacturerData Value: 0x15
	ManufacturerData Value: 0x04
	ManufacturerData Value: 0x71
	ManufacturerData Value: 0x01
	ManufacturerData Value: 0x10
	ManufacturerData Value: 0x15
	ManufacturerData Value: 0x15
	ManufacturerData Value: 0xfe
```


### sdptool records

```
Service RecHandle: 0x10001
Service Class ID List:
  "Human Interface Device" (0x1124)
Protocol Descriptor List:
  "L2CAP" (0x0100)
    PSM: 17
  "HIDP" (0x0011)
Language Base Attr List:
  code_ISO639: 0x656e
  encoding:    0x6a
  base_offset: 0x100
Profile Descriptor List:
  "Human Interface Device" (0x1124)
    Version: 0x0101

Service Name: SPP SERVER
Service RecHandle: 0x10002
Service Class ID List:
  "Serial Port" (0x1101)
Protocol Descriptor List:
  "L2CAP" (0x0100)
  "RFCOMM" (0x0003)
    Channel: 2
Profile Descriptor List:
  "Serial Port" (0x1101)
    Version: 0x0102

Service Name: RFC SERVER
Service RecHandle: 0x10003
Service Class ID List:
  "Generic Networking" (0x1201)
Protocol Descriptor List:
  "L2CAP" (0x0100)
  "RFCOMM" (0x0003)
    Channel: 4
Profile Descriptor List:
  "Generic Networking" (0x1201)
    Version: 0x0102

Service RecHandle: 0x10004
Service Class ID List:
  "PnP Information" (0x1200)
Protocol Descriptor List:
  "L2CAP" (0x0100)
    PSM: 1
  "SDP" (0x0001)

Service Name: gadget
Service RecHandle: 0x10010
Service Class ID List:
  UUID 128: 6088d2b3-983a-4eed-9f94-5ad1256816b7
Protocol Descriptor List:
  "L2CAP" (0x0100)
    PSM: 1
  "SDP" (0x0001)
```

### Experiment with HID

>KERNEL=="hidraw*", ATTRS{busnum}=="1", ATTRS{idVendor}=="1949", ATTRS{idProduct}=="0415", MODE="0666"

```
[1126654.773991] Bluetooth: HIDP (Human Interface Emulation) ver 1.2
[1126654.774023] Bluetooth: HIDP socket layer initialized
[1131076.654412] hid-generic 0005:1949:0415.0001: unknown main item tag 0x0
[1131076.655429] input: EchoBtn5N8 as /devices/platform/soc/3f201000.serial/tty/ttyAMA0/hci0/hci0:12/0005:1949:0415.0001/input/input0
[1131076.656758] hid-generic 0005:1949:0415.0001: input,hidraw0: BLUETOOTH HID v0.01 Keyboard [EchoBtn5N8] on 43:43:a1:12:1f:ac
```

Running hidapi example code:

```
Device Found
  type: 1949 0415
  path: /dev/hidraw0
  serial_number: 6c:56:97:df:c9:ae
  Manufacturer:
  Product:      EchoBtn5N8
```

----

#### RFCOMM experiments

`sudo rfcomm connect /dev/rfcomm0 6C:56:97:DF:C9:AE 4`
`cat /dev/rfcomm0 | hexdump -C`


On connect:
```
  000000f0  f0 02 00 10 01 01 01 10  47 30 39 30 52 44 31 30  |........G090RD10|
  00000100  37 34 34 32 30 35 4e 38  01 0b 00 00 01 02 01 00  |744205N8........|
  00000110  04 00 00 00 00 03 bc f1  f0 02 00 01 01 01 10 47  |...............G|
  00000120  30 39 30 52 44 31 30 37  34 34 32 30 35 4e 38 01  |090RD10744205N8.|
```


Down:
```
  000002e0  00 00 01 03 01 00 04 00  00 00 00 03 bd f1 f0 02  |................|
  000002f0  00 1d 01 01 01 10 47 30  39 30 52 44 31 30 37 34  |......G090RD1074|
  00000300  34 32 30 35 4e 38 01 0b  00 00 01 02 01 00 04 00  |4205N8..........|
```

Up:
```
  00000310  00 00 00 03 bc f1 f0 02  00 1e 01 01 01 10 47 30  |..............G0|
  00000320  39 30 52 44 31 30 37 34  34 32 30 35 4e 38 01 0b  |90RD10744205N8..|
```

NB: Based on macOS swift experiment, I think there is buffering that makes these of unequal length.  I think messages start with 0xf0 and end with 0xf1

