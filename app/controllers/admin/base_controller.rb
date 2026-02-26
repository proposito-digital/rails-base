class Admin::BaseController < ApplicationController
  include Pagy::Method
  include Translations::TranslationFlashMessages
  include SidebarConcerns
  include Pundit::Authorization
  before_action { Pagy::I18n.locale = params[:locale] }
  before_action :set_menu # SidebarConcerns
  before_action :set_model_class
  before_action :set_instance_and_authorize, only: %i[ show edit update destroy ]

  def pundit_user
    true
  end
  # GET /admin instance/or /admin.instance/json
  def index
    @pagy, @instances = pagy(@model.all, limit: 1)
    authorize @instances, policy_class: DogPolicy
  end

  # GET /admin/instance/1 or /admin/instance/1.json
  def show
  end

  # GET /admin/instance/new
  def new
    @instance = @model.new
    authorize @instance
  end

  # GET /admin/instance/1/edit
  def edit
  end

  # POST /admin instance/or /admin.instance/json
  def create
    @instance = @model.new(instance_params)
    authorize @instance

    respond_to do |format|
      if @instance.save
        format.html { redirect_to self.send(redirect_to_index), flash: { success: translate_flash("success") } }
        format.json { render :show, status: :created, location: @instance }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @instance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /admin/instance/1 or /admin/instance/1.json
  def update
    respond_to do |format|
      if @instance.update(instance_params)
        format.html { redirect_to self.send(redirect_to_index), flash: { success: translate_flash("success") } }
        format.json { render :show, status: :ok, location: @instance }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @instance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/instance/1 or /admin/instance/1.json
  def destroy
    @instance.destroy!

    respond_to do |format|
      format.html { redirect_to self.send(redirect_to_index), flash: { success: translate_flash("success") } }
      # format.html { redirect_to cats_path, status: :see_other, notice: "Cat was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  protected

    def underscore_model_class
      @instance.class.name.underscore.pluralize
    end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_instance_and_authorize
      @instance = @model.find(params.expect(:id))
      authorize @instance
    end

    def redirect_to_index
      # Exemple: admin/dogs
      controller = params[:controller]
      namespace = controller.gsub("/", "_")
      # namespace = controller.gsub("/", "_")[6..]
      "#{namespace}_path"
    end

    def set_model_class
      @model = params[:controller].gsub("admin/", "").classify.constantize
    end

    def default_param_required
      @model.to_s.underscore.sub("/", "_").to_sym
    end

    def default_params_permited
      []
    end

    def instance_params
      # Resulte exemple: dog: [ :name, :age, :deleted_at ]
      params.require(default_param_required).permit(default_params_permited)
    end
end
