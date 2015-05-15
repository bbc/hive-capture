require 'simple_stats_store/server'
require 'simple_stats_store/file_dump'
require 'active_record'
require 'gruff'

class HiveCapture
  class StatsServer
    class Delay < ActiveRecord::Base
    end

    def initialize(options)
      @data_dump = SimpleStatsStore::FileDump.new(options[:data_dump])
      @images = options[:images]
      ActiveRecord::Base.establish_connection(
        adapter: :sqlite3,
        database: options[:database]
      )

      if ! ActiveRecord::Base.connection.table_exists? 'delays'
        ActiveRecord::Schema.define do
          create_table :delays do |d|
            d.column :timestamp, :string
            d.column :device_id, :integer
            d.column :delay, :float
          end
        end
      end
    end

    def start
      t_next = Time.new
      p = SimpleStatsStore::Server.new(
        data_dump: @data_dump,
        models: { delay: Delay }
      ).run do
        if Time.new >= t_next
          image = Gruff::Line.new
          image.title = 'Polling response times'
          image.labels = {}
          cutoff = Time.new - 30 * 60
          6.times do |i|
            image.labels[cutoff.to_i + (i * 5 * 60)] = ((i-6) * 5).to_s
          end
          data = {}
          Delay.where('timestamp > ?', cutoff.to_s).each do |row|
            point = [DataTime.parse(row.timestamp).to_time.to_i, row.delay]
            if data.has_key?(row.device_id.to_s)
              data[row.device_id.to_s] << point
            else
              data[row.device_id.to_s] = [point]
            end
          end
          data.keys.sort{ |a, b| a.to_i <=> b.to_i }.each do |id|
            image.dataxy(id.to_s, data[id].sort { |a, b| a[0] <=> b[0] })
          end
          image.minimum_value = 0
          image.write("#{@images}/delays.png")

          t_next += 30
        end
      end
    end
  end
end
