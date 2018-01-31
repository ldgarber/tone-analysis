class SearchesController < ApplicationController 
  
  def search
  end

  def analyze_tone
    @text = params[:text]
    begin
      conn = Faraday.new(:url => 'https://gateway.watsonplatform.net/tone-analyzer/api/v3/tone') 
      conn.basic_auth(ENV["WATSON_USERNAME"], ENV["WATSON_PASSWORD"])

      @response = conn.get do |req| 
        req.params["content_type"] = "text/plain"
        req.params["text"] = params[:text]
        req.params["version"] = "2018-01-31"
      end
      body_hash = JSON.parse(@response.body)
      if @response.success? 
        @tones = body_hash["document_tone"]["tones"]
      else 
        @error = body_hash["error"]
      end

    rescue Faraday::TimeoutError
      @error = "There was a timeout. Please try again."
    end
    render 'search'
  end

end
