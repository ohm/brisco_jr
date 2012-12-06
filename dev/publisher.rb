#!/usr/bin/env ruby

require 'rubygems'
require 'amqp'
require 'json'

KEY = 'brisco.test'

INTERVAL = 0.01

AMQP.start('amqp://guest:guest@127.0.0.1:5672') do |connection|
  exchange =
    AMQP::Channel
      .new(connection)
      .direct(KEY, { durable: true })
  EventMachine::PeriodicTimer.new(INTERVAL) do
    $stdout.puts("#{Time.now} - publishing with #{KEY.inspect}...")
    exchange.publish(
      JSON.dump({
        '123' => {
          'user_id' => rand(1_000_000)
        }
      }),
      { :routing_key => KEY }
    )
  end
end
