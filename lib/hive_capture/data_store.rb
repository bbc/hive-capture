require 'gruff'

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

    def self.get_poll_history
      cutoff = Time.new - 30 * 60
      delays = {}
      image = Gruff::Line.new
      image.title = 'Polling response times'
      image.labels = {
        cutoff.to_i => '0',
        cutoff.to_i + 5 * 60 => '5',
        cutoff.to_i + 10 * 60 => '10',
        cutoff.to_i + 15 * 60 => '15',
        cutoff.to_i + 20 * 60 => '20',
        cutoff.to_i + 25 * 60 => '25',
        cutoff.to_i + 30 * 60 => '30',
      }
      @devices.collect do |n, vals|
        delays[n] = []
        vals[:delay_history].each do |t, d|
          if t < cutoff
             vals.delete(t)
          else
            delays[n] << [t.to_i, d]
          end
        end
        delays[n].each do |thing|
          p thing
        end
        delays[n].sort! { |a, b| a[0] <=> b[0] }
        image.dataxy(n.to_s, delays[n])
      end
      image.write('/home/vmuser/titantv/public/delays.png')
      delays
    end

    def self.device(id)
      (@devices[id] = { delay_history: {} } if ! @devices.has_key?(id)) || @devices[id]
    end
  end
end
