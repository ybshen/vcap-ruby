module CFRuntime
  class RabbitmqParser
    def self.parse(svc)
      serviceopts = {}
      cred = svc["credentials"]
      vhost = cred["vhost"] || "/" #The RabbitMQ default vhost
      if cred["url"]
        # The new "srs" credentials format
        uri=URI.parse(cred["url"])
        user=URI.unescape(uri.user) if uri.user
        passwd=URI.unescape(uri.password) if uri.password
        host=uri.host
        port=uri.port
        if uri.path =~ %r{^/(.*)}
          raise ArgumentError.new("multiple segments in path of amqp URI: #{uri}") if $1.index('/')
          vhost = URI.unescape($1)
        end
        serviceopts[:url] = cred["url"]
      else
        # The "old" credentials format
        user,passwd,host,port = %w(user pass hostname port).map {|key|
          cred[key]}
        serviceopts[:url]  = "amqp://#{user}:#{passwd}@#{host}:#{port}"
        serviceopts[:url] = "#{serviceopts[:url]}/#{vhost}" if vhost != "/"
      end
      serviceopts[:username] = user
      serviceopts[:password] = passwd
      serviceopts[:host] = host
      serviceopts[:port] = port
      serviceopts[:vhost] = vhost
      serviceopts
    end
  end
end