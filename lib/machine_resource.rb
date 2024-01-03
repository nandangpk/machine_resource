require "machine_resource/version"

module MachineResource

  def self.cpu
    cpu = []
  
    init_cpu_stats = File.readlines('/proc/stat').grep(/^cpu/).drop(1).map { |line| line.split.map(&:to_i) }
    sleep(1)
    curr_cpu_stats = File.readlines('/proc/stat').grep(/^cpu/).drop(1).map { |line| line.split.map(&:to_i) }
  
    curr_cpu_stats.count.times do |i|
      init_idle = init_cpu_stats[i].sum - init_cpu_stats[i][4]
      curr_idle = curr_cpu_stats[i].sum - curr_cpu_stats[i][4]
    
      init_total = init_cpu_stats[i].sum 
      curr_total = curr_cpu_stats[i].sum 
    
      total_delta = curr_total - init_total
      idle_delta = curr_idle - init_idle
    
      usage_percentage = 100.0 * (total_delta - idle_delta) / total_delta if total_delta > 0
      cpu.push ((100 - usage_percentage).round(2)) 
    end
    cpu
  end

  def self.memory(unit = "")
    return "Invalid or missing unit parameter, accept: ['MB', 'GB']" if unit.upcase != 'MB' && unit.upcase != 'GB'
    total = (File.readlines('/proc/meminfo').grep(/^MemTotal/)[0].split(" ")[1].to_f / (unit.upcase == 'MB' ? 1024 : 1048576)).round(2)
    free = (File.readlines('/proc/meminfo').grep(/^MemFree/)[0].split(" ")[1].to_f / (unit.upcase == 'MB' ? 1024 : 1048576)).round(2)
    cache = ((File.readlines('/proc/meminfo').grep(/^Buffers/)[0].split(" ")[1].to_f / (unit.upcase == 'MB' ? 1024 : 1048576)) + (File.readlines('/proc/meminfo').grep(/^Cached/)[0].split(" ")[1].to_f / (unit.upcase == 'MB' ? 1024 : 1048576))).round(2)
    used = (total - free - cache).round(2)
    
    {
      total: total,
      free: free,
      used: used,
      cache: cache
    }
  end
end
