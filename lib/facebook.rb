module OAuth2
  module Clients
    class Facebook < Client
      def initialize(client_id, client_secret, opts = {})
        opts[:site] = '<a href="https://graph.facebook.com/" rel="nofollow">https://graph.facebook.com/</a>'
        super(client_id, client_secret, opts)
      end
    end
  end
end