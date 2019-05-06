# frozen_string_literal: true

module ApiTools
  module DefaultRestModule
    %w[get delete head].each do |word|
      define_method(word) do |path, params = {}, options = {}|
        user_params = base_params.merge(params)
        user_options = default_options.deep_merge(options) # 这里注意一下，是深merge，hash 底下的子hash是merge
        request_dict = build_similar_get_request(word, path, user_params, user_options)
        basic_request(request_dict, user_options)
      end
    end

    %w[post patch put].each do |word|
      define_method(word) do |path, params = {}, options = {}|
        user_params = base_params.merge(params)
        user_options = default_options.deep_merge(options) # 这里注意一下，是深merge，hash 底下的子hash是merge
        request_dict = build_similar_post_request(word, path, user_params, user_options)
        basic_request(request_dict, user_options)
      end
    end

    def build_similar_get_request(word, path, user_params, user_options)
      # 生成类get 请求的URL
      path_params = URI.escape(user_params.collect { |k, v| "#{k}=#{v}" }.join('&'))
      tmp = path.include?('?') ? '&' : '?'
      path = path + tmp + path_params
      url = build_whole_url(path)
      {
        method: word,
        url: url,
        headers: user_options[:header],
        timeout: user_options[:timeout]
      }.merge(user_options[:other_base_execute_option])
    end

    def build_similar_post_request(word, path, user_params, user_options)
      url = build_whole_url(path)
      payload = user_options[:params_to_json] ? user_params.to_json : user_params
      {
        method: word,
        url: url,
        payload: payload,
        headers: user_options[:header],
        timeout: user_options[:timeout]
      }.merge(user_options[:other_base_execute_option])
    end

    def build_whole_url(path)
      web = basic_url
      return web if path.length.zero?
      return path if path.start_with?('http') # path 是一个绝对路径

      if web[-1] == '/'
        path = path[1..-1] if path[0] == '/'
      else
        path = "/#{path}" if path[0] != '/'
      end
      web + path
    end

    def basic_request(request_dict, user_options)
      exception = nil
      user_options[:retry_times].times do
        begin
          response = ::RestClient::Request.execute(request_dict)
          return MultiJson.load(response.body, symbolize_keys: true) if user_options[:response_json]

          return response.body
        rescue RestClient::Exception => e
          exception = e
          next
        end
      end
      puts "Restclient error, body = #{exception.response.body}" if exception.respond_to? :response
      raise exception unless user_options[:ensure_no_exception]

      {
        status: false,
        message: exception.message,
        response_code: exception&.response&.code,
        response_body: exception&.response&.body
      }
    end

    def default_options
      @default_options ||= {
        timeout: 5,
        retry_times: 5,
        response_json: true,
        params_to_json: true,
        ensure_no_exception: false,
        header: { content_type: :json, accept: :json },
        other_base_execute_option: {},
        exception_with_response: true
      }
    end

    def basic_url
      'http://www.example.com' # 子类中复写
    end

    def base_params
      {} # 子类中复写
    end
  end
end
