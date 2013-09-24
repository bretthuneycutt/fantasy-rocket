module UrlHelper
  def league_url(league, options = {})
    options[:controller] = 'leagues'
    options[:action] = 'show'
    options[:id] = league.id
    options[:h] = league.hmac
    options[:subdomain] = league.subdomain

    options[:only_path] ||= false

    url_for(options)
  end

  def league_path(league, options = {})
    options[:only_path] = true
    league_url(league, options)
  end

  def share_on_twitter_url(options = {})
    params = {
      :url => options[:url],
      :text => options[:text],
      :related => "fantasyrocket",
    }

    "https://twitter.com/share?#{params.to_param}"
  end

  def share_on_facebook_url(options = {})
    params = {
      :u => options[:url],
    }
    "https://www.facebook.com/sharer/sharer.php?#{params.to_param}"
  end
end
