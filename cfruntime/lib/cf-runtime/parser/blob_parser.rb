module CFRuntime
  class BlobParser
    def self.parse(svc)
      serviceopts = {}
      { :username => :username,
        :password => :password,
        :hostname => :host,
        :port => :port
      }.each do |from, to|
        serviceopts[to] = svc["credentials"][from.to_s]
      end
      serviceopts
    end
  end
end
