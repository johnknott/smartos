module SmartOS
  class GlobalZone
    attr_reader :ssh
    include SmartOS::Commands

    def self.connect(host, &block)
      Net::SSH.start(host, 'root') do |ssh|
        gz = GlobalZone.new(ssh)
        gz.instance_eval(&block)
      end
    end

    def self.is_global_zone?(host)
      Net::SSH.start(host, 'root', timeout: 5) do |ssh|
        if ssh.exec!('/usr/bin/zonename').strip == 'global'
          return ssh.exec!('/usr/bin/uname -a').strip
        end
      end
      nil
    rescue => e
      #puts e.message
    end

    def initialize(ssh)
      @ssh = ssh
      all_binaries = remote_exec!('compgen -c').split("\n")
      unwanted_binaries = remote_exec!('compgen -A function -abk').split("\n")
      wanted_binaries = all_binaries - unwanted_binaries

      wanted_binaries.each do |res| 
        self.class.send(:define_method, res, ->(arguments=''){remote_exec "#{res} #{arguments}"})
        self.class.send(:define_method, res + '!', ->(arguments=''){remote_exec! "#{res} #{arguments}"})
      end
    end

  end
end