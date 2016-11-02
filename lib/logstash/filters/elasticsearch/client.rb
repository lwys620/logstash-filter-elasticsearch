# encoding: utf-8
require "elasticsearch"
require "base64"

module LogStash
  module Filters
    class ElasticsearchClient

      attr_reader :client

      def initialize(user, password, options={})
        ssl     = options.fetch(:ssl, false)
        hosts   = options[:hosts]
        @logger = options[:logger]

        transport_options = {}
        if user && password
          token = ::Base64.strict_encode64("#{user}:#{password.value}")
          transport_options[:headers] = { Authorization: "Basic #{token}" }
        end

module LogStash
  module Filters
    class ElasticsearchClient

      attr_reader :client

      def initialize(user, password, options={})
        ssl     = options.fetch(:ssl, false)
        hosts   = options[:hosts]
        @logger = options[:logger]

        transport_options = {}
        if user && password
          token = ::Base64.strict_encode64("#{user}:#{password.value}")
          transport_options[:headers] = { Authorization: "Basic #{token}" }
        end
        
        # validate hosts parameters format if ssl is set
        # and populate hosts array with correct protocol/port/scheme
        if ssl  
            ohosts = hosts
            hosts = []
            for h in ohosts
                if not h =~ /https.*:[0-9]+/
                    puts "Elasticsearch filter hosts parameter should be in this format if ssl is set to true: hosts => ['https://hostname:port']"
                    exit
                end   
                h=h.gsub('/','')
                elements=h.split(":")
                hosts << {:host => elements[1], :scheme=> 'https', :protocol=> 'https', :port=> elements[2]}
            end  
        end

        transport_options[:ssl] = { ca_file: options[:ca_file] } if ssl && options[:ca_file]

        @logger.info("New ElasticSearch filter", :hosts => hosts)
        @client = ::Elasticsearch::Client.new(hosts: hosts, transport_options: transport_options)
      end

      def search(params)
        @client.search(params)
      end

    end
  end
end
        transport_options[:ssl] = { ca_file: options[:ca_file] } if ssl && options[:ca_file]

        @logger.info("New ElasticSearch filter", :hosts => hosts)
        @client = ::Elasticsearch::Client.new(hosts: hosts, transport_options: transport_options)
      end

      def search(params)
        @client.search(params)
      end

    end
  end
end
