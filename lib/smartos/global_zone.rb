module SmartOS
  class GlobalZone
    attr_reader :imgadm

    def initialize(ssh)
      @imgadm = Imgadm.new(ssh)
    end

    def self.connect(host, &block)
      Net::SSH.start(host, 'root') do |ssh|
        gz = GlobalZone.new(ssh)
        gz.instance_eval(&block)
      end
    end
  end
end