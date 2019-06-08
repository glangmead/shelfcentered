require 'open-uri'

class PinsController < ApplicationController
	before_action :find_pin, only: [:show, :edit, :update, :destroy]
	before_filter :authenticate_user!
	
  def index
    @pins = Pin.all.order("created_at desc")
  end
  
  def show
  end

  def new
    @pin = Pin.new
    @pseudopin = Pin.new
    @pin_url = params["url"]
    @pin_title = params["title"]
  end
  
  def create
    @pin = Pin.new(pin_params)
    
    if @pin.save
      flash[:notice] = "Successfully created new pin"
      redirect_to list_path(@pin.lists[0])
    else
      render 'new'
    end
  end

  def load_images
    @images = Array.new
    @message = "Error loading images"
    url = pin_params[:url]
    user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.854.0 Safari/535.2"
    begin
#      openuri_params = {
#        # set timeout durations for HTTP connection
#        # default values for open_timeout and read_timeout is 60 seconds
#        :open_timeout => 1,
#        :read_timeout => 1,
#      }
      
      attempt_count = 0
      max_attempts  = 3
      begin
        attempt_count += 1
        logger.debug "attempt ##{attempt_count}"
        content = open(url, 'User-Agent' => user_agent, :allow_redirections => :safe).read
      rescue OpenURI::HTTPRedirect => e
        url = e.uri
        retry if attempt_count < max_attempts
      rescue OpenURI::HTTPError => e
        # it's 404, etc. (do nothing)
        logger.debug "HTTPError #{e}"
      rescue SocketError, Net::ReadTimeout => e
        # server can't be reached or doesn't send any respones
        logger.debug "error: #{e}"
        sleep 3
        retry if attempt_count < max_attempts
      else
        # connection was successful,
        # content is fetched,
        # so here we can parse content with Nokogiri,
        # or call a helper method, etc.
        url_doc = Nokogiri.parse(content)
      end

      if url_doc != nil
        @images = url_doc.css('img').map{|i| i['src']}.select{|i| i.starts_with?("http") && !i.include?("/sprites/")}
        if @images.size == 0
          @message = "No images found"
        end
      end
    rescue => e
      logger.debug(e.message)
      nil
    end
    image_markup = render_to_string partial: 'images'
    image_markup = image_markup.gsub("\n","")
    js = "$('#image_list').html('#{image_markup}');"
    render js: js
  end
  
  def edit
   @pin_url = @pin.url
   @pin_title = @pin.title
   if ! @pin_is_mine
      flash['error'] = "You do not have permission to perform this operation."
      redirect_to :back
    end    
  rescue ActionController::RedirectBackError
    redirect_to root_path
  end
  
  def update
    if @pin_is_mine
      if @pin.update(pin_params)
        flash[:notice] = "Successfully updated pin"
        redirect_to list_path(@pin.lists[0])
      else
        render 'edit'
      end
    else
      flash['error'] = "You do not have permission to perform this operation."
    end
  rescue ActionController::RedirectBackError
    redirect_to root_path
  end
  
  def destroy
    if @pin_is_mine
      @pin.destroy
    else
      flash['error'] = "You do not have permission to perform this operation."
    end
    redirect_to(:back)
  rescue ActionController::RedirectBackError
    redirect_to root_path
  end
  
  private
  
  def pin_params
    params.require(:pin).permit(:title, :url, :description, :image, :image_remote_url, :role, :list_ids => [])
  end
  
  def find_pin
    @pin = Pin.find(params[:id])
    @pin_is_mine = @pin.user == current_user
    @pin_lists = @pin.lists.select { |list| list.is_visible(current_user) }
  end
end
