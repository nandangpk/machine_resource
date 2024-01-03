# MachineResource

A lightweight Ruby on Rails gem to gather information about machine resource usage (CPU and RAM)

## Supported Platforms
* Linux

## Requirements
---todo

## Installation
```ruby
gem 'machine_resource', git: 'https://github.com/nandangpk/machine_resource'
```

## Examples
```ruby

  MachineResource.cpu # return: [8.10, 17.4, 9.13, 18.33]
  # each of array value represent the cpu usage percentage per core
  # each of array index represent the cpu core number

  MachineResource.memory('gb') # return: {:total=>7.97, :free=>7.23, :used=>0.34, :cache=>0.39}
  MachineResource.memory('mb') # return: {:total=>7978.1, :free=>7234.5, :used=>349.39, :cache=>394.19} 
  # show current total, free, used, and cache in memory
  # available unit: ['mb', 'gb']

```

## Limitations
This gem basically collect data from `/proc/stat` to get CPU usage and `/proc/meminfo` to get memory usage. It will make this gem support only Linux based operating system

## Tested on:
* Debian 10