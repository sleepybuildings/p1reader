# P1 Reader

A simple P1 Reader build with Freepascal. 

# Install

- Install Freepascal `apt-get install fpc`
- run `./build` in the project root


# Configuration

p1reader needs an configuration file in order to run. Look for an example and a description of all the options in the `conf` directory.


# Usage

Run the app by specifying the configuration file as the first parameter:

`p1reader ../myconfig.conf` 

Press [ESC] to stop.


# Storage Drivers

p1reader needs to store the received telegrams. You can set the storage though the `generic.storage` option.

The currently supported storagedrivers are:

- `log` - Write an csv file. Specify the filename with the `generic.log` entry.


# Meter fields

The parser currently reads the following DSMR4 field:

- 1-3:0.2.8
- 1-0:1.8.1
- 1-0:1.8.2
- 1-0:1.7.0
- 1-0:21.7.0

You can add more fields in the `TelegramParser` class (look for the `ParseLine` method).

# Dependencies

- Synapse v40 (modified) for serial communication http://synapse.ararat.cz/

# Todo

- Mysql/MariaDB storage driver
- Demon version