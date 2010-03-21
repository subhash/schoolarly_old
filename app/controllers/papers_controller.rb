class PapersController < ApplicationController
  def create
    @klass = Klass.find(params[:id])
    #    have to do this since multi-select always returns one empty selection - TODO explore why
    subject_ids = params[:klass][:subject_ids].to(-2)
    subject_ids.each do |subject_id|
      @klass.papers << Paper.create(:subject_id => subject_id)
    end
    @klass.save!
  end
end
