class SurveysController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  before_action :set_survey, only: [:show, :edit, :update]



  # GET /surveys
  # GET /surveys.json
  def index
    @surveys = Survey.all
    @surveys = policy_scope(Survey).order(created_at: :asc)
  end

  # GET /surveys/1
  # GET /surveys/1.json
  def show
    # @survey = Survey.find(params[:id])
    @user = current_user
    @survey = @user.surveys.last

    @housing = 0
    @housing += 1 if @survey.housing_type != nil
    @housing += 1 if @survey.area != nil
    @housing += 1 if @survey.heat_type != nil
    @housing += 1 if @survey.adults_inhabitants != nil
    @housing += 1 if @survey.children_inhabitants != nil
    @housing +=1 if @survey.house_temp != nil

    @trash = 0
    @trash += 1 if @survey.upcycling != nil
    @trash += 1 if @survey.green_invest != nil

    @transport = 0
    @transport += 1 if @survey.vehicule_km != nil
    @transport += 1 if @survey.fuel_type != nil
    @transport += 1 if @survey.public_transp != nil

    @food =0
    @food += 1 if @survey.vegetable_season != nil
    @food += 1 if @survey.eating_habits != nil
    @food += 1 if @survey.bio_buyings != nil

    # redirect_to survey_path(@survey)
    authorize @survey
  end

  # GET /surveys/1/edit
  def edit
    @user = current_user
    authorize @survey

  end

  # POST /surveys
  # POST /surveys.json
  def create
    @survey = Survey.create(user: current_user)
    redirect_to survey_path(@survey)
    authorize @survey
  end

  # PATCH/PUT /surveys/1
  # PATCH/PUT /surveys/1.json
  def update
    # @user = current_user
    # @survey = @user.survey.last
    @survey.update(survey_params)
    current_user.score = @survey.total_user_score_updated
    current_user.save
    redirect_to survey_path(@survey)
    authorize @survey
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_survey
      @survey = Survey.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def survey_params
      params.require(:survey).permit(:heat_type, :house_appartment, :area, :house_inhabitants, :adults_inhabitants, :children_inhabitants, :house_temp, :housing_type, :energy_class, :vegetable_season, :eating_habits, :bio_buyings, :vehicule_km, :fuel_type, :public_transp, :upcycling, :green_invest )
    end
end
