#!/usr/bin/env ruby

require 'random-word'
require 'whois'
require 'set'
require 'yaml'

config = {
	tlds: Set.new,
	random: [0],
	domains: Set.new
}

def random(what)
	RandomWord.public_send("#{what}s").find { |a| /^[a-z]+$/ =~ a }
end

ARGV.each do |arg|
	if(match = /^([a-z_]+)=(.+)$/.match(arg))
		key = match[1].to_sym
		config[key] ||= Set.new
		match[2].split(',').each do |val|
			config[key] << val
		end
	else
		config[:domains] << arg
	end
end

config[:random].last.to_i.times do
	config[:domains] << "#{random(:adj)}-#{random(:noun)}"
end

puts config.to_yaml if config[:debug]

checks = []

config[:domains].each do |domain|
	config[:tlds].each do |tld|
		checks << Thread.new do
			full_domain = "#{domain}.#{tld}"
			Thread.current[:available] = Whois.whois(full_domain).available?
			Thread.current[:domain] = full_domain
		end
	end
end

checks.each do |check|
	check.join
	if check[:available]
		puts ":-) #{check[:domain].inspect} is free"
	else
		puts ":-) #{check[:domain].inspect} is taken"
	end
end
