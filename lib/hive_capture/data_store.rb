class HiveCapture
  module DataStore
    @devices = {}

    def self.poll_delay(id, delay)
      self.device(id)[:delay] = delay
      self.device(id)[:delay_history][Time.new] = delay
    end

    def self.get_poll_delays
      delays = {}
      @devices.collect do |n, vals|
        delays[n] = vals[:delay] if ! vals[:delay].nil?
      end
      delays
    end

    def self.device(id)
      (@devices[id] = { delay_history: {} } if ! @devices.has_key?(id)) || @devices[id]
    end
  end
end
