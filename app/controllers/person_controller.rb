class PersonController < ApplicationController
  def index
    @people_leaves = Person.find_for(params[:effective_date])
    render json: @people_leaves, include: [:person_content]
  end

  def create
    @person = Person.new(params["person"])
    @person.save
    render json: @person
  end

  private
  def person_params
    params.require(:person).require(:first_name, :last_name, :manager_id, :effective_on)
  end
end
