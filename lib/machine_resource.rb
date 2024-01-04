require 'ffi'
require "machine_resource/version"

module MachineResource
  module Memory
    extend FFI::Library
    current_directory = File.dirname(__FILE__)
    ffi_lib File.join(current_directory, '../ext/machine_resource/memory.so')
    class MemoryInfo < FFI::Struct
      layout :total, :float,
             :free, :float,
             :used, :float,
             :cache, :float
    end
    attach_function :get_memory_info, [:string], MemoryInfo.by_value
  end

  module CPU
    extend FFI::Library
    current_directory = File.dirname(__FILE__)
    ffi_lib File.join(current_directory, '../ext/machine_resource/cpu.so')
    attach_function :get_cpu_info, [], :pointer
  end


  ######

  def self.cpu
    cpu = MachineResource::CPU::get_cpu_info.read_array_of_float(64)
    cpu.delete_if { |number| number < 300 || number.nan? || number > 400};
    cpu.map! {|number| (number - 300).round(2)}
    cpu
  end

  def self.memory(unit = "")
    return "Invalid or missing unit parameter, accept: ['MB', 'GB']" if unit.upcase != 'MB' && unit.upcase != 'GB'
    
    mem = Memory::get_memory_info(unit.upcase)
    {
      total:  mem[:total].round(2),
      free:   mem[:free].round(2),
      used:   mem[:used].round(2),
      cache:  mem[:cache].round(2)
    }
  end
end