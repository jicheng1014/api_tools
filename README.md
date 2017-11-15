# ApiTools
[![Build Status](https://travis-ci.org/jicheng1014/api_tools.svg?branch=master)](https://travis-ci.org/jicheng1014/api_tools)

## 简介
一些自用的工具
- DefaultRest， 发起默认REST


## 使用

### add to Gemfile
gem 'api_tools', :git => 'https://github.com/jicheng1014/api_tools.git'

## 任意对象

直接使用  DefaultRest.post(url, xxx)    



```ruby
class XXXService < DefaultRest
  # override（option）
  def default_options
    # 默认的参数
    {
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

  # override (must)
  def basic_url
    # 填写基础版本的url
  end

  #override (option)
  def base_params
    # 默认每次提交时候附带的默认参数
    {}
  end
end
```
