class PapersController < ApplicationController
  def create
    @klass = Klass.find(params[:id])
    #    have to do this since multi-select always returns one empty selection - TODO explore why
    subject_ids = params[:klass][:subject_ids].to(-2)
    @subjects = Subject.find(subject_ids)
    @subjects.each do |subject|
      puts "subject = "+subject.inspect
      paper = Paper.new
      paper.subject = subject
      paper.klass = @klass
      puts "paper = "+paper.inspect
      paper.save
    end
    @klass.save!
    @all_subjects = Subject.find(:all)
  end
end
