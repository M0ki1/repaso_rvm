class TweetsController < ApplicationController
    def index
        @tweets = Tweet.all
    end
    def show
        @tweet = Tweet.find params[:id]
    end

    def new
        @tweet = Tweet.new
    end

    def create
        puts "LLEGUE"

        tweet = Tweet.new tweet_params
        tweet.user = current_user
        if tweet.save
            redirect_to tweet,notice: "Tweet guardado con exito"    
        else
            render :new
        end
    end
    def destroy
        puts"hola"
        tweet = Tweet.find params[:id]
        tweet.destroy
        redirect_to tweets_path, notice:"Tweet eleiminado con exito"

    end

    private

    def tweet_params
        params.require(:tweet).permit(:body)
    end

  
end