require "machine_resource/version"

module MachineResource

  def self.cpu
    cpu_usage = []
    data = `sar -P ALL 1 1`.split("\n")
    data.shift; data.shift; data.shift; data.shift
    data.each do |d|
      break if d == ""
      cpu_usage << self.float_2_digit((100 - d.split(" ").last.to_f))
    end
    cpu_usage
  end

  def self.memory(unit)
    return "Invalid unit! accept: ['MB', 'GB']" if unit.upcase != 'MB' && unit.upcase != 'GB'
    memory_usage = nil
    data = `top -bn1 -1`.split("\n")
    data.each do |d|
      next unless d.start_with? "MiB Mem"
      d = d.split(" ")
      memory_usage = {
        total:  self.float_2_digit((unit.upcase == 'MB' ? d[3].to_f : d[3].to_f / 1000)),
        free:   self.float_2_digit((unit.upcase == 'MB' ? d[5].to_f : d[5].to_f / 1000)),
        used:   self.float_2_digit((unit.upcase == 'MB' ? d[7].to_f : d[7].to_f / 1000)),
        cache:  self.float_2_digit((unit.upcase == 'MB' ? d[9].to_f : d[9].to_f / 1000)) 
      }
      break;
    end
    memory_usage
  end

  def self.float_2_digit(number)
    "#{number.to_i}.#{format('%02d', ((number - number.to_i) * 100).to_i)}".to_f
  end
end
