class ShoutsController < ApplicationController
  def create
    shout = current_user.shouts.create(shout_params)
    redirect_to root_path, redirect_options_for(shout)
  end

  def show
    @shouts = Shout.find(params[:id])
  end

  private

  def shout_params
    { content: content_for_params }
  end

  def content_for_params
    TextShout.new(content_params)
  end

  def content_params
    params.require(:shout).require(:content).permit(:body)
  end

  def redirect_options_for(shout)
    if shout.persisted?
      { notice: "shouted successfully" }
    else
      { alert: "Could not shout" }
    end
  end
end
