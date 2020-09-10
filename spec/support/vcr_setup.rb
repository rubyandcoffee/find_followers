VCR.configure do |c|
  #the directory where your cassettes will be saved
  c.cassette_library_dir = 'spec/vcr'
  # your HTTP request service.
  c.hook_into :webmock
  c.configure_rspec_metadata!

  c.default_cassette_options = {
    # :match_requests_on => [:method, VCR.request_matchers.uri_without_param(:token)]
    :match_requests_on => [:method, :no_basic_auth]
  }

  c.register_request_matcher :no_basic_auth do |req1, req2|
    (URI(req1.uri).scheme == URI(req2.uri).scheme) &&
    (URI(req1.uri).host == URI(req2.uri).host) &&
    (URI(req1.uri).path == URI(req2.uri).path) &&
    (URI(req1.uri).query == URI(req2.uri).query)
  end
end
