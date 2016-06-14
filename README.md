# P1 Reader

P1 Reader build with Freepascal. 

# Install

- `apt-get install fpc`
- run `./make` in the project root

# Reader

The parser currently reads the following DSMR4 field:

- 1-3:0.2.8
- 1-0:1.8.1
- 1-0:1.8.2
- 1-0:1.7.0
- 1-0:21.7.0

You can at more fields in the `TelegramParser` class (look for the `ParseLine` method)